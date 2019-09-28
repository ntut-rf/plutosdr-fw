/* Initialize a RS codec
 *
 * Copyright 2002 Phil Karn, KA9Q
 * May be used under the terms of the GNU General Public License (GPL)
 */
#include <stdlib.h>

extern "C" {
#include <gnuradio/fec/rs.h>
}

#ifdef CCSDS
#include "ccsds.h"
#elif defined(BIGSYM)
#include "int.h"
#else
#include "char.h"
#endif

#ifndef NULL
#define NULL ((void*)0)
#endif

static struct rs _rs;
static DTYPE index_of[sizeof(DTYPE) * (1 << 8)];
static DTYPE alpha_to[sizeof(DTYPE) * (1 << 8)];

void FREE_RS(void* p) {}

/* Initialize a Reed-Solomon codec
 * symsize = symbol size, bits (1-8)
 * gfpoly = Field generator polynomial coefficients
 * fcr = first root of RS code generator polynomial, index form
 * prim = primitive element to generate polynomial roots
 * nroots = RS code generator polynomial degree (number of roots)
 */
void* INIT_RS(unsigned int symsize,
              unsigned int gfpoly,
              unsigned fcr,
              unsigned prim,
              unsigned int nroots)
{
    struct rs* rs;
    int sr, root, iprim;
    unsigned int i, j;

    if (symsize > 8 * sizeof(DTYPE))
        return NULL; /* Need version with ints rather than chars */

    if (fcr >= (1u << symsize))
        return NULL;
    if (prim == 0 || prim >= (1u << symsize))
        return NULL;
    if (nroots >= (1u << symsize))
        return NULL; /* Can't have more roots than symbol values! */

    _rs = (struct rs){};
    rs = &_rs;
    rs->mm = symsize;
    rs->nn = (1 << symsize) - 1;

    rs->alpha_to = alpha_to;
    rs->index_of = index_of;

    /* Generate Galois field lookup tables */
    rs->index_of[0] = A0; /* log(zero) = -inf */
    rs->alpha_to[A0] = 0; /* alpha**-inf = 0 */
    sr = 1;
    for (i = 0; i < rs->nn; i++) {
        rs->index_of[sr] = i;
        rs->alpha_to[i] = sr;
        sr <<= 1;
        if (sr & (1 << symsize))
            sr ^= gfpoly;
        sr &= rs->nn;
    }
    if (sr != 1) {
        /* field generator polynomial is not primitive! */
        return NULL;
    }

    /* Form RS code generator polynomial from its roots */
    rs->genpoly = (DTYPE*)malloc(sizeof(DTYPE) * (nroots + 1));
    if (rs->genpoly == NULL) {
        return NULL;
    }
    rs->fcr = fcr;
    rs->prim = prim;
    rs->nroots = nroots;

    /* Find prim-th root of 1, used in decoding */
    for (iprim = 1; (iprim % prim) != 0; iprim += rs->nn)
        ;
    rs->iprim = iprim / prim;

    rs->genpoly[0] = 1;
    for (i = 0, root = fcr * prim; i < nroots; i++, root += prim) {
        rs->genpoly[i + 1] = 1;

        /* Multiply rs->genpoly[] by  @**(root + x) */
        for (j = i; j > 0; j--) {
            if (rs->genpoly[j] != 0)
                rs->genpoly[j] =
                    rs->genpoly[j - 1] ^
                    rs->alpha_to[modnn(rs, rs->index_of[rs->genpoly[j]] + root)];
            else
                rs->genpoly[j] = rs->genpoly[j - 1];
        }
        /* rs->genpoly[0] can never be zero */
        rs->genpoly[0] = rs->alpha_to[modnn(rs, rs->index_of[rs->genpoly[0]] + root)];
    }
    /* convert rs->genpoly[] to index form for quicker encoding */
    for (i = 0; i <= nroots; i++)
        rs->genpoly[i] = rs->index_of[rs->genpoly[i]];

#ifdef FIXED
#elif defined(BIGSYM)
#else
    /* Form modnn lookup table */
    rs->modnn_table = (int*)malloc(sizeof(int) * (2 << ((sizeof(unsigned char)) * 8)));
    if (rs->modnn_table == NULL) {
        //free(rs->genpoly);
        return NULL;
    }
    for (i = 0; i < (2 << ((sizeof(unsigned char)) * 8)); i++) {
        j = i;
        rs->modnn_table[i] = modnn(rs, j);
    }
#endif

#if 0
  printf ("genpoly:\n");
  for (i = nroots; i >= 0; i--){
    printf ("  %3d*X^%d\n", rs->alpha_to[rs->genpoly[i]], i);
  }
#endif

    return rs;
}