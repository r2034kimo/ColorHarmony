# Install script for directory: /Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/modules

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/install")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/androidcamera/.androidcamera/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/calib3d/.calib3d/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/contrib/.contrib/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/core/.core/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/features2d/.features2d/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/flann/.flann/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/gpu/.gpu/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/highgui/.highgui/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/imgproc/.imgproc/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/java/.java/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/legacy/.legacy/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/ml/.ml/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/nonfree/.nonfree/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/objdetect/.objdetect/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/ocl/.ocl/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/photo/.photo/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/python/.python/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/stitching/.stitching/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/ts/.ts/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/video/.video/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/videostab/.videostab/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/world/.world/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/core/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/imgproc/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/flann/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/highgui/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/features2d/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/calib3d/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/ml/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/video/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/objdetect/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/contrib/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/legacy/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/nonfree/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/photo/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/stitching/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/videostab/cmake_install.cmake")
  INCLUDE("/Users/r2034kimo/Documents/ComputerGraphics/ColorHarmonization/OpenCV2/ios/ios/build/iPhoneOS-armv7/modules/world/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)

