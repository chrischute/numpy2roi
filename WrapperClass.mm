//
//  WrapperClass.mm
//  NumPy2ROI
//
//  Wraps the C++ library `cnpy` so we can call from Obj-C.
//
//  Created by Christopher Chute on 7/23/18.
//

#import "WrapperClass.h"

#include<cstdlib>
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
    NSMutableArray* result = NULL;
    if (a.word_size == 1) {
        std::vector<unsigned char> v = a.as_vec<unsigned char>();
        result = [NSMutableArray arrayWithCapacity: v.size()];
        for (size_t i = 0; i < v.size(); ++i) {
            [result addObject:[NSNumber numberWithUnsignedChar: v[i]]];
        }
    } else if (a.word_size == 2) {
        std::vector<unsigned short> v = a.as_vec<unsigned short>();
        result = [NSMutableArray arrayWithCapacity: v.size()];
        for (size_t i = 0; i < v.size(); ++i) {
            [result addObject:[NSNumber numberWithUnsignedShort: v[i]]]; // TODO: Changed this from char to short and did not test
        }
    } else if (a.word_size == 4) {
        std::vector<float> v = a.as_vec<float>();
        result = [NSMutableArray arrayWithCapacity: v.size()];
        for (size_t i = 0; i < v.size(); ++i) {
            [result addObject:[NSNumber numberWithFloat: v[i]]];
        }
    } else if (a.word_size == 8) {
        std::vector<double> v = a.as_vec<double>();
        result = [NSMutableArray arrayWithCapacity: v.size()];
        for (size_t i = 0; i < v.size(); ++i) {
            [result addObject:[NSNumber numberWithDouble: v[i]]];
        }
    } else {
        throw "Tried to load NumPy array with unsupported word size.";
    }

    return result;
}

@end
