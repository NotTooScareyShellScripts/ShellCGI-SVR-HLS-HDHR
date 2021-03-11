#!/bin/bash
# (c) 2021-01-12 Kelsie Flynn
# License GPL2
find . -name '[[:digit:]]*.cgi' -print -exec rm -v {} \;
