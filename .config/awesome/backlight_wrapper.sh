#!/bin/bash

case $1 in
  "get"*)
    value=$(brightnessctl get)
    max=$(brightnessctl max)
    let "perc = value * 100 / max"
    echo $perc
    ;;

  "incr"*)
    brightnessctl --min-value=2400 set '10%+'
    ;;

  "decr"*)
    brightnessctl --min-value=2400 set '10%-'
    ;;
esac
