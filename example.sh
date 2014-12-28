#!/bin/bash


source tui.sh


TOP_LANE=2
MENU_OPTIONS=(1 2 3)
TITLE="Select backup file to restore:"
show_menu
echo "selection: $?"
MENU_OPTIONS=(1 2)
TITLE="none selection"
show_menu
echo "selection: $?"
MENU_OPTIONS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 )
TITLE="multiple selection"
show_menu
echo "selection: $?"

IS_TITLE_SHOWN_TOTAL_NUM=true
IS_MULTI_SELECT=false
MENU_OPTIONS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 )
TITLE="with quit test"
show_menu_quit
echo "selection: $?"

IS_MULTI_SELECT=true
MENU_OPTIONS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 )
TITLE="multiple selection"
show_menu_quit
echo "selection: $? multi selected: ${M_SELECTED_INDEX[@]}, all: ${M_SELECTED[@]}"

