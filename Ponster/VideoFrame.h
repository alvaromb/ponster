//
//  VideoFrame.h
//  Ponster
//
//  Created by Álvaro on 04/05/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#ifndef Ponster_VideoFrame_h
#define Ponster_VideoFrame_h

#include <cstddef>

struct VideoFrame
{
    size_t width;
    size_t height;
    size_t bytesPerRow;
    
    unsigned char * data;
};

#endif
