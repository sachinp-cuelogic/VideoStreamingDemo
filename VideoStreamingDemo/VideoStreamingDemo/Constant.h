//
//  Constant.h
//  MachineTestDemo
//
//  Created by Sachin Patil on 24/08/15.
//  Copyright (c) 2015 Sachin Patil. All rights reserved.
//

#ifndef MachineTestDemo_Constant_h
#define MachineTestDemo_Constant_h

#define SERVER_URL @"http://192.168.10.104"

#define DEBUG_MODE

#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%s (%d)> %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif

#endif
