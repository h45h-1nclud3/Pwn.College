```bash
#!/bin/bash

######################### Script to automate creating, compiling and submission of new challenge #########################
#### Note: Create a directory 'assembly' in home directory ####
LEVEL=${HOSTNAME:15:5}
TODO=$1
temp_var=""

if [[ $# -ne 1 ]]; then
    echo "Provide a (create or compile) command!"
    echo "Example: $0 create"
    echo "Example: $0 compile"
    exit 2
fi

if [[ $TODO = "create" ]]; then
    /challenge/embryoasm* &

    cd /home/hacker/assembly

    echo ".global _start" > assembly_lv$LEVEL.s
    echo "_start:" >> assembly_lv$LEVEL.s
    echo "    .intel_syntax noprefix" >> assembly_lv$LEVEL.s

    /usr/lib/code-server/lib/vscode/bin/remote-cli/code-linux.sh assembly_lv$LEVEL.s &
elif [[ $TODO = "compile" ]]; then
    cd /home/hacker/assembly
    gcc -nostdlib -o assembly_lv$LEVEL "assembly_lv$LEVEL.s"
    objdump -M intel -d "assembly_lv$LEVEL"
    objcopy --dump-section .text="assembly_lv$LEVEL.bin" assembly_lv$LEVEL

    /challenge/embryoasm* < ./assembly_lv$LEVEL.bin
fi
```
