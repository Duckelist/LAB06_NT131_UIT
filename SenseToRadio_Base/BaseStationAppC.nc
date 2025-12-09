#define NEW_PRINTF_SEMANTICS
#include <Timer.h>
#include "SenseToRadio.h"
#include "printf.h"
configuration BaseStationAppC {
}
implementation {
  components MainC;
  components LedsC;
  components BaseStationC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components PrintfC;
  components SerialStartC;
  components new AMReceiverC(AM_SENSETORADIO);

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.AMControl -> ActiveMessageC;
  App.Receive -> AMReceiverC;
}
