#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <unistd.h>
#include <vector>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

void printHeader() {
    std::cout << "========================================" << std::endl;
    std::cout << "  Hybrid Demo Application" << std::endl;
    std::cout << "  Built with Yocto + CMake" << std::endl;
    std::cout << "  Running on ISAR" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << std::endl;
}

void printSystemInfo() {
    std::cout << "System Information:" << std::endl;
    char hostname[256];
    if (gethostname(hostname, sizeof(hostname)) == 0) {
        std::cout << "  Hostname: " << hostname << std::endl;
    } else {
        std::cout << "  Hostname: unknown" << std::endl;
    }
    std::cout << std::endl;
}

void parseAndDisplayConfig(const std::string& configPath) {
    std::ifstream file(configPath);
    if (!file.good()) {
        std::cout << "Warning: Config file not found: " << configPath << std::endl;
        std::cout << std::endl;
        return;
    }
    
    try {
        json config;
        file >> config;
        
        std::cout << "Configuration (from JSON):" << std::endl;
        
        // Parse application info
        if (config.contains("application")) {
            auto& app = config["application"];
            if (app.contains("name")) {
                std::cout << "  Application: " << app["name"].get<std::string>();
                if (app.contains("version")) {
                    std::cout << " v" << app["version"].get<std::string>();
                }
                std::cout << std::endl;
            }
            if (app.contains("description")) {
                std::cout << "  Description: " << app["description"].get<std::string>() << std::endl;
            }
        }
        
        // Parse build info
        if (config.contains("build_info")) {
            auto& buildInfo = config["build_info"];
            std::string buildSystem = buildInfo.value("build_system", "");
            std::string targetSystem = buildInfo.value("target_system", "");
            std::string arch = buildInfo.value("architecture", "");
            
            if (!buildSystem.empty() || !targetSystem.empty()) {
                std::cout << "  Build System: " << buildSystem << " -> " << targetSystem;
                if (!arch.empty()) {
                    std::cout << " (" << arch << ")";
                }
                std::cout << std::endl;
            }
        }
        
        // Parse features
        if (config.contains("features")) {
            auto& features = config["features"];
            std::cout << "  Features:" << std::endl;
            for (auto& [key, value] : features.items()) {
                if (value.is_boolean() && value.get<bool>()) {
                    std::cout << "    - " << key << std::endl;
                }
            }
        }
        
        // Parse demo data array
        if (config.contains("demo_data") && config["demo_data"].contains("items")) {
            auto& items = config["demo_data"]["items"];
            if (items.is_array() && !items.empty()) {
                std::cout << "  Demo Items:" << std::endl;
                for (const auto& item : items) {
                    std::cout << "    - " << item.get<std::string>() << std::endl;
                }
            }
        }
        
        std::cout << std::endl;
        
    } catch (const json::parse_error& e) {
        std::cerr << "JSON parse error: " << e.what() << std::endl;
        std::cout << std::endl;
    } catch (const json::type_error& e) {
        std::cerr << "JSON type error: " << e.what() << std::endl;
        std::cout << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Error parsing config: " << e.what() << std::endl;
        std::cout << std::endl;
    }
}

int main(int argc, char *argv[]) {
    printHeader();
    printSystemInfo();
    
    // Parse and display JSON configuration
    std::string configPath = "/usr/share/hybrid-demo/config.json";
    parseAndDisplayConfig(configPath);
    
    // Check demo file
    std::string demoFile = "/usr/share/hybrid-demo/demo-file.txt";
    std::ifstream demoFileStream(demoFile);
    if (demoFileStream.good()) {
        std::cout << "Demo file found: " << demoFile << std::endl;
    }
    
    std::cout << "This demonstrates:" << std::endl;
    std::cout << "  - C++ application built with CMake" << std::endl;
    std::cout << "  - JSON configuration parsing (nlohmann/json library)" << std::endl;
    std::cout << "  - Yocto build system integration" << std::endl;
    std::cout << "  - ISAR deployment via .deb packages" << std::endl;
    std::cout << "  - Hybrid build approach (Yocto + Debian)" << std::endl;
    std::cout << std::endl;
    
    return 0;
}
