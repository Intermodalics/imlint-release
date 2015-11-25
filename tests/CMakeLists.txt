# Only processed if CATKIN_ENABLE_TESTING is true.

# Set up CMake environment to run tests:
include(${PROJECT_SOURCE_DIR}/cmake/imlint-extras.cmake)

# no C++ tests yet

# Some simple Python unit tests, which must return zero status or make
# run_tests appears to fail.
imlint_python(${CMAKE_CURRENT_SOURCE_DIR}/clean1.py)

# This should generate a CMake warning.  How to check it?
message("The following imlint test should generate a warning message:")
imlint_custom("no_such_linter" "")

# Run pylint with expected return status:
set(_RUNLINT "${CMAKE_CURRENT_SOURCE_DIR}/runlint.py")
imlint_custom(${_RUNLINT} "0 pylint"
               ${CMAKE_CURRENT_SOURCE_DIR}/clean1.py)
imlint_custom(${_RUNLINT} "16 pylint"
               ${CMAKE_CURRENT_SOURCE_DIR}/dirty1.py)

# Make run_tests depend on the imlint targets created above.
add_custom_target(run_tests_${PROJECT_NAME})
add_dependencies(run_tests_${PROJECT_NAME} imlint_${PROJECT_NAME})
add_dependencies(run_tests run_tests_${PROJECT_NAME})
