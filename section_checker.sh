#!/bin/bash

# color mode: three: console/html/none
COLOR_MODE=${COLOR_MODE:-"console"}
SC_MSG_WIDTH=${SC_MSG_WIDTH:-`tput cols`}
SC_SECTION_CH=${SC_SECTION_CH:-+}
SC_SUB_CHECK_CH=${SC_SUB_CHECK_CH:--}
SC_SUCC_MSG=${SC_SUCC_MSG:-success}
SC_FAIL_MSG=${SC_FAIL_MSG:-failed}
SC_SEC_BEGIN_MSG=${SC_SEC_BEGIN_MSG:-"Start to check"}
SC_SEC_CHECK_MSG=${SC_SEC_CHECK_MSG:-"checking"}
SC_SEC_PRINT_END=${SC_SEC_PRINT_END:-"true"}
SC_EXPORT=${SC_EXPORT:-""}

if test "$COLOR_MODE" = "console" ; then
  sc_succ_color="tput setaf 2"
  sc_fail_color="tput setaf 1"
  sc_clear_color="tput sgr0"
elif test "$Color_mode" = "html" ; then
  sc_succ_color="printf %s <font color='green' >"
  sc_fail_color="printf %s <font color='red' >"
  sc_clear_color="printf %s </font>"
else
  sc_succ_color=
  sc_fail_color=
  sc_lear_color=
fi
if test "$SC_EXPORT" = "1" ; then
  export section_title=${section_title:-"None"}
  export section_result=${section_result:-"failed"}
  export section_total=${section_total:-1}
  export section_global_fail_result=${section_global_fail_result:-0}
  export section_global_success_result=${section_global_success_result:-0}
  export section_sub=${section_sub:-0}
  export section_prefix=${section_prefix:-''}
  export section_sub_prefix=${section_sub_prefix:-''}
  export section_titles=${section_titles:-("None")}
  export section_check_msg_length=${section_check_msg_length:-$(( $SC_MSG_WIDTH - 22))}
else
  section_title=${section_title:-"None"}
  section_result=${section_result:-"failed"}
  section_total=${section_total:-1}
  section_global_fail_result=${section_global_fail_result:-0}
  section_global_success_result=${section_global_success_result:-0}
  section_sub=${section_sub:-0}
  section_prefix=${section_prefix:-''}
  section_sub_prefix=${section_sub_prefix:-''}
  section_titles=${section_titles:-("None")}
  section_check_msg_length=${section_check_msg_length:-$(( $SC_MSG_WIDTH - 22))}
fi

#call_sub_scripts() {
  #export section_
#}


sc_line() {
	var=$1
	if test "$(( $var <= 0 ))" = "1" ; then
		echo ""
		return
	fi
	ch="%.s${2:-'-'}"
	var=`seq 1 $var`
	printf "${ch}" $var
}

sc_line_mid() {
  line=$1
  msg=$2
  printf "%s%s%s" "${line:0:$(( (${#line} - ${#msg})/2 ))}" "${msg}" "${line:$(( (${#line} + ${#msg})/2))}"
}

section_begin_ending_msg=`sc_line $(( $SC_MSG_WIDTH - 11 )) ' '``sc_line 10 "$SC_SECTION_CH"`
section_end_ending_msg=`sc_line $(( $SC_MSG_WIDTH - 11 )) ' '`
section_end_ending_msg_2=`sc_line 10 '-'`

sc_dot_msg() {
  msg=$1
  len=$2
  if test "$(( $len <= 3 ))" = "1" ; then
    echo "..."
    return 0
  fi
  dot_len=$(( ${#msg} - $len > 0 ? 3 : 0 ))
  echo "${msg:0:$(($len-$dot_len))}`sc_line $dot_len '.'`"
}

SC_CHECK_MATH() {
  a=$1
  op=$2
  b=$3
  msg=$4
  color=""
  show_msg=""
  cmp=`awk -v n1=$a -v n2=$b "BEGIN{ if (n1${op}n2) exit 1; exit 0}" ; echo $?`
  if test "$cmp" = "0" ; then
    color="$sc_fail_color"
    section_result="$SC_FAIL_MSG"
    section_total=0
    section_global_fail_result=$(( $section_global_fail_result + 1 ))
    show_msg="$a $op $b"
  else
    color="$sc_succ_color"
    section_result="$SC_SUCC_MSG"
    section_global_success_result=$(( $section_global_success_result + 1 ))
    l_sec_msg_len=$(( (${section_check_msg_length} - ${#section_sub_prefix} - ${#SC_SEC_CHECK_MSG} - 10 - ${#msg})/2))
    if test "$(( $l_sec_msg_len < 1 ))" = "1" ; then
      l_sec_msg_len=1
    fi

    show_msg="`sc_dot_msg "$a" ${l_sec_msg_len}` $op `sc_dot_msg "$b" ${l_sec_msg_len}`"
  fi
  if test "$msg" != "" ; then
    t_msg="${section_sub_prefix} $SC_SEC_CHECK_MSG $msg : $show_msg   "
    printf "%s%s" "$t_msg" "${section_end_ending_msg:$(( ${#t_msg}+${#section_result}))}" 
    $color
    printf "%s" "$section_result"
    if test "$color" != "" ; then  
      $sc_clear_color
    fi
    printf "\n"
  fi
}

SC_MSG() {
  msg=$1
  l_sec_msg_len=$(( ${SC_MSG_WIDTH} - ${#section_sub_prefix} - 25 ))
  show_msg=`sc_dot_msg "$msg" "$l_sec_msg_len"`
  t_msg="${section_sub_prefix} $show_msg"
  echo "$t_msg"
}

SC_CHECK_MSG() {
  a=$1
  op=$2
  b=$3
  msg=$4
  color=""
  show_msg=""
  if ! test "$a" $op "$b"; then
    color="$sc_fail_color"
    section_result="$SC_FAIL_MSG"
    section_total=0
    section_global_fail_result=$(( $section_global_fail_result + 1 ))
    show_msg="$a $op $b"
  else
    color="$sc_succ_color"
    section_result="$SC_SUCC_MSG"
    section_global_success_result=$(( $section_global_success_result + 1 ))
    l_sec_msg_len=$(( ( ${section_check_msg_length} - ${#section_sub_prefix} - ${#SC_SEC_CHECK_MSG} - 10 -  ${#msg})/2))
    if test "$(( $l_sec_msg_len < 1 ))" = "1" ; then
      l_sec_msg_len=1
    fi
    show_msg="`sc_dot_msg "$a" ${l_sec_msg_len}` $op `sc_dot_msg "$b" ${l_sec_msg_len}`"
  fi

  if test "$msg" != "" ; then
    t_msg="${section_sub_prefix} $SC_SEC_CHECK_MSG $msg : $show_msg   "
    printf "%s%s" "$t_msg" "${section_end_ending_msg:$(( ${#t_msg}+${#section_result}))}"
    $color
    printf "%s" "$section_result"
    if test "$color" != "" ; then
      $sc_clear_color
    fi
    printf "\n"
  fi
}

SC_BEGIN_SECTION() {
  section_title=$1
  section_titles[$section_sub]=$section_title
  section_prefix=`sc_line $section_sub ' '`
  section_sub=$(( $section_sub + 1 ))
  section_prefix="${section_prefix}`sc_line $section_sub "$SC_SECTION_CH"`"
  section_sub_prefix="`sc_line ${section_sub} '  '`${SC_SUB_CHECK_CH} "
  if test "$section_title" != "" ; then
    #echo "+   Start to check ${Section}:"
    #ending_msg="                                        +++++++++++++++++++++++++++"
    msg_front="$section_prefix $SC_SEC_BEGIN_MSG ${section_title}: "
    printf "%s %s\n" "$msg_front" "${section_begin_ending_msg:${#msg_front}}"
  fi
  if test "$section_sub" = "1" ; then
    section_total=1
  fi
}

SC_CHECK_FAIL_END_SECTION() {
  msg=$1
  if test "$section_total" = "0" ; then
    # there is failed checking, and we can not continue
    $sc_fail_color
    SC_MSG "$msg"
    $sc_clear_color
    SC_END_SECTION
    exit 1
  fi
  return 0
}

SC_END_SECTION() {
  #empty="                                                                     "
  section_prefix="`sc_line $(( $section_sub - 1 )) ' '`-- "
  section_sub=$(( $section_sub - 1 ))
  section_title=${section_titles[$section_sub]}

  if ! test "$SC_SEC_PRINT_END" = "true" ; then
	return
  fi

  #empty="                                                            --------------     "
  #msg="--  ${Section} check result: "
  msg="${section_prefix}  ${section_title} check result: "
  result="unknown"
  color=""
  if test "$section_total" = "0" ; then
    color="$sc_fail_color"
    result="$SC_FAIL_MSG"
  else
    color="$sc_succ_color"
    result="$SC_SUCC_MSG"
  fi
  #printf "%s %s " "$msg" "${section_end_ending_msg:$(( ${#msg} + ${#result} )) }" 
  #printf "%s %s " "$msg" "${section_end_ending_msg:${#msg}}" 
  printf "%s" "$msg"
  printf "%s" "${section_end_ending_msg:$(( ${#msg} + ${#result} )) }" 
  $color
  printf "%s" "$result "
  if test "$color" != "" ; then  
    $sc_clear_color
  fi
  printf "%s" "${section_end_ending_msg_2}"
  printf "\n"
  if test "$(( $section_sub < 1 ))" = "1" ; then
    printf "\n"
  fi
}

SC_PRE_HEADER() {
  sc_line $SC_MSG_WIDTH '='
  printf "\n"
  final_line="=`sc_line $(( $SC_MSG_WIDTH - 2 )) ' '`="
  echo "$final_line"
  wel_msg=$1
  sc_line_mid "$final_line" "$wel_msg"
  echo ""
  echo "$final_line"
  sc_line $SC_MSG_WIDTH '='
  echo ""
}

SC_FINAL_SUMMARY() {
  sc_line $SC_MSG_WIDTH '='
  printf "\n"
  final_line="=`sc_line $(( $SC_MSG_WIDTH - 2 )) ' '`="
  echo "$final_line"
  failed_msg="total $SC_FAIL_MSG: ${section_global_fail_result}"
  #printf "%s%s%s" "${final_line:0:$(( (${#final_line} - ${#failed_msg})/2 )) }" "${failed_msg}" "${final_line:$(( (${#final_line} + ${#failed_msg})/2))}"
  sc_line_mid "$final_line" "$failed_msg"
  echo ""
  success_msg="total $SC_SUCC_MSG: ${section_global_success_result}"
  sc_line_mid "$final_line" "$success_msg"
  echo ""
  echo "$final_line"
  sc_line $SC_MSG_WIDTH '='
  echo ""
}


