# Include required pri files.
include(../../harmattanapishowcase.pri)

# Set mobility config.
MOBILITY += sensors

# File io operation to record sensor readings
HEADERS += systems/sensors/accelerometertap/fileio.h
SOURCES += systems/sensors/accelerometertap/fileio.cpp

# Set sensor deployment files.
sensors.source = systems/sensors/sensors/qml/
sensors.target = systems/sensors/

# Set compass deployment files.
compass.source = systems/sensors/compass/qml/
compass.target = systems/compass/

# Set accelerometer taps sensors deployment files.
accelerometertap.source = systems/sensors/accelerometertap/qml/
accelerometertap.target = systems/sensors/accelerometertap

# Set deployment.
DEPLOYMENTFOLDERS += sensors compass accelerometertap

