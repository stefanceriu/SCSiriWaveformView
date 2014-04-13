//
//  SCViewController.m
//  SCSiriWaveformView
//
//  Created by Stefan Ceriu on 13/04/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "SCSiriWaveformView.h"

@interface SCViewController ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, weak) IBOutlet SCSiriWaveformView *waveformView;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
	NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
	NSError *error;
	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    
    [self.waveformView setWaveColor:[UIColor whiteColor]];
    [self.waveformView setPrimaryWaveLineWidth:3.0f];
    [self.waveformView setSecondaryWaveLineWidth:1.0];
}


- (void)updateMeters
{
	[self.recorder updateMeters];
    
    CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 20);
    
    [self.waveformView updateWithLevel:normalizedValue];
}

@end
