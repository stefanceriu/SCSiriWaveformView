//
//  SCSiriWaveformView.m
//  SCSiriWaveformView
//
//  Created by Stefan Ceriu on 12/04/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCSiriWaveformView.h"

#define DEFAULT_FREQUENCY					1.5f
#define DEFAULT_AMPLITUDE					1.f
#define DEFAULT_IDLE_AMPLITUDE				0.01f
#define DEFAULT_NUMBER_OF_WAVES				5
#define DEFAULT_PHASE_SHIFT					-0.15f
#define DEFAULT_DENSITY						5.f
#define DEFAULT_WAVE_COLOR					UIColor.whiteColor
#define DEFAULT_PRIMARY_WAVE_LINE_WIDTH		3.f
#define DEFAULT_SECONDARY_WAVE_LINE_WIDTH	1.f

@interface SCSiriWaveformView ()

@property (nonatomic, assign) CGFloat phase;
@property (nonatomic, assign) CGFloat amplitude;

@end

@implementation SCSiriWaveformView

- (instancetype)init
{
    if(self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.frequency = DEFAULT_FREQUENCY;
    
    self.amplitude = DEFAULT_AMPLITUDE;
    self.idleAmplitude = DEFAULT_IDLE_AMPLITUDE;
    
    self.numberOfWaves = DEFAULT_NUMBER_OF_WAVES;
    self.phaseShift = DEFAULT_PHASE_SHIFT;
    self.density = DEFAULT_DENSITY;
    
    self.waveColor = DEFAULT_WAVE_COLOR;
    self.primaryWaveLineWidth = DEFAULT_PRIMARY_WAVE_LINE_WIDTH;
    self.secondaryWaveLineWidth = DEFAULT_SECONDARY_WAVE_LINE_WIDTH;
}

- (void)updateWithLevel:(CGFloat)level
{
    self.phase += self.phaseShift;
    self.amplitude = fmax(level, self.idleAmplitude);
    
    [self setNeedsDisplay];
}

// Thanks to Raffael Hannemann https://github.com/raffael/SISinusWaveView
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    [self.backgroundColor set];
    CGContextFillRect(context, rect);
    
    // We draw multiple sinus waves, with equal phases but altered amplitudes, multiplied by a parable function.
    for (int i = 0; i < self.numberOfWaves; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, (i == 0 ? self.primaryWaveLineWidth : self.secondaryWaveLineWidth));
        
        CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat mid = width / 2.0f;
        
        const CGFloat maxAmplitude = halfHeight - 4.0f; // 4 corresponds to twice the stroke width
        
        // Progress is a value between 1.0 and -0.5, determined by the current wave idx, which is used to alter the wave's amplitude.
        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
        CGFloat normedAmplitude = (1.5f * progress - 0.5f) * self.amplitude;
        
        CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
        [[self.waveColor colorWithAlphaComponent:multiplier * CGColorGetAlpha(self.waveColor.CGColor)] set];
        
        for (CGFloat x = 0; x<width + self.density; x += self.density) {
            // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
            CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
                        
            CGFloat y = scaling * maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
            
            if (x == 0) {
                CGContextMoveToPoint(context, x, y);
            } else {
                CGContextAddLineToPoint(context, x, y);
            }
        }
        
        CGContextStrokePath(context);
    }
}

@end
