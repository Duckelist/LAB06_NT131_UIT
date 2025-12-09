#ifndef SENSETORADIO_H
#define SENSETORADIO_H

enum {
  AM_SENSETORADIO = 11,
  TIMER_PERIOD_MILLI = 250
};

typedef nx_struct SenseToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t value;
  } SenseToRadioMsg;

#endif
