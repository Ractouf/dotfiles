#!/bin/bash

if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q 'yes'; then
  # Muted → mic-off icon
  echo "<span foreground='#fab387'>[   ]</span>"
else
  # Active → mic-on icon
  echo "<span foreground='#9cdef2'>[  ]</span>"
fi