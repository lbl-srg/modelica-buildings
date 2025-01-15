#ifndef CRYPTOGRAPHICSHASH_H
#define CRYPTOGRAPHICSHASH_H

#include "SpawnTypes.h"
/*
   Implementation is based on SHA-1 in C
   By Steve Reid <steve@edmweb.com>
   100% Public Domain
 */

#include "stdint.h"

typedef struct
{
    uint32_t state[5];
    uint32_t count[2];
    unsigned char buffer[64];
} SHA1_CTX;

static void SHA1Transform(
    uint32_t state[5],
    const unsigned char buffer[64]
    );

static void SHA1Init(
    SHA1_CTX * context
    );

static void SHA1Update(
    SHA1_CTX * context,
    const unsigned char *data,
    uint32_t len
    );

static void SHA1Final(
    unsigned char digest[20],
    SHA1_CTX * context
    );

static void SHA1(
    char *hash_out,
    const char *str,
    int len);

const char* cryptographicsHash(const char* str, void (*SpawnError)(const char *string));

#endif /* CRYPTOGRAPHICSHASH_H */
