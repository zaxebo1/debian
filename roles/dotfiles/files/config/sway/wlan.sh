#!/usr/bin/env bash

wlan_status=$(iwctl adapter phy0 show | grep Powered | cut -d "d" -f2 | xargs)
ifaces="ip -br addr | grep -v -E ^lo | grep -v DOWN | sed -E -e 's/\/([0-9]+)\s.+/\/\1/g'"
iwconfig="sudo iwconfig wlan0 | grep -E 'Signal|Tx-' | sed 's/^\ *//g'"
red='\033[0;31m'
green='\033[0;32m'
clr='\e[0m'
emp='\t\r'

if [ $wlan_status == "off" ]; then
  sudo ifdown enp2s0f0 &> /dev/null &&
  sudo ifdown enx606d3c5322cd &> /dev/null &&
  iwctl adapter phy0 set-property Powered on &> /dev/null &&
  iwctl device wlan0 set-property Powered on &> /dev/null &&
  sudo ifup wlan0 &> /dev/null &&
  sudo iwconfig wlan0 txpower 18 &&
    if [[ -n "$TERM" && -n "$COLORTERM" ]]; then
      echo -e "\n${green}WLAN is on, ${red}LAN turned off.${clr}\n\n$(eval $ifaces)\n\n$(eval $iwconfig)\n"
    else
      notify-send -c "interfaces" -u critical "Network changes" "$emp$(eval $ifaces) $emp $(eval $iwconfig)"
    fi
elif [ $wlan_status == "on" ]; then
  sudo ifdown wlan0 &> /dev/null &&
  sudo ifdown enp2s0f0 &> /dev/null &&
  sudo ifdown enx606d3c5322cd &> /dev/null &&
  sudo ifup enp2s0f0 &> /dev/null &&
  sudo ifup enx606d3c5322cd &> /dev/null &&
  iwctl adapter phy0 set-property Powered off &> /dev/null &&
  iwctl device wlan0 set-property Powered off &> /dev/null &&
    if [[ -n "$TERM" && -n "$COLORTERM" ]]; then
      echo -e "\n${green}LAN is on, ${red}WLAN turned off.${clr}\n\n$(eval $ifaces)\n"
    else
      notify-send -c "interfaces" -u critical "Network changes" "$emp$(eval $ifaces) $emp $(eval $iwconfig)"
    fi
else
  if [[ -n "$TERM" && -n "$COLORTERM" ]]; then
    echo -e "\n ${red} Unknown WLAN state. ${clr}\n"
  else
    notify-send -c "interfaces" -u critical "Network failure" "Unknown state, please investigate."
  fi
fi
