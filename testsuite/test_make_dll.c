/*

The origin of this code is unclear.
It seems to have been written by
my student Ilya in July 2015 but maybe
it just come from another tuto or on the internet
or derive from another code.

I, Alain C., put it under GNU GPL V3 or later,
but if any problem, just write to me !

*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "idl_export.h"

IDL_LONG add
  (int      argc,
   void *   argv[])
{
  IDL_LONG a;
  IDL_LONG b;
  IDL_LONG retval;

  a=*((IDL_LONG *)argv[0]);
  b=*((IDL_LONG *)argv[1]);

  retval=a+b;
  return retval;
}