#ifdef __GNUC__
#  define UNUSED(x) UNUSED_ ## x __attribute__((__unused__))
#else
#  define UNUSED(x) UNUSED_ ## x
#endif

#ifdef __GNUC__
#  define UNUSED_FUNCTION(x) __attribute__((__unused__)) UNUSED_ ## x
#else
#  define UNUSED_FUNCTION(x) UNUSED_ ## x
#endif

#include "erl_nif.h"

#include <stdio.h>
#include <strings.h>
#include <unistd.h>

#define MAXBUFLEN 1024



double double_dot_product(double *a, double *b, int n)
{
    int i = 0;
    double result = 0.0;
    for (; i < n; i++)
        result += a[i] * b[i];
    return result;
}

int int_dot_product(int *a, int *b, int n)
{
    int i = 0;
    int result = 0;
    for (; i < n; i++) {
        result += (a[i] * b[i]);
      }
    return result;
}


double* ListToDoubleArray(ErlNifEnv* env, ERL_NIF_TERM v, int size) {
  ERL_NIF_TERM head, tail;
  unsigned int i = 0;
  double *result = malloc(size * sizeof(double));
  double x = 0.0;

  while(enif_get_list_cell(env, v, &head, &tail)) {
    enif_get_double(env, head, &x);
    result[i] = x;
    i++;
    v = tail;
  }

  return result;
}


int * ListToIntegerArray(ErlNifEnv* env, ERL_NIF_TERM v, int size) {
  ERL_NIF_TERM head, tail;
  unsigned int i = 0;
  int x = 0;
  int *result = enif_alloc((size+1) * sizeof(int));

  while(enif_get_list_cell(env, v, &head, &tail)) {
    enif_get_int(env, head, &x);
    result[i] = x;
    i++;
    v = tail;
  }

  return result;
}


static ERL_NIF_TERM _dotproduct(ErlNifEnv* env, int UNUSED(arc), const ERL_NIF_TERM argv[])
{
  int dp = 0;

  unsigned int ra_size = 0;
  enif_get_list_length(env,  argv[0], &ra_size);
  int *row_a = ListToIntegerArray(env, argv[0], ra_size );

  unsigned int rb_size = 0;
  enif_get_list_length(env,  argv[1], &rb_size);
  int *row_b = ListToIntegerArray(env, argv[1], rb_size );

  dp = int_dot_product(row_a, row_b, ra_size);

  enif_free(row_a);
  enif_free(row_b);

  return enif_make_int(env, dp);
}

static ErlNifFunc nif_funcs[] =
{
  {"_dotproduct", 2, _dotproduct, 0}
};

ERL_NIF_INIT(Elixir.ExMatrix.NIF,nif_funcs,NULL,NULL,NULL,NULL)