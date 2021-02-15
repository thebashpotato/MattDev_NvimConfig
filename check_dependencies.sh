#! /bin/bash




#------------------=| Dev notes |------------------#


# First step: Checking what type of linux distro (2 categories supported?)
# debian OR arch/manjaro bases
# Command is lsb-release . 


# What programs are needed? 
# For Debian: git, curl, python3-pip, python3-venv, Rust
# exuberant-ctags, ack-grep
# Pip packages: pynvim flake8 pylint isort 


# For Arch/Manjaro: git, curl, python3, pip, ctags, Rust
# Pip packages: pynvim flake8 isort  


# Where do you get Cargo? Does it come with Rust?

# Warning: Do not use "which" to check for programs
# https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script


# One function to check for each tier of dependencies.

#---------------=| End of Dev notes |=-------------#

 

 




# tier-1: programs that are installed through the shell.    
tier1=("git" "curl" "ctags" "python3" "pip" "ack" "ctags")
# tier-1b: programs that don't have a shell command but are installed through shell.
tier1b=("python3-pip" "python3-venv")


# tier-2: program packages, modules, libraries, etc.
tier2=()



function install () {
    # Parameters: (debian or arch)

    # A switch statement. Inside each case there is an if statement
    # to have separate installation commands for ubuntu and manjaro

    true

}


function tier2_check () {

    true #no-op
}




function tier1b_check () {

    true #no-op
}



function tier1_check() {

    missing=()

    for i in "${tier1[@]}" ; do

        if ! command -v "$i" &> /dev/null
            then
            echo -e "\e[91mError: $i not found.\e[0m"
            missing+=("$i")
        else 
            echo -e "\e[32m$i found.\e[0m"
        fi

    done



}

tier1_check