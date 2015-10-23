#!/bin/bash

# de-rvmify
# and switch to rbenv

# unset functions (length 'declare -f ' = 11)
for fn in $(typeset -F | sed -e 's/^.\{11\}//')
do
  unset -f "$fn"
done
# unset envir vars
for ev in $(set | grep -i '^rvm\|^gem' | sed -e 's/[=].*$//')
do
  unset "$ev"
done
unset ev fn script IRBRC file
# clear aliases
unalias -a

_RBENVPATH=''
IFS=':'
for p in $PATH
do
  if [[ ! "$p" =~ .*rvm/.* ]]
  then
      if [[ -z "$_RBENVPATH" ]]
      then
	  _RBENVPATH="${p}"
      else
	  _RBENVPATH="${_RBENVPATH}:${p}"
      fi   
  fi
done

export RBENV_ROOT=$HOME/.rbenv
export PATH="${RBENV_ROOT}/bin:${_RBENVPATH}"
unset p _RBENVPATH IFS

eval "$(rbenv init -)"

# allow setting ruby version via $1
if [[ -n "$1" ]]; then
  export RBENV_VERSION="$1"
fi
