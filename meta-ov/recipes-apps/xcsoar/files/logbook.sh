#!/bin/sh
#
# logbook.sh
# Logbook script to show last flights
#
# Created by Blaubart           2023-03-10
#
# This logbook script shows your last 20 flights in the X-menu at the OpenVario
# It shows:
#
# -date
# -start time
# -landing time
# -flight duration

# XCSoar path to flight logs 
export XCSOAR_PATH=/home/root/.xcsoar

echo 'Date              Time               Duration'
i=1

while [ $i -le 41 ]
do
  CASE=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "21-27"`
  if [ $CASE = "landing" ]
  then
    DAY=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "1-10"`
    LANDING=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "12-16"`
    i=$[$i+1]
    CASE=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "21-27"`
    if [ $CASE = "start" ]
    then
      START=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "12-16"`
    else
	  START="  --:--  "
	  i=$[$i-1]
	fi
  else
    DAY=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "1-10"`
    LANDING="  --:--  "
    START=`grep "20" "$XCSOAR_PATH"/flights.log | tail -fn 40 | tail -fn $i | head -n 1 | cut -c "12-16"`
  fi
  i=$[$i+1]
  if [ $START = "--:--" ] || [ $LANDING = "--:--" ]
  then
    DURATION=" --:--  "
  else
    STARTMINUTE=${START:3:5}
    if [ $STARTMINUTE -lt 10 ]
    then
      STARTMINUTE=${STARTMINUTE:1:2}
    fi
    LANDINGMINUTE=${LANDING:3:5}
    if [ $LANDINGMINUTE -lt 10 ]
    then
      LANDINGMINUTE=${LANDINGMINUTE:1:2}
    fi
    
    STARTHOUR=${START:0:${#START}-3}
    if [ $STARTHOUR -lt 10 ]
    then
      STARTHOUR=${STARTHOUR:1:2}
    fi
    LANDINGHOUR=${LANDING:0:${#LANDING}-3}
    if [ $LANDINGHOUR -lt 10 ]
    then
      LANDINGHOUR=${LANDINGHOUR:1:2}
    fi
    
    FLIGHTMINUTE=$[($LANDINGHOUR*60+$LANDINGMINUTE-($STARTHOUR*60+$STARTMINUTE)) % 60]
    FLIGHTHOUR=$[(($LANDINGHOUR*60+$LANDINGMINUTE-($STARTHOUR*60+$STARTMINUTE)) - $FLIGHTMINUTE) / 60]
    if [ $FLIGHTMINUTE -lt 10 ]
    then
      DURATION="$FLIGHTHOUR:"0"$FLIGHTMINUTE"
    else
	  DURATION="$FLIGHTHOUR:$FLIGHTMINUTE"
	fi
  fi
  echo "$DAY   $START $LANDING   $DURATION"
done