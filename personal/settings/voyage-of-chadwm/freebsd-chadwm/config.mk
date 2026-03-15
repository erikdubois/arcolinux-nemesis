# dwm version
VERSION = 6.5

# Customize below to fit your system

# X11 include directory
X11INC = /usr/local/include

# X11 library directory
X11LIB = /usr/local/lib

# Xinerama, comment if you don't want it
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC = /usr/local/include/freetype2

MANPREFIX = /usr/local/share/man

# includes and libs
INCS = -I${X11INC} -I${FREETYPEINC}
LIBS = -L${X11LIB} -lX11 ${XINERAMALIBS} ${FREETYPELIBS} -lXrender -lImlib2 -lXext -lc
#LIBS = -L/usr/local/lib -lX11 -lXinerama -lfontconfig -lXft -lXrender -lImlib2 -lXext -lc

# flags
CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700L -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}

# CFLAGS for debugging
#CFLAGS   = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}

# CFLAGS for optimized release
CFLAGS   = -std=c99 -pedantic -Wall -Wno-deprecated-declarations -O3 -march=native ${INCS} ${CPPFLAGS} -Wno-unused-function

# Linker flags
#LDFLAGS  = ${LIBS}
#LDFLAGS = ${LIBS} -fuse-ld=lld

# compiler and linker
CC = clang
LD = clang
LDFLAGS = ${LIBS} -fuse-ld=lld

