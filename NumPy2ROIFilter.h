//
//  NumPy2ROIFilter.h
//  NumPy2ROI
//
//  Copyright (c) 2018 Christopher Chute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

#import "NumPyLoader.h"

@interface NumPy2ROIFilter : PluginFilter
{

    IBOutlet NSWindow *window;
    IBOutlet NSTextField *roiName;         // Name for ROI
    IBOutlet NSTextField *thresholdValue;  // Voxel v is in ROI if v > thresholdValue

}

@property NSString *npyURL;

- (long) filterImage:(NSString*) menuName;
- (void) CreateBrushROI:(id) sender;

@end
