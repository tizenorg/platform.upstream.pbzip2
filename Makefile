# Make file for parallel BZIP2
SHELL = /bin/sh

# Compiler to use
CC = g++
CFLAGS = -O2
#CFLAGS += -g -Wall
#CFLAGS += -ansi
#CFLAGS += -pedantic
#CFLAGS += -std=c++0x

# Comment out CFLAGS line below for compatability mode for 32bit file sizes
# (less than 2GB) and systems that have compilers that treat int as 64bit
# natively (ie: modern AIX)
CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

# Uncomment CFLAGS line below if you want to compile pbzip2 without load
# average support for systems that do not support it
#CFLAGS += -DPBZIP_NO_LOADAVG

# Uncomment CFLAGS line below to get debug output
#CFLAGS += -DPBZIP_DEBUG

# Comment out CFLAGS line below to disable pthread semantics in code
CFLAGS += -D_POSIX_PTHREAD_SEMANTICS

# Comment out CFLAGS line below to disable Thread stack size customization
CFLAGS += -DUSE_STACKSIZE_CUSTOMIZATION

# Comment out CFLAGS line below to explicity set ignore trailing garbage
# default behavior: 0 - disabled; 1 - enabled (ignore garbage by default)
# If IGNORE_TRAILING_GARBAGE is not defined: behavior is automatically determined
# by program name: bzip2, bunzip2, bzcat - ignore garbage; otherwise - not.
#CFLAGS += -DIGNORE_TRAILING_GARBAGE=1

# On some compilers -pthreads
CFLAGS += -pthread

# External libraries
LDFLAGS = -lbz2
LDFLAGS += -lpthread

# Where you want pbzip2 installed when you do 'make install'
PREFIX = /usr

all: pbzip2

# Standard pbzip2 compile
pbzip2: pbzip2.cpp BZ2StreamScanner.cpp ErrorContext.cpp
	$(CC) $(CFLAGS) $^ -o pbzip2 $(LDFLAGS)

# Choose this if you want to compile in a static version of the libbz2 library
pbzip2-static: pbzip2.cpp BZ2StreamScanner.cpp ErrorContext.cpp libbz2.a
	$(CC) $(CFLAGS) $^ -o pbzip2 -I. -L. $(LDFLAGS)

# Install the binary pbzip2 program and man page
install: pbzip2
	if ( test ! -d $(PREFIX)/bin ) ; then mkdir -p $(PREFIX)/bin ; fi
	if ( test ! -d $(PREFIX)/man ) ; then mkdir -p $(PREFIX)/man ; fi
	if ( test ! -d $(PREFIX)/man/man1 ) ; then mkdir -p $(PREFIX)/man/man1 ; fi
	cp -f pbzip2 $(PREFIX)/bin/pbzip2
	chmod a+x $(PREFIX)/bin/pbzip2
	ln -s -f $(PREFIX)/bin/pbzip2 $(PREFIX)/bin/pbunzip2
	ln -s -f $(PREFIX)/bin/pbzip2 $(PREFIX)/bin/pbzcat
	cp -f pbzip2.1 $(PREFIX)/man/man1
	chmod a+r $(PREFIX)/man/man1/pbzip2.1

clean:
	rm -f *.o pbzip2
