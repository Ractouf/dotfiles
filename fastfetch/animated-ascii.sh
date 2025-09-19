#!/bin/bash
delay=${1:-0.1}
ascii_row=1
ascii_col=1
text_col=50

clear
if command -v fastfetch >/dev/null 2>&1; then
  line_num=$ascii_row
  while IFS= read -r line; do
    tput cup $line_num $text_col
    echo "$line"
    ((line_num++))
  done < <(fastfetch --logo none)
fi

tput civis
trap 'tput cnorm; exit' INT TERM

while true; do
  for frame in ~/.config/fastfetch/frames_colour/*.txt; do
    tput cup $ascii_row $ascii_col
    cat "$frame"

    # Wait a little, but also check if user pressed a key
    read -t $delay -n 1 key && { tput cnorm; exit; }
  done
done