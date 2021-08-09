#!/bin/bash
#
# Based on https://github.com/moverest/sway-interactive-screenshot/blob/master/sway-interactive-screenshot
# MIT
#
# `list_geometry` returns the geometry of the focused of visible windows. You can also get they title
# by setting a second argument to `with_description`. The geometry and the title are seperated by `\t`.
#
# Arguments:
#   $1: `focused` or `visible`
#   $2: `with_description` or nothing
#
# Output examples:
#   - with the `with_description` option:
#      12,43 100x200\tTermite
#   - without the `with_description` option:
#      12,43 100x200
function list_geometry () {
  [ "$2" = with_description ] && local append="\t\(.name)" || local append=
  swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.'$1' and .pid) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)'$append'"'
}

options=$'Fullscreen\nRegion\nFocused\n4s Fullscreen\n4s Region\n4s Focused'
focused_pane=`list_geometry focused | xargs`
choice=$(echo "$options" | wofi -L 6 -W 200 -b -d -p 'Screenshot' -O 'alphabetical')
fname_short=$(date +'%d-%b_%H-%M-%S.png')
fname_full="$HOME/Desktop/screenshots/$fname_short"
valid_geo="^[0-9]+\,[0-9]+\ [0-9]+x[0-9]+"

if [[ "$choice" =~ Focused$ ]] && ! [[ $focused_pane =~ $valid_geo ]];
then
  if [[ -n "$TERM" && -n "$COLORTERM" ]]; then
    echo -e "Floating windows are not supported.\nUnable to obtain the requested geometry."
  else
    notify-send -u low "Screenshot failed" "\nUnable to obtain the requested geometry."
  fi
  exit 126 # Command invoked cannot execute
fi

mkdir -p "$HOME/Desktop/screenshots/"

case $choice in
    Fullscreen)
        grim "$fname_full";
  ;;
    Region)
        grim -g "$(slurp)" "$fname_full";
  ;;
    Focused)
        grim -g "$focused_pane" "$fname_full";
  ;;
    "4s Fullscreen")
        sleep 4s && grim "$fname_full";
  ;;
    "4s Region")
        sleep 4s && grim -g "$(slurp)" "$fname_full";
  ;;
    "4s Focused")
        sleep 4s && grim -g "$focused_pane" "$fname_full";
  ;;
    '')
        notify-send "Screenshot" "Cancelled"
        exit 0
        ;;
    *)
      geo="`echo \"$choice\" | cut -d$'\t' -f1`"
      grim -g "$geo" "$fname_full";
esac

wl-copy < "$fname_full";
notify-send "Screenshot" "$fname_short" -i "$fname_full";
