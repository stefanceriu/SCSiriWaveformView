//
//  SCSiriWaveformView.h
//  SCSiriWaveformView
//
//  Created by Stefan Ceriu on 12/04/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

IB_DESIGNABLE
@interface SCSiriWaveformView : UIView

/*
 * Tells the waveform to redraw itself using the given level (normalized value)
 */
- (void)updateWithLevel:(CGFloat)level;

/*
 * The total number of waves
 * Default: 5
 */
@property (nonatomic, assign) NSUInteger numberOfWaves IBInspectable;

/*
 * Color to use when drawing the waves
 * Default: white
 */
@property (nonatomic, strong) UIColor *waveColor IBInspectable;

/*
 * Line width used for the proeminent wave
 * Default: 3.0f
 */
@property (nonatomic, assign) CGFloat primaryWaveLineWidth IBInspectable;

/*
 * Line width used for all secondary waves
 * Default: 1.0f
 */
@property (nonatomic, assign) CGFloat secondaryWaveLineWidth IBInspectable;

/*
 * The amplitude that is used when the incoming amplitude is near zero.
 * Setting a value greater 0 provides a more vivid visualization.
 * Default: 0.01
 */
@property (nonatomic, assign) CGFloat idleAmplitude IBInspectable;

/*
 * The frequency of the sinus wave. The higher the value, the more sinus wave peaks you will have.
 * Default: 1.5
 */
@property (nonatomic, assign) CGFloat frequency IBInspectable;

/*
 * The current amplitude
 */
@property (nonatomic, assign, readonly) CGFloat amplitude IBInspectable;

/*
 * The lines are joined stepwise, the more dense you draw, the more CPU power is used.
 * Default: 5
 */
@property (nonatomic, assign) CGFloat density IBInspectable;

/*
 * The phase shift that will be applied with each level setting
 * Change this to modify the animation speed or direction
 * Default: -0.15
 */
@property (nonatomic, assign) CGFloat phaseShift IBInspectable;

@end
