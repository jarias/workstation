#!/bin/bash

function input_notify() {
  volume=$(echo "$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | cut -d' ' -f2)*100" | bc)
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep MUTED >>/dev/null
  is_muted=$?

  if [ $is_muted -eq 0 ]; then
    notify-send -r 4000 -t 2000 -h int:value:${volume%.*} -i /usr/share/icons/Papirus-Dark/48x48/status/notification-microphone-sensitivity-muted.svg "Muted"
  else
    notify-send -r 4000 -t 2000 -h int:value:${volume%.*} -i /usr/share/icons/Papirus-Dark/48x48/status/notification-microphone-sensitivity-high.svg "${volume%.*}%"
  fi
}

function output_notify() {
  volume=$(echo "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)*100" | bc)
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep MUTED >>/dev/null
  is_muted=$?

  if [ $is_muted -eq 0 ]; then
    notify-send -r 4001 -t 2000 -h int:value:${volume%.*} -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-muted.svg "Muted"
  else
    notify-send -r 4001 -t 2000 -h int:value:${volume%.*} -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-high.svg "${volume%.*}%"
  fi
}

function polybar_micvol() {
  volume=$(echo "$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | cut -d' ' -f2)*100" | bc)
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep MUTED >>/dev/null
  is_muted=$?

  if [ $is_muted -eq 0 ]; then
    echo ""
  else
    echo " ${volume%.*}%"
  fi
}

case $1 in
up)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
  ;;
down)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  ;;
micup)
  wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+
  ;;
micdown)
  wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-
  ;;
micmute)
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  ;;
micvol)
  polybar_micvol
  LANG=EN
  pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
      polybar_micvol
    fi
  done
  ;;
esac
