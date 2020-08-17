#!/bin/bash

CC="gcc"
CFLAGS="-std=c90 -Wall -Wextra -I. -c"
SRCS=$(ls | grep "\.c$" | tr '\n' ' ')
OBJS=$(ls | grep "\.o$" | tr '\n' ' ')
MAKEFILE="Makefile"
EXEC="default"

function makefile_init() 
{
    for SRC in $SRCS
    do
        OBJ=${SRC/%.c/.o}
        if [ ! -e $OBJ ]
        then
            OBJS+="$OBJ "
        fi
    done
}

function makefile_build_object() 
{
    for SRC in $SRCS
    do
        OBJ=${SRC/%.c/.o}
        if [ $SRC -nt $OBJ ]
        then
            $CC $CFLAGS $SRC
        fi
    done        
}

function makefile_build_execute() 
{
    if [ $1 != "default" ]
    then
        sed -i '8s/.*/EXEC="'$1'"/' makefile.sh
    fi

    for OBJ in $OBJS
    do
        if [ $OBJ -nt $1 ]
        then
            $CC $OBJS -o $1
            break
        fi
    done
}

function makefile_create_file() 
{
    if [ ! -e $MAKEFILE ]
    then
        touch $MAKEFILE
        if [ $? -ne 0 ]
        then
            echo "Error creating file..."
            exit 1
        fi
    fi
    echo -e "CC\t\t:=\t${CC}" > $MAKEFILE
    echo -e "CFLAGS\t:=\t${CFLAGS}" >> $MAKEFILE
    echo -e "SRCS\t:=\t${SRCS}" >> $MAKEFILE
    echo -e "OBJS\t:=\t${OBJS}" >> $MAKEFILE
    echo -e "EXEC\t:=\t$1" >> $MAKEFILE
    echo >> $MAKEFILE
    echo -e "all: \${EXEC}" >> $MAKEFILE
    echo >> $MAKEFILE
    echo -e "\${EXEC}: \${OBJS}" >> $MAKEFILE
    echo -e "\t\${CC} \$? -o \$@" >> $MAKEFILE
    echo >> $MAKEFILE
    echo -e "%.o: %.c" >> $MAKEFILE
    echo -e "\t\${CC} \${CFLAGS} $<" >> $MAKEFILE
    echo >> $MAKEFILE
    echo -e "run: " >> $MAKEFILE
    echo -e "\t./\${EXEC}" >> $MAKEFILE
    echo >> $MAKEFILE
    echo -e "clean: " >> $MAKEFILE
    echo -e "\trm -f *.o \${EXEC}" >> $MAKEFILE
}
function makefile_run()
{
    if [ ! -e $EXEC ]
    then
        echo "Executable file not found"
    else
        ./$EXEC
    fi
}
function makefile_clean() 
{
    rm -f *.o $EXEC
}

function makefile_help() 
{
    echo "Usage : ./make.sh [OPTION]"
    echo -e "\t-e  : build executable file immediately"
    echo -e "\t-en : build executable file with a specific name immediately"
    echo -e "\t-m  : build Makefile only"
    echo -e "\t-mn : build Makefile with a specific name"
    echo -e "\t-c  : Clean object files and executable file"
    echo -e "\t-r  : Run the executable file"
}

########
# Main #
########

OPT=$1
if [ $# -eq 0 ]
then
    OPT="-e"
fi
#set -x
makefile_init
case $OPT in 
    "-e")
        echo "Create executable file..."
        makefile_build_object
        makefile_build_execute $EXEC
        echo "Done !!!"
        ;;
    "-en")
        read -p "Enter name of executable file : " EXEC
        echo "Create executable file..."
        makefile_build_object
        makefile_build_execute $EXEC
        echo "Done !!!"
        ;;
    "-m")
        echo "Create Makefile..."
        makefile_create_file $EXEC
        echo "Done !!!"
        ;;
    "-mn")
        read -p "Enter name of executable file : " EXEC
        echo "Create Makefile..."
        makefile_create_file $EXEC
        echo "Done !!!"
        ;;
    "-c")
        makefile_clean
        echo "Clean complete"
        ;;
    "-r")
        makefile_run
        ;;
    *)  makefile_help
        ;;
esac
#set +x
