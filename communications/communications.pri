# Include required pri files.
include(../harmattanapishowcase.pri)

# Set headers and sources with parent relative path.
HEADERS += communications/messenger.h 	\
	communications/twitsender.h 	\
	communications/nfcsendvcard.h 	\
	communications/vcardrecord.h
    
SOURCES += communications/messenger.cpp \
	communications/twitsender.cpp 	\
	communications/vcardrecord.cpp \
	communications/nfcsendvcard.cpp

OTHER_FILES += communications/operators2xml/operators.xml

# Add required modules to mobility spec.
MOBILITY += messaging contacts connectivity versit organizer systeminfo

# Add required modules to config spec.
CONFIG += qdeclarative-boostable shareuiinterface-maemo-meegotouch meegotouchevents

# Set required pkgconfig spec.
PKGCONFIG += QtDeclarative 

# Set source and target.
communications.source = communications/qml/
communications.target = communications/

# Add deployment files.
DEPLOYMENTFOLDERS += communications

# Lets add additional file to installation
operators.files = communications/operators2xml/operators.xml
operators.path = /usr/share/harmattanapishowcase

# Install targets.
INSTALLS += operators 
