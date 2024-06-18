#!/bin/bash

# Programmer:  Bryan Jacob Bell
# Begun:       17 June 2024
# Modified:    17 June 2024
# File:        make-humextra-parsed.sh
# Syntax:      sh
# Description: Makes scriabin-op64 test files using humextra command extractx

mkdir humextra-parsed

extractx -s 1 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-first-spine.krn
extractx -s 2 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-second-spine.krn
extractx -s 3 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-third-spine.krn
extractx -s 4 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-fourth-spine.krn
extractx -s 5 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-fifth-spine.krn
extractx -s 6 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-sixth-spine.krn
extractx -s 7 ~/Desktop/Mysterium/op64/scriabin-op64.krn | ridx -GL > humextra-op64-seventh-spine.krn

for i in humextra-op64*krn
do
  mv $i humextra-parsed
done
