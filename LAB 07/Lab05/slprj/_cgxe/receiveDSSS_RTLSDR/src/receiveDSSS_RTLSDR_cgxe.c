/* Include files */

#include "receiveDSSS_RTLSDR_cgxe.h"
#include "m_5AxwALAOwAiCt73xCkp15B.h"

unsigned int cgxe_receiveDSSS_RTLSDR_method_dispatcher(SimStruct* S, int_T
  method, void* data)
{
  if (ssGetChecksum0(S) == 3638324303 &&
      ssGetChecksum1(S) == 34076057 &&
      ssGetChecksum2(S) == 3440819710 &&
      ssGetChecksum3(S) == 479746890) {
    method_dispatcher_5AxwALAOwAiCt73xCkp15B(S, method, data);
    return 1;
  }

  return 0;
}
