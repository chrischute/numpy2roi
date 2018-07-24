//
//  WrapperClass.mm
//  NumPy2ROI
//
//  Wraps the C++ library `cnpy` so we can call from Obj-C.
//
//  Created by Christopher Chute on 7/23/18.
//

#import "WrapperClass.h"

#include "WrapperClass.h"
#include "cnpy.h"

using namespace cnpy;

@interface WrapperClass ()
@end

@implementation WrapperClass

- (NSMutableArray *)getNpyArray:(NSString *) fname {
    // Load NumPy array from disk
    std::string fname_cstr = std::string([fname UTF8String]);
    cnpy::NpyArray a = cnpy::npy_load(fname_cstr);

    // Convert NumPy array to NSMutableArray of NSNumbers
    std::vector<unsigned short> v = a.as_vec<unsigned short>();
    NSMutableArray* result = [NSMutableArray arrayWithCapacity: v.size()];
    for (size_t i = 0; i < v.size(); ++i) {
        [result addObject:[NSNumber numberWithUnsignedChar: v[i]]];
    }

    return result;
}

@end
