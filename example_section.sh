#!/bin/bash

source section_checker.sh

#sc_line 10 "-"
#sc_line 10 " "
#sc_line 10 "+"

printf "\n\n"

SC_PRE_HEADER "Testing"

SC_BEGIN_SECTION "Section 1"
SC_BEGIN_SECTION "Section 1.1"
SC_CHECK_MATH "10" ">" "5" "free memory"
SC_CHECK_MATH "10" "<" "5" "free memory again" 
SC_CHECK_MATH "10" "==" "10.0" "free memory again" 
SC_CHECK_MATH "10.51" "<" "10.5" "float" 
SC_CHECK_MATH "10.51" ">" "10.5" "float" 
SC_CHECK_MATH "10.51" ">" "10.50" "float" 
SC_CHECK_MATH "10.51" "==" "10.50" "float" 
SC_CHECK_MATH "100000000000000000000000000" "<" "5" "free too long" 
SC_CHECK_MATH "100000000000000000000000000" ">" "5" "free too long" 
SC_END_SECTION
SC_CHECK_MATH "30" "==" "30" "delay lag"
SC_END_SECTION
SC_BEGIN_SECTION "Section 2"
SC_CHECK_MSG "welcomewelcomewelcomewelcome" "=" "welcomewelcomewelcomewelcome" "msg too long"
SC_CHECK_MSG "welcomewelcomewelcomewelcome" "!=" "welcomewelcomewelcomewelcome" "msg too long"
SC_CHECK_MSG "welcome" "!=" "welcome" "msg equal"
SC_CHECK_MSG "welcome" "=" "welcome" "msg equal"
SC_END_SECTION
SC_BEGIN_SECTION "ALL success"
SC_CHECK_MSG "welcome" "=" "welcome" "msg equal"
SC_CHECK_MSG "welcome" "=" "welcome" "msg equal"
SC_CHECK_MSG "welcome" "=" "welcome" "msg equal"
SC_END_SECTION

SC_FINAL_SUMMARY
