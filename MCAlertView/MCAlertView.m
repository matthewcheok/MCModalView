//
//  MCAlertView.m
//  MCAdditions
//
//  Created by Matthew Cheok on 22/5/13.
//  Copyright (c) 2013 Matthew Cheok. All rights reserved.
//

#import "MCAlertView.h"
#import "MCTransparentWindow.h"

static CGFloat const kMCAlertViewAlertWidth = 300;
static CGFloat const kMCAlertViewAlertPadding = 20;
static CGFloat const kMCAlertViewCornerRadius = 3;
static CGFloat const kMCAlertViewTitleFontSize = 20;
static CGFloat const kMCAlertViewMessageFontSize = 16;
static CGFloat const kMCAlertViewButtonFontSize = 16;
static CGFloat const kMCAlertViewButtonHeight = 30;
static CGFloat const kMCAlertViewAngleRange = 15;
static CGFloat const kMCAlertViewMotionOffset = 15;

@interface MCAlertViewController : NSObject

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) MCAlertView *currentAlertView;

@property (nonatomic, strong) NSMutableArray *queue;

+ (instancetype)sharedInstance;
- (void)queueAlertView:(MCAlertView *)alertView;
- (void)presentAlertView;
- (void)dismissAlertView;

@end

@implementation MCAlertViewController

+ (instancetype)sharedInstance {
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
	    _sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_window = [MCTransparentWindow windowWithLevel:UIWindowLevelAlert];
		_window.hidden = YES;

		_backgroundView = [[UIView alloc] initWithFrame:_window.bounds];
		_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		_backgroundView.alpha = 0;
		_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[_window addSubview:_backgroundView];

		_queue = [NSMutableArray array];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerAlertView) name:MCTransparentWindowIsAnimatingBoundsChangeNotification object:nil];

		srand48(time(0));
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MCTransparentWindowIsAnimatingBoundsChangeNotification object:nil];
}

- (void)queueAlertView:(MCAlertView *)alertView {
	[self.queue addObject:alertView];
	[self presentAlertView];
}

- (void)centerAlertView {
	CGRect bounds = self.window.bounds;
	self.currentAlertView.center = CGPointMake(floorf(CGRectGetWidth(bounds) / 2.f), floorf(CGRectGetHeight(bounds) / 2.f));
}

- (void)presentAlertView {
	if (self.currentAlertView || [self.queue count] < 1) {
		return;
	}

	MCAlertView *alertView = [self.queue firstObject];
	[self.queue removeObjectAtIndex:0];

	self.currentAlertView = alertView;
	self.window.hidden = NO;

	__weak typeof(self) weakSelf = self;

	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.backgroundView.alpha = 1.0;
	} completion:nil];

	[alertView sizeToFit];
	[alertView layoutIfNeeded];

	[self.window addSubview:alertView];

	CGRect bounds = self.window.bounds;
	CGFloat centerY = alertView.actionButton ? CGRectGetMidY(alertView.actionButton.frame) : CGRectGetMidY(alertView.cancelButton.frame);

	alertView.center = CGPointMake(floorf(CGRectGetWidth(bounds) / 2.f), -floorf(CGRectGetHeight(alertView.frame) / 2.f));
    alertView.actionButton.center = CGPointMake(CGRectGetMidX(alertView.actionButton.frame), centerY-50);
    alertView.cancelButton.center = CGPointMake(CGRectGetMidX(alertView.cancelButton.frame), centerY-50);
	alertView.transform = CGAffineTransformMakeScale(1.0, 1.4);
	alertView.layer.anchorPoint = CGPointMake(0.5, 1);

	[UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
	    alertView.center = CGPointMake(floorf(CGRectGetWidth(bounds) / 2.f), floorf(CGRectGetHeight(bounds) / 2.f) + CGRectGetHeight(alertView.bounds) / 2);
	} completion: ^(BOOL finished) {
	}];

	[UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
	    alertView.transform = CGAffineTransformIdentity;
	    alertView.actionButton.center = CGPointMake(CGRectGetMidX(alertView.actionButton.frame), centerY);
	    alertView.cancelButton.center = CGPointMake(CGRectGetMidX(alertView.cancelButton.frame), centerY);
	} completion: ^(BOOL finished) {
	}];
}

- (void)dismissAlertView {
	if (!self.currentAlertView) {
		return;
	}

	__weak typeof(self) weakSelf = self;

	if ([self.queue count] < 1) {
		[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
		    typeof(self) strongSelf = weakSelf;
		    strongSelf.backgroundView.alpha = 0;
		} completion: ^(BOOL finished) {
		    typeof(self) strongSelf = weakSelf;
		    [strongSelf.window setHidden:YES];
		}];
	}

	MCAlertView *alertView = self.currentAlertView;

	CGRect bounds = self.window.bounds;
	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations: ^{
	    alertView.center = CGPointMake(floorf(CGRectGetWidth(bounds) / 2.f), CGRectGetHeight(bounds) + floorf(1.5*CGRectGetHeight(alertView.frame)));

	    CGFloat angle = floorf(drand48() * kMCAlertViewAngleRange * 2) - kMCAlertViewAngleRange;
	    alertView.transform = CGAffineTransformMakeRotation(angle / 180 * M_PI);
	} completion: ^(BOOL finished) {
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.currentAlertView = nil;
	    [strongSelf presentAlertView];

	    [alertView removeFromSuperview];
	}];
}

@end


@interface MCAlertView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) MCRoundedButton *cancelButton;
@property (strong, nonatomic) MCRoundedButton *actionButton;

@end

@implementation MCAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionButtonTitle:(NSString *)actionButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(void (^)(BOOL cancelled))completion {
	self = [super initWithFrame:CGRectZero];
	if (self) {
		NSAssert(title || message, @"At least title or message is required.");
		NSAssert(actionButtonTitle || cancelButtonTitle, @"At least action button or cancel button is required.");

		self.completionHandler = completion;
		self.tintColor =  [UIColor colorWithWhite:0.133 alpha:1];
		self.layer.cornerRadius = kMCAlertViewCornerRadius;
		self.layer.masksToBounds = YES;

		_contentView = [[UIToolbar alloc] initWithFrame:CGRectZero];
		[self addSubview:_contentView];

		if (title) {
			_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			_titleLabel.backgroundColor = [UIColor clearColor];
			_titleLabel.font = [UIFont boldSystemFontOfSize:kMCAlertViewTitleFontSize];
			_titleLabel.text = title;
			_titleLabel.textAlignment = NSTextAlignmentCenter;
			[_contentView addSubview:_titleLabel];
		}

		if (message) {
			_messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			_messageLabel.backgroundColor = [UIColor clearColor];
			_messageLabel.font = [UIFont systemFontOfSize:kMCAlertViewMessageFontSize];
			_messageLabel.text = message;
			_messageLabel.textAlignment = NSTextAlignmentCenter;

			_messageLabel.numberOfLines = 0;
			[_contentView addSubview:_messageLabel];
		}

		if (actionButtonTitle) {
			_actionButton = [[MCRoundedButton alloc] initWithFrame:CGRectZero];
			_actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:kMCAlertViewButtonFontSize];
			[_actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
			[_actionButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
			[_contentView addSubview:_actionButton];
		}

		if (cancelButtonTitle) {
			_cancelButton = [[MCRoundedButton alloc] initWithFrame:CGRectZero];
			_cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:kMCAlertViewButtonFontSize];
			[_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
			[_cancelButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
			[_contentView addSubview:_cancelButton];
		}

		UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		horizontalEffect.minimumRelativeValue = @(-kMCAlertViewMotionOffset);
		horizontalEffect.maximumRelativeValue = @(kMCAlertViewMotionOffset);
		[self addMotionEffect:horizontalEffect];

		UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		verticalEffect.minimumRelativeValue = @(-kMCAlertViewMotionOffset);
		verticalEffect.maximumRelativeValue = @(kMCAlertViewMotionOffset);
		[self addMotionEffect:verticalEffect];

		[self setNeedsLayout];
		[self tintColorDidChange];
	}
	return self;
}

+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message actionButtonTitle:(NSString *)actionButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(void (^)(BOOL cancelled))completion {
	return [[[self class] alloc] initWithTitle:title message:message actionButtonTitle:actionButtonTitle cancelButtonTitle:cancelButtonTitle completionHandler:completion];
}

- (void)tintColorDidChange {
	UIColor *darkColor = self.tintColor ? : [UIColor colorWithWhite:0.133 alpha:1];
	UIColor *lightColor = [UIColor colorWithWhite:0.86 alpha:1];

	self.titleLabel.textColor = darkColor;
	self.messageLabel.textColor = darkColor;
	self.actionButton.tintColor = darkColor;
	self.actionButton.selectedTitleColor = lightColor;
	self.cancelButton.tintColor = darkColor;
	self.cancelButton.selectedTitleColor = lightColor;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGSize contentSize = CGSizeMake(kMCAlertViewAlertWidth, kMCAlertViewAlertPadding);
	CGFloat contentWidth = kMCAlertViewAlertWidth - 2 * kMCAlertViewAlertPadding;

	if (self.titleLabel) {
		CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		self.titleLabel.frame = CGRectMake(kMCAlertViewAlertPadding, contentSize.height, contentWidth, titleSize.height);
		contentSize.height += titleSize.height + kMCAlertViewAlertPadding;
	}

	if (self.messageLabel) {
		CGSize messageSize = [self.messageLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		self.messageLabel.frame = CGRectMake(kMCAlertViewAlertPadding, contentSize.height, contentWidth, messageSize.height);
		contentSize.height += messageSize.height + kMCAlertViewAlertPadding;
	}

	if (self.actionButton && !self.cancelButton) {
		self.actionButton.frame = CGRectMake(kMCAlertViewAlertPadding, contentSize.height, contentWidth, kMCAlertViewButtonHeight);
	}
	else if (self.cancelButton && !self.actionButton) {
		self.cancelButton.frame = CGRectMake(kMCAlertViewAlertPadding, contentSize.height, contentWidth, kMCAlertViewButtonHeight);
	}
	else if (self.cancelButton && self.actionButton) {
		CGFloat buttonWidth = (contentWidth - kMCAlertViewAlertPadding) / 2;
		self.cancelButton.frame = CGRectMake(kMCAlertViewAlertPadding, contentSize.height, buttonWidth, kMCAlertViewButtonHeight);
		self.actionButton.frame = CGRectMake(2 * kMCAlertViewAlertPadding + buttonWidth, contentSize.height, buttonWidth, kMCAlertViewButtonHeight);
	}
	contentSize.height += kMCAlertViewButtonHeight + kMCAlertViewAlertPadding;

	self.contentView.frame = (CGRect) {.size = contentSize };
}

- (CGSize)intrinsicContentSize {
	CGSize contentSize = CGSizeMake(kMCAlertViewAlertWidth, kMCAlertViewAlertPadding);
	CGFloat contentWidth = kMCAlertViewAlertWidth - 2 * kMCAlertViewAlertPadding;
	if (self.titleLabel) {
		CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		contentSize.height += titleSize.height + kMCAlertViewAlertPadding;
	}

	if (self.messageLabel) {
		CGSize messageSize = [self.messageLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		contentSize.height += messageSize.height + kMCAlertViewAlertPadding;
	}

	contentSize.height += kMCAlertViewButtonHeight + kMCAlertViewAlertPadding;
	return contentSize;
}

- (void)sizeToFit {
	self.frame = (CGRect) {.size = [self intrinsicContentSize] };
}

#pragma mark - Methods

- (void)show {
	[[MCAlertViewController sharedInstance] queueAlertView:self];
}

- (void)dismiss {
	[[MCAlertViewController sharedInstance] dismissAlertView];
}

- (void)buttonPress:(id)sender {
	[self dismiss];
	if (self.completionHandler) {
		self.completionHandler(sender == self.cancelButton);
	}
}

@end
