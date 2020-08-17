CC		:=	gcc
CFLAGS	:=	-std=c90 -Wall -Wextra -I. -c
SRCS	:=	A.c B.c main.c 
OBJS	:=	A.o B.o main.o 
EXEC	:=	default

all: ${EXEC}

${EXEC}: ${OBJS}
	${CC} $? -o $@

%.o: %.c
	${CC} ${CFLAGS} $<

run: 
	./${EXEC}

clean: 
	rm -f *.o ${EXEC}
