# Include required pri files.
include(../harmattanapishowcase.pri)

# Add location module to mobility spec.
MOBILITY += location

# Add required goecoding headers and sources.
HEADERS += location/geocoding/reversegeocode.h 
SOURCES += location/geocoding/reversegeocode.cpp

# Set source and target.
geocoding.target = location/geocoding
geocoding.source = location/geocoding/qml/

# Add required landmarks headers and sources.
HEADERS += location/landmarks/landmarkshelper.h
SOURCES += location/landmarks/landmarkshelper.cpp

# Set source and target.
landmarks.target = location/landmarks
landmarks.source = location/landmarks/qml/

# Add deployment.
DEPLOYMENTFOLDERS += geocoding landmarks


