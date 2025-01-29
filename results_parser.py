#!/usr/bin/env python3
"""
The purpose of this script to convert the results of the experiments into latex
or html tables.

The format of the results is as follows:
- root_dir
  - DataStructureA_1.out
  - DataStructureA_2.out
  - ...
  - DataStructureB_1.out
  - DataStructureB_2.out
  - ...

Files of the form DataStructureName_i.dir contain in the last two lines the
outcome of the test and the time taken to reach the end. A data structure
that passes will have lines of the following structure:

N schedules generated.  All tests pass.
Time (seconds) = 0.000

A data structure that fails will have lines of the following structure:

AMPVer: error detected on schedule x.  Exiting.
Time (seconds) = 0.000
"""

import os
import re
from typing import Dict, List, Tuple, Optional
import argparse

def find_source_path(root_dir: os.PathLike, fname: str) -> str:
    """ Find the path to the source file that was used to generate the given
        output file.
    """
    fname_base = os.path.splitext(fname)[0]

    # Find all the source files
    try:
        with open(os.path.join(root_dir, fname_base + '.dir', 'schedule_0.out'),
                  'r', encoding='UTF-8') as f:
            adding_files = False
            candidate_files = []
            for line in f:
                if 'Source files' in line:
                    adding_files = True
                elif adding_files:
                    if line.strip() == '':
                        break
                    candidate_files.append(line.strip())
    except FileNotFoundError:
        return 'No file'

    # Find the source file with name that is prefix of fname_base
    for candidate in candidate_files:
        if fname_base.startswith(candidate.split('.')[0]):
            return candidate.split('(')[1].split(')')[0]

    return 'No file'


def get_fields_from_lines(lines: List[str], fname: os.PathLike) \
        -> Tuple[int, int, bool]:
    """ Retrieve the time, schedules, and passed values from the list of lines.
    """
    time = None
    schedules = None
    passed = None
    for line in lines:
        if line.startswith("Time (seconds)") and not time:
            time = int(round(float(line.split('=')[1].strip())))
        elif "All tests pass." in line:
            passed = True
            if not schedules:
                schedules = int(re.findall(r'\d+', line)[0])
        elif line.startswith("AMPVer: error"):
            passed = False
            if not schedules:
                schedules = int(re.findall(r'\d+', line)[0])
        if passed is not None and time and schedules:
            break
    if not time:
        raise ValueError(f"No time recorded in file {fname}")
    if not schedules:
        raise ValueError(f"No schedule number in file {fname}")
    if passed is None:
        raise ValueError(f"Could not find pass or fail status in {fname}")
    return time, schedules, passed


def parse_results(root_dir: os.PathLike, verbose: Optional[bool]) -> \
    Tuple[Dict[str, Dict[str, Tuple[int, bool, int]]], \
          List[str], \
          Dict[str, str]]:
    """ Parse the results of the experiments in the given directory, and return
        a dictionary with the data structures as keys and a list of times as
        values as well as a set of test names.
    """
    data_structures = {}
    tests = set()
    source_paths = {}

    for fname in os.listdir(root_dir):

        # Skipping schedule outputs for now
        if fname.endswith('.out') and not "_S" in fname:
            if verbose:
                print(f"Processing {fname}")
            data_structure, test = fname.split('_')
            test = str(test.split('.')[0])

            with open(os.path.join(root_dir, fname), 'r', encoding='UTF-8') as f:
                lines = f.readlines()

                # Extract fields
                time, schedules, passed = get_fields_from_lines(lines, fname)

                # Populate source paths and tests if needed
                if data_structure not in source_paths \
                   or source_paths[data_structure] == 'No file':
                    source_paths[data_structure] = find_source_path(root_dir,
                                                                    fname)
                tests.add(test)

                # Store the results
                if data_structure not in data_structures:
                    data_structures[data_structure] = {}
                data_structures[data_structure][test] = (time, passed,
                                                         schedules)

    if verbose:
        print("Found the following", len(tests), "tests:", tests)
        print("Found the following", len(data_structures), "data structures:",
              data_structures.keys())
    return dict(sorted(data_structures.items())), list(sorted(tests)), \
        source_paths


def generate_latex(data_structures: Dict[str, Dict[str, Tuple[int, bool, int]]],
                   tests: List[str]) -> str:
    """ Generate a latex table from the given data structures and tests.
    """
    table =  '\\begin{table}[ht]\n'
    table += '\\small\n'
    table += '\\centering\n'
    table += '\\begin{tabular}{ l ' + ' r' * len(tests) + ' }\n'
    table += '  Data\\ Structure & ' + ' & '.join(tests) + ' \\\\\n'
    table += '  \\toprule\n'
    for data_structure, results in data_structures.items():
        table += '  \\code{' + data_structure + '} & '
        for test in tests:
            if test in results:
                if results[test][1]:
                    table += str(results[test][0])
                else:
                    table += '\\textbf{' + str(results[test][0]) + '}'
            else:
                table += '--'
            table += ' & '
        table = table[:-2] + ' \\\\\n'
    table += '\\end{tabular}\n'
    table += '\\caption{Results of the experiments.}\\label{tab:results}\n'
    table += '\\end{table}\n'
    return table


def get_tooltip(test: str) -> str:
    """ Get the tooltip for the given test name.
    """
    t = 'No tooltip available.'
    if test == 'A':
        t = \
            """BOUND_A:
Pre-adds: 0
Threads: 1-2
Steps: 1-2
Hashcode: identity
Set/List schedules: 63
Queue schedules: 9
SyncQueue schedules: 9
PQueue schedules: 7"""
    elif test == 'B':
        t = \
            """BOUND_B:
Pre-adds: 0-1
Threads: 1-2
Steps: 1-2
Hashcode: identity

Set/List schedules: 270
Queue schedules: 18
SyncQueue schedules: 25
PQueue schedules: 25"""
    elif test == 'C':
        t = \
            """BOUND_C:
Pre-adds: 0-1
Threads: 1-2
Steps: 1-2
Hashcode: nondeterministic

Set/List schedules: 270
Queue schedules: 18
SyncQueue schedules: 25
PQueue schedules: 25"""
    elif test == 'D':
        t = \
            """BOUND_D:
Pre-adds: 0-1
Threads: 1-3
Steps: 1-3
Hashcode: identity

Set/List schedules: 8108
Queue schedules: 58
SyncQueue schedules: 83
PQueue schedules: 156"""
    elif test == 'E':
        t = \
            """BOUND_E:
Pre-adds: 0-1
Threads: 1-3
Steps: 1-4
Hashcode: identity
Preemption bound: 2

Set/List schedules: 322930
Queue schedules: 166
SyncQueue schedules: 223
PQueue schedules: 1096"""
    return t


def generate_html(data_structures: Dict[str, Dict[str, Tuple[int, bool]]],
                  tests: List[str], source_paths: Dict[str, str]) -> str:
    """ Generate an HTML table from the given data structures and tests.
    """

    # Styling
    table =  '<style type="text/css">\n'
    table += '.tg  {border-collapse:collapse;border-spacing:0;}\n'
    table += '.tg td{border-color:black;border-style:solid;border-width:1px;\n'
    table += '       font-family:Arial, sans-serif;font-size:14px;\n'
    table += '       overflow:hidden;padding:10px 5px;word-break:normal;}\n'
    table += '.tg th{border-color:black;border-style:solid;border-width:1px;\n'
    table += '       font-family:Arial, sans-serif;font-size:14px;\n'
    table += '       font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}\n'
    table += '.tg .tg-head{border-color:inherit;font-family:serif !important;\n'
    table += '             background-color:darkgrey;text-align:left;vertical-align:top;\n'
    table += '             font-weight:bold}\n'
    table += '.tg .tg-left{border-color:inherit;font-family:serif !important;'
    table += '             background-color:lightgrey;text-align:left;vertical-align:top}'
    table += '.tg .tg-base{border-color:inherit;font-family:serif !important;\n'
    table += '             background-color:white;text-align:left;vertical-align:top}\n'
    table += '.tg .tg-fail{border-color:inherit;font-family:serif !important;\n'
    table += '             background-color:lightcoral;text-align:left;vertical-align:top;\n'
    table += '             font-weight:bold}\n'
    table += '</style>\n'

    # Table header
    table += '<table class="tg"><thead>\n'
    table += '  <tr>\n'
    table += '    <th class="tg-head"> </th>\n'
    for test in tests:
        table += '    <th class="tg-head" title="' \
            + get_tooltip(test) + '">' + test + '</th>\n'
    table += '  </tr></thead>\n'

    # Table body - results
    table += '<tbody>\n'
    for data_structure, results in data_structures.items():
        table += '  <tr>\n'

        # Apply gray highlighting to data structure name in left column and add
        # link to source file if available
        if data_structure in source_paths \
           and source_paths[data_structure] != 'No file':
            table += '    <td class="tg-left">'
            table += '<a href="' + source_paths[data_structure] + '">'
            table += data_structure + '</a>'
            table += '</td>\n'
        else:
            table += '    <td class="tg-left">' + data_structure + '</td>\n'

        for test in tests:
            if test in results:
                # apply red highlighting to failing tests
                class_name = 'tg-base' if results[test][1] else 'tg-fail'
                table += '    <td class="' + class_name + '">'

                # add link to failing schedule if a schedule failed
                if not results[test][1]:
                    table += '<a href="out/' + data_structure + '_' + test \
                        + '.dir/schedule_' + str(results[test][2]) + '.out">'

                # add the time taken to reach result
                table += str(results[test][0]) + ' sec.'

                # close the link if a schedule failed
                if not results[test][1]:
                    table += '</a>'

                # add time unit and links to out file and dir with all schedules
                table += ' (<a href="out/' + data_structure + '_' + test \
                    + '.out">out</a>, '
                table += '<a href="out/' + data_structure + '_' + test \
                    + '.dir">dir</a>)'
                table += '</td>\n'
            else:
                # add empty cell if test was not run
                table += '    <td class="tg-base">--</td>\n'
        table += '  </tr>\n'
    table += '</tbody>\n'
    table += '</table>\n'
    return table


def main():
    """ Parse the command line arguments and generate the table.
    """
    parser = argparse.ArgumentParser(description='Parse the results of the experiments.')
    parser.add_argument('root_dir', type=str, help='The root directory of the results.')
    parser.add_argument('output', type=str, help='The output file for the table.')
    parser.add_argument('--format', type=str, default='latex',
                        help='The format of the output (latex or html).')
    parser.add_argument('--verbose', action="store_true",
                        help='Enable verbose output.')
    args = parser.parse_args()
    verbose = args.verbose

    data_structures, tests, source_paths = parse_results(args.root_dir, verbose=verbose)
    if args.format == 'html':
        table = generate_html(data_structures, tests, source_paths)
    elif args.format == 'latex':
        table = generate_latex(data_structures, tests)
    else:
        raise ValueError('Invalid format:', args.format)

    with open(args.output, 'w', encoding='UTF-8') as f:
        f.write(table)


if __name__ == '__main__':
    main()
