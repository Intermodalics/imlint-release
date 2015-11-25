if (_IMLINT_EXTRAS_INCLUDED_)
  return()
endif()
set(_IMLINT_EXTRAS_INCLUDED_ TRUE)

@[if INSTALLSPACE]@
# bin and template dir variables in installspace
set(IMLINT_SCRIPTS_DIR "${imlint_DIR}/../../../@(CATKIN_PACKAGE_BIN_DESTINATION)")
@[else]@
# bin and template dir variables in develspace
set(IMLINT_SCRIPTS_DIR "@(CMAKE_CURRENT_SOURCE_DIR)/scripts")
@[end if]@

macro(_imlint_create_targets)
  # Create the master "imlint" target if it doesn't exist yet.
  if (NOT TARGET imlint)
    add_custom_target(imlint)
  endif()

  # Create the "imlint_pkgname" target if it doesn't exist yet. Doing this
  # with a check means that multiple linters can share the same target.
  if (NOT TARGET imlint_${PROJECT_NAME})
    add_custom_target(imlint_${PROJECT_NAME})
    add_dependencies(imlint imlint_${PROJECT_NAME})
  endif()
endmacro()

# Run a custom lint command on a list of file names.
#
# :param linter: linter command name.
# :param lintopts: linter options.
# :param argn: a non-empty list of files to process.
# :type string
#
function(imlint_custom linter lintopts)
  if ("${ARGN}" STREQUAL "")
    message(WARNING "imlint: no files provided for command")
  else ()
    _imlint_create_targets()
    add_custom_command(TARGET imlint_${PROJECT_NAME} POST_BUILD
                       WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                       COMMAND ${linter} ${lintopts} ${ARGN} VERBATIM)
  endif()
endfunction()

# Run cpplint on a list of file names.
#
function(imlint_cpp)
  if ("${ARGN}" STREQUAL "")
    file(GLOB_RECURSE ARGN *.cpp *.h)
  endif()
  if (NOT DEFINED IMLINT_CPP_CMD)
    set(IMLINT_CPP_CMD ${IMLINT_SCRIPTS_DIR}/cpplint)
  endif()
  imlint_custom("${IMLINT_CPP_CMD}" "${IMLINT_CPP_OPTS}" ${ARGN})
endfunction()

# Run pep8 on a list of file names.
#
function(imlint_python)
  if ("${ARGN}" STREQUAL "")
    file(GLOB_RECURSE ARGN *.py)
  endif()
  if (NOT DEFINED IMLINT_PYTHON_CMD)
    set(IMLINT_PYTHON_CMD ${IMLINT_SCRIPTS_DIR}/pep8)
  endif()
  imlint_custom("${IMLINT_PYTHON_CMD}" "${IMLINT_PYTHON_OPTS}" ${ARGN})
endfunction()

# Run imlint for this package as a test.
function(imlint_add_test)
  catkin_run_tests_target("imlint" "package" "imlint-${PROJECT_NAME}.xml"
    COMMAND "${IMLINT_SCRIPTS_DIR}/test_wrapper ${CATKIN_TEST_RESULTS_DIR}/${PROJECT_NAME}/imlint-${PROJECT_NAME}.xml make imlint_${PROJECT_NAME}"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
endfunction()
