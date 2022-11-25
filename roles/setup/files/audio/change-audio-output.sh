#!/bin/bash

current_sink_name=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep node.name | cut -d' ' -f6 | sed -E 's/"//gm;t;d')

headset_sink_id=$(wpctl status | grep "G535 Wireless Gaming Headset Analog Stereo" | sed -E 's/│//g' | awk '{$1=$1};1' | cut -d' ' -f1 | sed -E 's/\.//g')
speakers_sink_id=$(wpctl status | grep "Family 17h/19h HD Audio Controller Analog Stereo" | sed -E 's/│//g' | awk '{$1=$1};1' | cut -d' ' -f1 | sed -E 's/\.//g')

if [[ $current_sink_name == "alsa_output.pci-0000_17_00.6.analog-stereo" ]]; then
  wpctl set-default $headset_sink_id
fi

if [[ $current_sink_name == "alsa_output.usb-Logitech_G535_Wireless_Gaming_Headset-00.analog-stereo" ]]; then
  wpctl set-default $speakers_sink_id
fi
