# Include required pri files.
include(../harmattanapishowcase.pri)

# Add required headers and sources.
HEADERS += multimedia/multimediakit/audiorecorder.h	\
        multimedia/multimediakit/thumbnailutility.h     \
        multimedia/internetradio/channelitem.h \
        multimedia/internetradio/channelmodelproxy.h \
        multimedia/internetradio/gstplayer.h \
        multimedia/internetradio/listmodel.h \
        multimedia/internetradio/qeventsfeed.h

SOURCES += multimedia/multimediakit/audiorecorder.cpp \
        multimedia/multimediakit/thumbnailutility.cpp \
        multimedia/internetradio/channelitem.cpp \
        multimedia/internetradio/channelmodelproxy.cpp \
        multimedia/internetradio/gstplayer.cpp \
        multimedia/internetradio/listmodel.cpp

# Add required modules to mobility spec.
MOBILITY += multimedia

# Set source and target.
internetradio.target = multimedia/internetradio/
internetradio.source = multimedia/internetradio/qml/

# Set source and target.
multimediakit.target = multimedia/multimediakit/
multimediakit.source = multimedia/multimediakit/qml/

# Add deployment.
DEPLOYMENTFOLDERS += internetradio multimediakit

