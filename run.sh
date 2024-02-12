#!/bin/sh

# $1 app name
# $2 thread count
# $3 buffer division

if [[ -z "$@" ]]; then
  echo "Usage: $0 appname [threads [division [datafile]]]"
  echo
  echo "    appname  - Name of binary in the run script location's 'bin/' folder"
  echo "    threads  - Number of threads to use; picks up CRYSTAL_WORKERS if not specified"
  echo "    dvision  - Number of buffer divisions; picks up BUF_DIV_DENOM if not specified"
  echo "    datafile - Data file to pass to the app; uses "measurements.txt" if not specified"
  echo
  exit 1
fi

threads=${CRYSTAL_WORKERS:-8}
if [[ -n "$2" ]]; then
  threads=$2
fi

division=${BUF_DIV_DENOM:-8}
if [[ -n "$3" ]]; then
  division=$3
fi

datafile=measurements.txt
if [[ -n "$4" ]]; then
  if [[ -e "$4" ]]; then
    datafile=$4
  fi
fi

CRYSTAL_WORKERS=${threads} BUF_DIV_DENOM=${division} $(dirname $0)/bin/$1 ${datafile} $(dirname $0)/out/$1_D$2_B$3.txt
