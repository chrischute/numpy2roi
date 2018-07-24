//
//  NumPy2ROIFilter.mm
//  NumPy2ROI
//
//  Copyright (c) 2018 Christopher Chute. All rights reserved.
//

#import "OsirixAPI/browserController.h"

#import "NumPy2ROIFilter.h"

@implementation NumPy2ROIFilter

- (void) initPlugin
{
}

- (void) CreateBrushROI:(id) sender
{
    
    [window orderOut:sender];
    [NSApp endSheet:window returnCode:[sender tag]];
    
    if ([sender tag])
    {

        // User clicked OK Button
        NSString *ThresholdROIName = [thresholdROIname stringValue];
        
        int startSlice = 0;
        int endSlice = [[viewerController pixList] count];
        int pixIncrement = endSlice;
        
        // TODO: Dispatch load asynchronously
        assert(self.npyURL != NULL);
        NumPyLoader *loader = [[NumPyLoader alloc]init];
        NSMutableArray *mask = [loader load: self.npyURL];

        for (int i = startSlice; i < endSlice; i++)
        {
            DCMPix *curPix = [[viewerController pixList] objectAtIndex:i];
            int npySliceIdx = endSlice - i - 1;
    
            BOOL isEmptyROI = TRUE;
            
            // Create array with the same size as the current image
            size_t numPixels = [curPix pwidth] * [curPix pheight];
            unsigned char *textureBuffer = (unsigned char *) malloc(numPixels * sizeof(unsigned char));

            // Fill slice with mask values
            for (int j = 0; j < numPixels; ++j)
            {
                if ([[mask objectAtIndex:(npySliceIdx + j * pixIncrement)] floatValue] > 0)
                {
                    textureBuffer[j] = 0xFF;
                    isEmptyROI = FALSE;
                }
                else
                {
                    textureBuffer[j] = 0x00;
                }
            }

            if (!isEmptyROI)
            {
                ROI *thresholdROI = nil;
                
                thresholdROI = [[[ROI alloc] initWithTexture:textureBuffer
                                             textWidth:[curPix pwidth] textHeight:[curPix pheight]
                                             textName:ThresholdROIName positionX:0 positionY:0
                                             spacingX:[curPix pixelSpacingX]
                                             spacingY:[curPix pixelSpacingY]
                                             imageOrigin:NSMakePoint([curPix originX], [curPix originY])]
                                autorelease];
                
                NSMutableArray *roiImageList = [[viewerController roiList] objectAtIndex: i];
                
                [roiImageList addObject: thresholdROI];
                
                // Update viewer
                [viewerController needsDisplayUpdate];
                
            }

            free(textureBuffer);
            
        }
        
    }

}

- (void) SetSignalIntensity
{
    float maxValue = 0;
    float minValue = 0;
    
    for (unsigned int i = 0; i < [[viewerController pixList] count]; i++)
    {
        DCMPix *curPix = [[viewerController pixList] objectAtIndex: i];
        float *fImage = [curPix fImage];
        
        int SumOfPixels = [curPix pwidth] * [curPix pheight];
        
        for (int j = 0; j < SumOfPixels; j++)
        {
            
            if (fImage[j] > maxValue)
            {
                maxValue = fImage[j];
            } else
                if (fImage[j] < minValue)
                {
                    minValue = fImage[j];
                }
            
        }
        
    }

}

- (long) filterImage:(NSString*) menuName
{
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:NO];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:NO];
    
    // Display the dialog. If the OK button was pressed, process the files.
    if (self.npyURL != NULL)
    {
        free(self.npyURL);
        self.npyURL = NULL;
    }
    
    if ( [openDlg runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* urls = [openDlg URLs];
        
        // Loop through all the files and process them.
        for(int i = 0; i < [urls count]; i++ )
        {
            NSString *url = [[urls objectAtIndex:i] path];
            self.npyURL = [[NSString alloc] initWithString: url];
            NSLog(@"Chose Url: %@", self.npyURL);
        }
        assert(self.npyURL != NULL);
    }

    // Allow user to name the ROI.
    [NSBundle loadNibNamed:@"NumPy2ROI_Dialog" owner:self];
    [NSApp beginSheet: window modalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    [self SetSignalIntensity];
    
    return 0;
}


@end
