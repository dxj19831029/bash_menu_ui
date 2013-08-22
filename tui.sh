#!/bin/bash

MENU_OPTIONS=()
M_SELECTED=()
M_SELECTED_INDEX=()
LM=0
TITLE="BASH SELECTION MENU                        "
TOP_LANE=1
MAX_LINES=`tput lines`
CURRENT_LANE=0
SHOW_LINES=MAX_LINES
TOTAL_LINES=0
IS_DEBUG=${DEBUG:-no}
IS_MULTI_SELECT=false


#### modified based on http://top-scripts.blogspot.com/2011/01/blog-post.html
E='echo -e';e='echo -en';trap "R;exit" 2
ESC=$( $e "\033")
TPUT(){ $e "\033[${1};${2}H";}
CLEAR(){ $e "\033c";}
CIVIS(){ $e "\033[?25l";}
DRAW(){ $e "\033%@\033(0";}
WRITE(){ $e "\033(B";}
MARK(){ $e "\033[7m";}
UNMARK(){ $e "\033[27m";}
#BLUE(){ $e "\033c\033[H\033[J\033[37;44m\033[J";};BLUE
BLUE(){ $e ; };BLUE
C(){ CLEAR;BLUE;}
HEAD(){ 
	TOTAL_BORDER=$(( $LM + 4 ))
  if test "$IS_DEBUG" = "yes" ; then 
    TPUT 0 0 
    printf "total: $TOTAL_LINES show: $SHOW_LINES LM: $LM i: $i current top: $CURRENT_LANE l opt index: $L_OPT_INDEX"
  fi
	MARK;TPUT $TOP_LANE 4
	EMPTY1="                         "
	EMPTY2="                         "
	$E "`printf "%s %s %s" "${EMPTY1:$(( ${#TITLE} / 2 ))}" "$TITLE" "${EMPTY2:$(( ${#TITLE} / 2 ))}"`";UNMARK
	DRAW
	for each in $(seq 1 $TOTAL_BORDER);do
		$E "   x                                                  x"
	done;WRITE;}
i=0; CLEAR; CIVIS;NULL=/dev/null
FOOT(){ MARK;end_foot=$(( $LM + 4 + $TOP_LANE )) ; TPUT $end_foot 4
  if test "$IS_MULTI_SELECT" != "false" ; then
	  printf " ENTER=FINISH, UP/DN=NEXT OPTION, S=select/deselect ";UNMARK;
  else
	  printf "      ENTER=SELECT, UP/DN=NEXT OPTION               ";UNMARK;
  fi
  }
ARROW(){ 
  while true;  do
    read -s -n1 key 2>/dev/null >&2
    if [[ $key = 's' && "$IS_MULTI_SELECT" != "false" ]] ; then
      echo select; break; 
      #L_C=$(( $CURRENT_LANE + $i )) ; ${M_SELECTED[$L_C]} = true  ; INITN; 
      continue;
    fi
    if [[ $key = '' ]] ; then break; fi
    if test "$key" != "$ESC" ; then continue; fi
    read -s -n2 key2 2>/dev/null >&2
	  if [[ $key2 = [A ]];then echo up; break; fi
	  if [[ $key2 = [B ]];then echo dn; break; fi;
  done
  }
POSITION(){ 
  if [[ $cur = select ]]; then 
    L_C=$(( $CURRENT_LANE + $i )) ; 
    if test "${M_SELECTED[$L_C]}" = "true" ; then
      M_SELECTED[$L_C]=""
    else
      M_SELECTED[$L_C]=true  
    fi
    INITN
     return 0
  fi
  if [[ $cur = up ]];then ((i--));fi
	if [[ $cur = dn ]];then ((i++));fi
  if [[ i -lt 0 ]]; then ((CURRENT_LANE--)); INITN;fi
  if [[ i -gt LM ]]; then ((CURRENT_LANE++));INITN;fi
	if [[ i -lt 0 && CURRENT_LANE -lt 0  ]];then i=$LM; CURRENT_LANE=$(( $TOTAL_LINES - $LM )); INITN;fi
  VIEW_REGION=$(( $CURRENT_LANE + $SHOW_LINES ))
	if [[ i -gt LM && VIEW_REGION -gt TOTAL_LINES ]];then i=0; CURRENT_LANE=0 ; INITN;fi;
  if [[ i -gt LM ]] ; then i=$LM;INITN ; fi;
  if [[ i -lt 0 ]] ; then i=0;INITN; fi;
  #if test "$IS_DEBUG" = "yes" ; then 
    #TPUT 0 0 
    #printf "total: $TOTAL_LINES show: $SHOW_LINES LM: $LM i: $i current top: $CURRENT_LANE l opt index: $L_OPT_INDEX"
  #fi
}
REFRESH(){ after=$((i+1)); before=$((i-1))
	if [[ $before -lt 0  ]];then before=$LM;fi
	if [[ $after -gt $LM ]];then after=0;fi
	if [[ $j -lt $i      ]];then UNMARK;MN "$before";else UNMARK;MN "$after";fi
	if [[ $after -eq 0   ]] || [[ $before -eq $LM ]];then
    UNMARK; MN "$before"; MN "$after";
  fi;
  j=$i;UNMARK;MN "$before" ; MN "$after";
}
MN(){ 
    line=$(( $1  + 1 + $TOP_LANE )); 
		TPUT "$line" 5 ; 
    L_OPT_INDEX=$(( $1 + $CURRENT_LANE ))
    l_select=${M_SELECTED[$L_OPT_INDEX]}
    empty_str=" "

    if test "$IS_MULTI_SELECT" != "false" ; then
      if test "$l_select" = "true" ; then 
        empty_str=" [x]" ; 
      else 
        empty_str=" [ ]"; 
      fi
		  EMPTY1="                      "
		  EMPTY2="                     "
		  OUTPUT_OPTION_L="${MENU_OPTIONS[$L_OPT_INDEX]:-None}" ;
		  $e "${empty_str}${EMPTY1:$(( ${#OUTPUT_OPTION_L} / 2 ))} ${OUTPUT_OPTION_L} ${EMPTY2:$(( ${#OUTPUT_OPTION_L} / 2 ))}";
    else
		  EMPTY1="                        "
		  EMPTY2="                       "
		  OUTPUT_OPTION_L="${MENU_OPTIONS[$L_OPT_INDEX]:-None}" ;
		  $e "${EMPTY1:$(( ${#OUTPUT_OPTION_L} / 2 ))} ${OUTPUT_OPTION_L} ${EMPTY2:$(( ${#OUTPUT_OPTION_L} / 2 ))}";
    fi
		#$e "${MENU_OPTIONS[$1]:-None}" ; 
}
LM=6    #Last Menu number
MENUN(){ 
	N_L=0
	while [ $N_L -le $LM ] ; do
		MN ${N_L}
		N_L=$(( $N_L + 1 ))
	done
}
INITN(){ BLUE;HEAD;FOOT;MENUN;}
SC(){ REFRESH;MARK;$S;cur=`ARROW`;}
ESN(){ MARK;$e "\nENTER = main menu ";$b;read;INITN;}
COUNT_LM() {
	LM=0
	while [[ "${MENU_OPTIONS[$LM]}" != "" ]] ; do
		LM=$(( $LM + 1 ))
	done
	if test "$LM" != "0" ; then 
		LM=$(( $LM - 1 ))
	fi
}

adjust_show_region()
{
  SHOW_LINES=$(( $MAX_LINES - $TOP_LANE - 5 ))
  TOTAL_LINES=$LM
  if [[ $LM -gt $SHOW_LINES ]] ; then
    LM=$SHOW_LINES
  fi
}

collect_multi_select_index()
{
  if test "$IS_MULTI_SELECT" != "false" ; then
    N=0
    N_INDEX=0
    for option in ${MENU_OPTIONS[@]} ; do
      if test "${M_SELECTED[$N]}" = "true" ; then
        M_SELECTED_INDEX[$N_INDEX]=$N
        (( N_INDEX++ ))
      fi
      (( N++ ))
    done
  fi
}

# more than two options will be handled correctly
show_menu() {
	i=0
  CURRENT_LANE=0
  M_SELECTED=()
  MAX_LINES=`tput lines`
	COUNT_LM
  adjust_show_region
	INITN
	while [[ "$O" != " " ]] ; do
		S="MN $i" ; SC; if [[ $cur = "" ]]; then C; TPUT 1 1 ; ret_l=$(( $CURRENT_LANE + $i )); collect_multi_select_index; return $ret_l;fi
		POSITION
	done
}

# more than two options will be handled correctly
show_menu_quit() {
	i=0
  CURRENT_LANE=0
  M_SELECTED=()
  MAX_LINES=`tput lines`
	COUNT_LM
	LM=$(( $LM + 1 ))
	MENU_OPTIONS[$LM]="exit"
  adjust_show_region
	INITN
	while [[ "$O" != " " ]] ; do
		S="MN $i" ; SC; if [[ $cur = "" ]]; then C; TPUT 1 1 ; ret_l=$(( $CURRENT_LANE + $i )); if [[ "$ret_l" = "$LM" ]] ; then exit 0; fi; collect_multi_select_index ; return $ret_l;fi
		POSITION
	done
}


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

IS_MULTI_SELECT=true
MENU_OPTIONS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 )
TITLE="multiple selection"
show_menu_quit
echo "selection: $? multi selected: ${M_SELECTED_INDEX[@]}, all: ${M_SELECTED[@]}"

