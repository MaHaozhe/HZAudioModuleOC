//
//  MSingletonObj.h
//  SmartDistribution
//
//  Created by MaHaoZhe on 2018/11/15.
//  Copyright © 2018 HachiTech. All rights reserved.
//

#ifndef MSingletonObj_h
#define MSingletonObj_h

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}
#endif /* MSingletonObj_h */
