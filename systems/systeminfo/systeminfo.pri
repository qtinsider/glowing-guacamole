# Include required pri files.
include(../../harmattanapishowcase.pri)

# Add required headers and sources.
HEADERS += systems/systeminfo/qmbatteryreader.h         \
        systems/systeminfo/qmcabcreader.h 		\
        systems/systeminfo/qmdevicemodereader.h 	\
        systems/systeminfo/qmdisplaystatereader.h 	\
        systems/systeminfo/qmsystemstatereader.h 	\
        systems/systeminfo/qmtimereader.h

SOURCES += systems/systeminfo/qmbatteryreader.cpp 	\
        systems/systeminfo/qmcabcreader.cpp             \
        systems/systeminfo/qmdevicemodereader.cpp 	\
        systems/systeminfo/qmdisplaystatereader.cpp	\
        systems/systeminfo/qmsystemstatereader.cpp 	\
        systems/systeminfo/qmtimereader.cpp

# Add required modules to mobility spec.
MOBILITY += systeminfo

# Add required include path and libs.
INCLUDEPATH += /usr/include/qmsystem2/
LIBS += -lqmsystem2

# Lets define the deployment source tree folders and their target directories in the deployment
systeminfo.source = systems/systeminfo/qml/
systeminfo.target = systems/systeminfo/

# Add deployment files.
DEPLOYMENTFOLDERS += systeminfo
