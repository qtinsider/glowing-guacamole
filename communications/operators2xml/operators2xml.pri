#-------------------------------------------------
#
# Project created by QtCreator 2012-01-12:39:06
#
#-------------------------------------------------

QT       += core
QT       += xml
QT       -= gui

TARGET = operators2xml
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

# Add other required file to installation.
operators.files = operators.xml
operators.path = /usr/share/harmattanapishowcase

# Install targets.
INSTALLS += operators

