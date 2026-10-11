#!/bin/bash
# Animated ASCII logo next to fastfetch output.
# Plays until a key is pressed; that key is left unread so it lands in the shell prompt.
delay=${1:-0.1}
ascii_row=1
ascii_col=1
text_col=50
frames=(~/.config/fastfetch/frames_colour/*.txt)

clear
info_lines=0
if command -v fastfetch >/dev/null 2>&1; then
  line_num=$ascii_row
  while IFS= read -r line; do
    tput cup $line_num $text_col
    printf '%s\n' "$line"
    ((line_num++))
  done < <(fastfetch --logo none)
  info_lines=$((line_num - ascii_row))
fi

frame_lines=$(wc -l < "${frames[0]}")
end_row=$((ascii_row + (frame_lines > info_lines ? frame_lines : info_lines) + 1))

saved_stty=$(stty -g)
cleanup() {
  stty "$saved_stty"
  tput cup $end_row 0
  tput cnorm
}
trap 'cleanup; exit' INT TERM

# No echo (typed keys don't smear the animation) and no line buffering (a single key counts as input)
stty -echo -icanon min 1 time 0
tput civis

while true; do
  for frame in "${frames[@]}"; do
    tput cup $ascii_row $ascii_col
    cat "$frame"
    sleep "$delay"
    # Peek for pending input without consuming it
    read -t 0 && break 2
  done
done

cleanup
