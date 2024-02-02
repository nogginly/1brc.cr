#!/bin/sh

# $1 app name
# $2 thread count
# $3 buffer division

CRYSTAL_WORKERS=$2 BUF_DIV_DENOM=$3 bin/$1 measurements.txt out/$1.txt
