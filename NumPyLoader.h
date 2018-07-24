//
//  NumPyLoader.h
//  NumPy2ROI
//
//  Created by Christopher Chute on 7/23/18.
//

#ifndef NumPyLoader_h
#define NumPyLoader_h

#import <Foundation/Foundation.h>
#import "WrapperClass.h"

@interface NumPyLoader : NSObject
@end

@interface NumPyLoader()
@property (nonatomic, strong) WrapperClass *wrapper;
- (NSMutableArray*) load:(NSString*) fname;
@end

#endif /* NumPyLoader_h */
