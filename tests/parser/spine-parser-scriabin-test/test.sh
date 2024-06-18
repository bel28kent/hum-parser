#!/bin/bash

# Programmer:  Bryan Jacob Bell
# Begun:       17 June 2024
# Modified:    17 June 2024
# File:        test.sh
# Syntax:      sh
# Description: tests spine-parser.rkt by comparing racket-parsed files with humextra-parsed files
#    test passes if no output (i.e. no differences between files)

diff racket-parsed/racket-op64-first-spine.krn   humextra-parsed/humextra-op64-first-spine.krn
diff racket-parsed/racket-op64-second-spine.krn  humextra-parsed/humextra-op64-second-spine.krn
diff racket-parsed/racket-op64-third-spine.krn   humextra-parsed/humextra-op64-third-spine.krn
diff racket-parsed/racket-op64-fourth-spine.krn  humextra-parsed/humextra-op64-fourth-spine.krn
diff racket-parsed/racket-op64-fifth-spine.krn   humextra-parsed/humextra-op64-fifth-spine.krn
diff racket-parsed/racket-op64-sixth-spine.krn   humextra-parsed/humextra-op64-sixth-spine.krn
diff racket-parsed/racket-op64-seventh-spine.krn humextra-parsed/humextra-op64-seventh-spine.krn
