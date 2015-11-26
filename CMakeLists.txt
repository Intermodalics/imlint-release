cmake_minimum_required(VERSION 2.8.3)
project(imlint)

find_package(catkin REQUIRED)

catkin_package(CFG_EXTRAS imlint-extras.cmake)
catkin_python_setup()

install(PROGRAMS scripts/cpplint scripts/pep8 scripts/test_wrapper
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY cmake
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

# Lint itself. This also serves as a smoke check of the cmake extras file.
# Please note that this complexity is due to self-checking. For typical usage, please
# see the ROS wiki: http://wiki.ros.org/imlint
if(CATKIN_ENABLE_TESTING)
  set(extra "cmake/imlint-extras.cmake")
  em_expand(${catkin_EXTRAS_DIR}/templates/cfg-extras.context.py.in
    ${CMAKE_CURRENT_BINARY_DIR}/${extra}.develspace.context.cmake.py
    ${CMAKE_CURRENT_SOURCE_DIR}/${extra}.em
    ${CMAKE_CURRENT_BINARY_DIR}/${extra})
  include(${CMAKE_CURRENT_BINARY_DIR}/${extra})

  imlint_python(
    setup.py
    src/imlint/cpplint_wrapper.py)
  imlint_add_test()
endif()
