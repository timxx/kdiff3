/* config-kdiff3.h.cmake. */

/* Define to 1 if you have KDE4 libkonq shared library installed */
#cmakedefine HAVE_LIBKONQ 1

#cmakedefine BUILD_WITH_KDE4 1
#define TRANSLAIONS_DIR "@LOCALE_INSTALL_DIR@"

#ifndef BUILD_WITH_KDE4
#  include "kreplacements.h"
#endif

#define VERSION_STR "@VERSION_STR@"