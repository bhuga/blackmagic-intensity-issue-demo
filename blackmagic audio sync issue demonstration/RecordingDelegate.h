//
//  RecordingDelegate.h
//  blackmagic audio sync issue demonstration
//
//  Created by Ben Lavender on 10/10/12.
//  Copyright (c) 2012 Ben Lavender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVCaptureOutput.h>

@interface RecordingDelegate : NSObject <AVCaptureFileOutputRecordingDelegate> {

}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;
@end
