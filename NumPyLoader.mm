//
//  NumPyLoader.mm
//  NumPy2ROI
//
//  Created by Christopher Chute on 7/23/18.
//

#import "NumPyLoader.h"
#import "WrapperClass.h"

@implementation NumPyLoader

- (NSMutableArray*) load:(NSString*) fname {
    self.wrapper = [[WrapperClass alloc] init];
    NSMutableArray *result = [self.wrapper getNpyArray:fname];
    return result;
}

@end
