#!/bin/bash

# Programmer:  Bryan Jacob Bell
# Begun:       17 June 2024
# Modified:    05 July 2024
# File:        make-humextra-parsed.sh
# Syntax:      sh
# Description: Makes scriabin-op64 test files using humextra command extractx

mkdir humextra-parsed

extractx -s 1 scriabin-op64.krn | ridx -GL > humextra-op64-first-spine.krn
extractx -s 2 scriabin-op64.krn | ridx -GL > humextra-op64-second-spine.krn
extractx -s 3 scriabin-op64.krn | ridx -GL > humextra-op64-third-spine.krn
extractx -s 4 scriabin-op64.krn | ridx -GL > humextra-op64-fourth-spine.krn
extractx -s 5 scriabin-op64.krn | ridx -GL > humextra-op64-fifth-spine.krn
extractx -s 6 scriabin-op64.krn | ridx -GL > humextra-op64-sixth-spine.krn
extractx -s 7 scriabin-op64.krn | ridx -GL > humextra-op64-seventh-spine.krn

for i in humextra-op64*krn
do
  mv $i humextra-parsed
done
