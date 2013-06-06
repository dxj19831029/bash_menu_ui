#!/bin/bash

MENU_OPTIONS=()
LM=0
TITLE="BASH SELECTION MENU                        "
TOP_LANE=1


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
	printf "      ENTER=SELECT, UP/DN=NEXT OPTION               ";UNMARK;}
ARROW(){ read -s -n3 key 2>/dev/null >&2
	if [[ $key = $ESC[A ]];then echo up;fi
	if [[ $key = $ESC[B ]];then echo dn;fi;}
POSITION(){ if [[ $cur = up ]];then ((i--));fi
	if [[ $cur = dn ]];then ((i++));fi
	if [[ i -lt 0   ]];then i=$LM;fi
	if [[ i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
	if [[ $before -lt 0  ]];then before=$LM;fi
	if [[ $after -gt $LM ]];then after=0;fi
	if [[ $j -lt $i      ]];then UNMARK;MN "$before";else UNMARK;MN "$after";fi
	if [[ $after -eq 0   ]] || [[ $before -eq $LM ]];then
	UNMARK; MN "$before"; MN "$after";fi;j=$i;UNMARK;MN "$before" ; MN "$after";}
	MN(){ line=$(( $1  + 1 + $TOP_LANE )); 
		TPUT "$line" 5 ; 
		EMPTY1="                        "
		EMPTY2="                       "
		OUTPUT_OPTION_L="${MENU_OPTIONS[$1]:-None}" ;
		$e "${EMPTY1:$(( ${#OUTPUT_OPTION_L} / 2 ))} ${OUTPUT_OPTION_L} ${EMPTY2:$(( ${#OUTPUT_OPTION_L} / 2 ))}";
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

# more than two options will be handled correctly
show_menu() {
	i=0
	COUNT_LM
	INITN
	while [[ "$O" != " " ]] ; do
		S="MN $i" ; SC; if [[ $cur = "" ]]; then C; TPUT 1 1 ; return $i;fi
		POSITION
	done
}

# more than two options will be handled correctly
show_menu_quit() {
	i=0
	COUNT_LM
	LM=$(( $LM + 1 ))
	MENU_OPTIONS[$LM]="exit"
	INITN
	while [[ "$O" != " " ]] ; do
		S="MN $i" ; SC; if [[ $cur = "" ]]; then C; TPUT 1 1 ; if [[ "$i" = "$LM" ]] ; then exit 0; fi; return $i;fi
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

MENU_OPTIONS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 )
TITLE="multiple selection"
show_menu_quit
echo "selection: $?"

