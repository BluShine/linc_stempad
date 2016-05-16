#ifndef _LINC_STEMPAD_H_
#define _LINC_STEMPAD_H_
    
#include "../lib/libstem/src/Gamepad.h"

#include <hxcpp.h>

#undef RegisterClass
#include "stempad/stempad.h"
#undef RegisterClass


namespace linc {

    namespace stempad {

        extern int example();

    } //stempad namespace

} //linc

#endif //_LINC_STEMPAD_H_
