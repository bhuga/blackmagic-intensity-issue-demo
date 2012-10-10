//
//  RecordingDelegate.m
//  blackmagic audio sync issue demonstration
//
//  Created by Ben Lavender on 10/10/12.
//  Copyright (c) 2012 Ben Lavender. All rights reserved.
//

#import "RecordingDelegate.h"

@implementation RecordingDelegate


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"done recording, error: %@", error);
}
@end
