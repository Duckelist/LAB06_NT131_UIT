#include <Timer.h>
#include "SenseToRadio.h"

module TempSensorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as Read;
}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;
  uint16_t temp;

  void setLeds(uint16_t val) {
    if (val & 0x01)
      call Leds.led0On();
    else 
      call Leds.led0Off();
    if (val & 0x02)
      call Leds.led1On();
    else
      call Leds.led1Off();
    if (val & 0x04)
      call Leds.led2On();
    else
      call Leds.led2Off();
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    call Read.read();
    if (!busy) {
      SenseToRadioMsg* btrpkt = 
	(SenseToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(SenseToRadioMsg)));
      if (btrpkt == NULL) {
	return;
      }
      btrpkt->nodeid = TOS_NODE_ID;
      btrpkt->value = temp;
      if (call AMSend.send(AM_BROADCAST_ADDR, 
          &pkt, sizeof(SenseToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  event void Read.readDone(error_t result, uint16_t data) {
    if(result == SUCCESS) {
      temp = (-39.60 + 0.01*data);
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
}
