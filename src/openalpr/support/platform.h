#ifndef OPENALPR_PLATFORM_H
#define OPENALPR_PLATFORM_H

#include <string.h>
#include <sstream>

#ifdef MSVC
#include <windows.h>
#elif MINGW
#include <windows.h>
#include <unistd.h>
#else
#include <unistd.h>
#endif

namespace alpr
{

  void sleep_ms(int sleepMs);

  std::string getExeDir();

}

#endif //OPENALPR_PLATFORM_H
