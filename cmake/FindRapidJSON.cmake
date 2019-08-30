# Locate rapidjson library
# This module defines
#   RAPIDJSON_FOUND
#   RAPIDJSON_INCLUDE_DIR

find_path(RAPIDJSON_INCLUDE_DIR NAMES rapidjson/rapidjson.h)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(RAPIDJSON DEFAULT_MSG RAPIDJSON_INCLUDE_DIR)

mark_as_advanced(RAPIDJSON_INCLUDE_DIR)
