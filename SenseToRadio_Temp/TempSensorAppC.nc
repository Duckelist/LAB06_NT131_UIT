#include <Timer.h>
#include "SenseToRadio.h"
configuration TempSensorAppC {
}
implementation {
  components MainC;
  components LedsC;
  components TempSensorC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_SENSETORADIO);
  components new SensirionSht11C() as TempSource;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMSend -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.Read -> TempSource.Temperature;
}
