#*****************************************************************************
# Copyright 2015-2016 Alexander Barthel albar965@mailbox.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#****************************************************************************

QT += sql core
QT -= gui

# Adapt these variables to compile on Windows
win32 {
  QT_BIN=C:\\Qt\\5.5\\mingw492_32\\bin
  GIT_BIN='C:\\Git\\bin\\git'
}
CONFIG += c++11

# Get the current GIT revision to include it into the code
win32:DEFINES += GIT_REVISION='\\"$$system($${GIT_BIN} rev-parse --short HEAD)\\"'
unix:DEFINES += GIT_REVISION='\\"$$system(git rev-parse --short HEAD)\\"'

TARGET = navdatareader
CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    navdatareader.cpp

DISTFILES += \
    uncrustify.cfg \
    BUILD.txt \
    CHANGELOG.txt \
    LICENSE.txt \
    README.txt


# Add dependencies to atools project and its static library to ensure relinking on changes
DEPENDPATH += $$PWD/../atools/src
INCLUDEPATH += $$PWD/../atools/src $$PWD/src

CONFIG(debug, debug|release) {
  LIBS += -L $$PWD/../atools/debug -l atools
  PRE_TARGETDEPS += $$PWD/../atools/debug/libatools.a
}
CONFIG(release, debug|release) {
  LIBS += -L $$PWD/../atools/release -l atools
  PRE_TARGETDEPS += $$PWD/../atools/release/libatools.a
}

RESOURCES += \
    navdatareader.qrc

HEADERS += \
    navdatareader.h

# Windows specific deploy target only for release builds
win32 {
  # Create backslashed paths
  WINPWD=$${PWD}
  WINPWD ~= s,/,\\,g
  WINOUT_PWD=$${OUT_PWD}
  WINOUT_PWD ~= s,/,\\,g
  DEPLOY_DIR_NAME=navdatareader
  DEPLOY_DIR=\"$${WINPWD}\\deploy\\$${DEPLOY_DIR_NAME}\"

  deploy.commands = rmdir /s /q $${DEPLOY_DIR} &
  deploy.commands += mkdir $${DEPLOY_DIR} &
  deploy.commands += copy $${WINOUT_PWD}\\navdatareader.exe $${DEPLOY_DIR} &&
  deploy.commands += copy $${QT_BIN}\\libgcc*.dll $${DEPLOY_DIR} &&
  deploy.commands += copy $${QT_BIN}\\libstdc*.dll $${DEPLOY_DIR} &&
  deploy.commands += copy $${QT_BIN}\\libwinpthread*.dll $${DEPLOY_DIR} &&
  deploy.commands += $${QT_BIN}\\windeployqt --compiler-runtime $${DEPLOY_DIR}
}

QMAKE_EXTRA_TARGETS += deploy

