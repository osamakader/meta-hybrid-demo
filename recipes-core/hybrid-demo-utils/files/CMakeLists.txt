cmake_minimum_required(VERSION 3.10)
project(hybrid-demo VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add executable with JSON header
add_executable(hybrid-demo
    hybrid-demo.cpp
)

# Include nlohmann/json header (installed by nlohmann-json recipe)
# Yocto's cmake class automatically sets up include paths from DEPENDS

# Install binary
install(TARGETS hybrid-demo
    RUNTIME DESTINATION bin
)

# Install data files
install(FILES demo-file.txt config.json
    DESTINATION share/hybrid-demo
)

