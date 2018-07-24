//
//  WrapperClass.h
//  NumPy2ROI
//
//  Wraps the C++ library `cnpy` so we can call from Obj-C.
//
//  Created by Christopher Chute on 7/23/18.
//

#ifndef WrapperClass_h
#define WrapperClass_h

#import <Foundation/Foundation.h>

#if __cplusplus

#include "cnpy.h"

@interface WrapperClass : NSObject
@end

@interface WrapperClass ()
- (NSMutableArray *)getNpyArray:(NSString *) fname;
@end


#endif

#endif /* WrapperClass_h */
