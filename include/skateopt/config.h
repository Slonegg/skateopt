#pragma once

#define skateopt_BUILD_SHARED

// decorators for exporting DLL functions
#ifndef __GNUC__
    #ifdef skateopt_BUILD_SHARED
        #ifdef skateopt_EXPORT
            #define SKATEOPT_EXPORT __declspec(dllexport)
        #else
            #define SKATEOPT_EXPORT __declspec(dllimport)
        #endif
    #else
        #define SKATEOPT_EXPORT
    #endif
#else
	#define SKATEOPT_EXPORT
#endif

// for boost.compute
#ifndef CL_VERSION_1_2
#   define CL_VERSION_1_2
#endif

// turn on trace and debug logging in debug mode
#ifndef NDEBUG
#   define SPDLOG_DEBUG_ON
#   define SPDLOG_TRACE_ON
#endif
