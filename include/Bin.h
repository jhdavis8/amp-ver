#ifndef _BIN_H
#define _BIN_H
/* Bin.h: header file for a "bin".
 */
#include "types.h"
#include <stdbool.h>

typedef struct Bin * Bin;

Bin Bin_create(void);

void Bin_destroy(Bin bin);

void Bin_put(Bin bin, T item);

T Bin_get(Bin bin);

bool Bin_isEmpty(Bin bin);

void Bin_print(Bin bin);

#endif
