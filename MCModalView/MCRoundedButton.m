//
//  MCBorderedButton.m
//  MCAdditions
//
//  Created by Matthew Cheok on 6/2/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import "MCRoundedButton.h"

static CGFloat const kMCRoundedButtonInset = 2;

@interface MCRoundedButton ()

@property (strong, nonatomic) CAShapeLayer *borderLayer;
@property (strong, nonatomic) CAShapeLayer *fillLayer;

@end

@implementation MCRoundedButton

- (void)setup {
	_borderLayer = [CAShapeLayer layer];
	_borderLayer.lineWidth = kMCRoundedButtonInset;
	_borderLayer.strokeColor = [UIColor blackColor].CGColor;
	_borderLayer.fillColor = nil;
	_borderLayer.actions = @{ @"strokeColor": [NSNull null] };
	[self.layer addSublayer:_borderLayer];

    _fillLayer = [CAShapeLayer layer];
    _fillLayer.fillColor = nil;
	_borderLayer.actions = @{ @"fillColor": [NSNull null] };
    [self.layer insertSublayer:_fillLayer atIndex:0];

	self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectedTitleColor = [UIColor whiteColor];

    [self tintColorDidChange];
}


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

    CGRect bounds = self.bounds;
    CGFloat radius = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds))/2;

	self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius].CGPath;
    self.fillLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bounds, kMCRoundedButtonInset, kMCRoundedButtonInset) cornerRadius:radius-kMCRoundedButtonInset].CGPath;
}

#pragma mark - Methods

- (void)updateState {
    self.borderLayer.strokeColor = self.tintColor.CGColor;
    self.fillLayer.fillColor = [self isHighlighted] ? self.tintColor.CGColor : nil;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self updateState];

    [self setTitleColor:self.tintColor forState:UIControlStateNormal];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateState];
}

#pragma mark - Properties

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;

    [self setTitleColor:selectedTitleColor forState:UIControlStateHighlighted];
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    self.userInteractionEnabled = !animating;

    if (!animating && [self.borderLayer animationForKey:@"linePhase"]) {
        [self.borderLayer removeAnimationForKey:@"linePhase"];
        self.borderLayer.lineDashPattern = nil;
    }
    else {
        self.borderLayer.lineDashPattern = @[@12, @4];

        CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:@0];
        [dashAnimation setToValue:@(-16)];
        [dashAnimation setDuration:0.5];
        [dashAnimation setRepeatCount:HUGE_VAL];

        [self.borderLayer addAnimation:dashAnimation forKey:@"linePhase"];
    }
}

@end
