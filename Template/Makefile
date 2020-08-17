CFLAGS=-c -std=c90 -Wall -Wextra -I.
CC=gcc
SRCS := $(wildcard *.c)
OBJS := $(SRCS:%.c=%.o)
PROG=hellomake

all: ${PROG}

${PROG}: ${OBJS}
	@echo "------------------------------"
	@echo " Creating the excutable...... "
	@echo "------------------------------"
	${CC} $? -o ${PROG}

%.o: %.c
	${CC} ${CFLAGS} $<

clean:
	rm -f *.o 
