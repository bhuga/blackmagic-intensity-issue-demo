//
//  main.m
//  blackmagic audio sync issue demonstration
//
//  Created by Ben Lavender on 10/10/12.
//  Copyright (c) 2012 Ben Lavender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreMedia/CMFormatDescription.h>
#import "RecordingDelegate.h"
#include <Carbon/Carbon.h>

int done = false;

void setFormatByName(AVCaptureDeviceInput *video, NSString *name) {
    AVCaptureDevice *device = [video device];
    [device lockForConfiguration:nil];
    for (AVCaptureDeviceFormat *capFormat in [device formats]) {
        CFPropertyListRef formatName = CMFormatDescriptionGetExtension([capFormat formatDescription], kCMFormatDescriptionExtension_FormatName);
        if ([(__bridge NSString*)(formatName) isEqualToString:(name)]) {
            [device setActiveFormat:capFormat];
            NSLog(@"set format: %@", formatName);
        }
    }
    [device unlockForConfiguration];
    
}

NSString *formatFrameRate(AVFrameRateRange *range) {
    NSString *formatted = [NSString stringWithFormat:@"%0.2f", [range minFrameRate]];
    if ([[formatted substringFromIndex:[formatted length] - 2] isEqualToString:@"00"]) {
        return [NSString stringWithFormat:@"%0.0f FPS", [range minFrameRate]];
    } else {
        return [NSString stringWithFormat:@"%1.2f FPS", [range minFrameRate]];
    }
}

void setFrameRateByName(AVCaptureDeviceInput *video, NSString *name) {
    AVCaptureDevice *capDevice = [video device];
    AVCaptureDeviceFormat *selectedFormat = [capDevice activeFormat];
    
    for (AVFrameRateRange *rateRange in [selectedFormat videoSupportedFrameRateRanges]) {
        NSString *option = formatFrameRate(rateRange);
        if ([option isEqualToString:name]){
            [capDevice lockForConfiguration:nil];
            [capDevice setActiveVideoMinFrameDuration:[rateRange minFrameDuration]];
            [capDevice unlockForConfiguration];
            NSLog(@"set frame rate: %@", formatFrameRate(rateRange));
            return;
        }
    }
}

AVCaptureDeviceInput* getDeviceInputByName(NSString *name) {
    NSArray *devices = [AVCaptureDevice devices];
    NSError *error = nil;
    
    for (AVCaptureDevice *capDevice in devices) {
        NSString *deviceName = capDevice.localizedName;
        NSLog(@"Device: %@", deviceName);
        if([name isEqualToString:deviceName]) {
            return [[AVCaptureDeviceInput alloc] initWithDevice:capDevice error:&error];
        }
    }
    return nil;
}

void sigint(int signal) {
    NSLog(@"exiting...");
    done = true;
}

int main(int argc, const char * argv[])
{
    signal(SIGINT, sigint);
    signal(SIGKILL, sigint);
    
    @autoreleasepool {
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
        [session addOutput:output];

        NSString *videoDevice = @"Blackmagic";
        if (argc > 1) {
            videoDevice = [[NSString alloc] initWithCString:argv[1] encoding:NSUTF8StringEncoding];
        }
        
        NSString *audioDevice = @"Blackmagic Audio";
        if (argc > 2) {
            audioDevice = [[NSString alloc] initWithCString:argv[2] encoding:NSUTF8StringEncoding];
        }
        NSLog(@"using %@ for video", videoDevice);
        NSLog(@"using %@ for audio", audioDevice);
        AVCaptureDeviceInput *video = getDeviceInputByName(videoDevice);
        AVCaptureDeviceInput *audio = getDeviceInputByName(audioDevice);
        [session addInput:video];
        [session addInput:audio];

        [session startRunning];

        NSString *format = @"720p - Uncompressed 8-bit 4:2:2";
        if (argc > 3) {
            format = [[NSString alloc] initWithCString:argv[3] encoding:NSUTF8StringEncoding];
        }
        
        NSString *fps = @"59.94 FPS";
        if (argc > 4) {
            fps = [[NSString alloc] initWithCString:argv[4] encoding:NSUTF8StringEncoding];
        }
        NSLog(@"using %@ for format", format);
        NSLog(@"using %@ for fps", fps);
        setFormatByName(video, format);
        setFrameRateByName(video, fps);
        
        NSString *file = [@"~/Movies/output.mov" stringByExpandingTildeInPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        [fileManager removeItemAtPath:file error:&error];
        
        RecordingDelegate *del = [RecordingDelegate alloc];
        [output startRecordingToOutputFileURL:[NSURL fileURLWithPath:file] recordingDelegate:del];
        
        NSLog(@"capturing to %@, ctrl-c to finish.", file);
       
        while (!done)
            sleep(1);
        NSLog(@"closing session");
        
        [session stopRunning];
        [output stopRecording];
        // let the recording delegate finish. could take longer but this is just a test
        sleep(1);
    }
    return 0;
}

