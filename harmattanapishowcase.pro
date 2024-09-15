# Application Version.
APPVERSION_MAJOR = 1
APPVERSION_MINOR = 0
APPVERSION_PATCH = 0

# Define application version.
DEFINES += APPVERSION_MAJOR=$$APPVERSION_MAJOR APPVERSION_MINOR=$$APPVERSION_MINOR APPVERSION_PATCH=$$APPVERSION_PATCH

# Set needed headers and sources.
HEADERS += \
	main/appinfo.h \
	main/appsettings.h \
	main/phonetools.h 

SOURCES += \
	main/main.cpp \
	main/phonetools.cpp

# Add package config libraries required.
PKGCONFIG += gq-gconf gstreamer-0.10

# Add main routine sources and targets.
main.source = main/qml/
main.target = main/

# Add main files deployments.
DEPLOYMENTFOLDERS += main

# Include the components to be compiled.
include(communications/communications.pri)
include(location/location.pri)
include(multimedia/multimedia.pri)
include(systems/systeminfo/systeminfo.pri)
include(systems/sensors/sensors.pri)

# Add other required files to package.
OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    data/nmea.data \
    communications/operators2xml/operators.xml \
    harmattanapishowcase.desktop \
    harmattanapishowcase.png \
    harmattanapishowcase80.png \
    harmattanapishowcase_harmattan.desktop \
    splash.png \
    qtc_packaging/debian_harmattan/manifest.aegis

# Add application splash screen and binary to install.
splashscreen.files = splash.png
splashscreen.path = /usr/share/harmattanapishowcase
INSTALLS += splashscreen

# Add the application policy file to install.
policyfile.files = harmattanapishowcase.conf
policyfile.path = /usr/share/policy/etc/syspart.conf.d/
INSTALLS += policyfile
		
# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
