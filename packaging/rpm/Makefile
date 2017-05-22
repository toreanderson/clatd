# Build the clatd RPM package from the GIT packaging/rpm directory.
#
# This package should be able to be built from the GIT repo by typing
# make in the packaging/rpm directory.
#
# If this doesn't happen then that is a bug that needs to be reported.
# There may be better ways, of so, please educate me.

SPECFILE=clatd.el6.spec
NAME    := $(shell grep '^Name: ' < $(SPECFILE) | sed -e 's;^Name: ;;')
VERSION := $(shell grep '^Version: ' < $(SPECFILE) | sed -e 's;^Version: ;;')
FILENAME=${NAME}-${VERSION}
TARNAME=${FILENAME}.tar.gz

TOPDIR=$(shell cd ../..; echo `pwd`)
DESTDIR=`pwd`

all :
	cd ../../..; \
	  rm -rf ${FILENAME}; \
	  cp -r ${TOPDIR} ${FILENAME}; \
	  tar cfz ${TARNAME} ${FILENAME} --exclude=.git; \
	  rm -rf ${FILENAME}
	mv ../../../${TARNAME} .
	rpmbuild -ta ${TARNAME}
	rm -rf ${TARNAME}
