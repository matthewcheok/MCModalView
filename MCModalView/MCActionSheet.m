//
//  MCActionSheet.m
//  Pods
//
//  Created by Matthew Cheok on 2/7/14.
//
//

#import "MCActionSheet.h"
#import "MCModalController.h"

static CGFloat const kMCActionSheetWidth = 300;
static CGFloat const kMCActionSheetPadding = 20;
static CGFloat const kMCActionSheetRadius = 3;
static CGFloat const kMCActionSheetTitleFontSize = 16;
static CGFloat const kMCActionSheetMessageFontSize = 13;
static CGFloat const kMCActionSheetButtonFontSize = 16;
static CGFloat const kMCActionSheetButtonHeight = 30;
static CGFloat const kMCActionSheetAngleRange = 15;
static CGFloat const kMCActionSheetMotionOffset = 15;

@interface MCActionSheet ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) MCRoundedButton *cancelButton;
@property (strong, nonatomic) NSArray *actionButtons;

@end

@implementation MCActionSheet

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actionButtonTitles:(NSArray *)actionButtonTitles completionHandler:(void (^)(BOOL, NSUInteger))completion {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.completionHandler = completion;
		self.tintColor =  [UIColor colorWithWhite:0.133 alpha:1];
		self.layer.cornerRadius = kMCActionSheetRadius;
		self.layer.masksToBounds = YES;
        
		_contentView = [[UIToolbar alloc] initWithFrame:CGRectZero];
		[self addSubview:_contentView];
        
		if (title) {
			_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			_titleLabel.backgroundColor = [UIColor clearColor];
			_titleLabel.font = [UIFont boldSystemFontOfSize:kMCActionSheetTitleFontSize];
			_titleLabel.text = title;
			_titleLabel.textAlignment = NSTextAlignmentCenter;
			[_contentView addSubview:_titleLabel];
		}
        
		if (message) {
			_messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			_messageLabel.backgroundColor = [UIColor clearColor];
			_messageLabel.font = [UIFont systemFontOfSize:kMCActionSheetMessageFontSize];
			_messageLabel.text = message;
			_messageLabel.textAlignment = NSTextAlignmentCenter;
            
			_messageLabel.numberOfLines = 0;
			[_contentView addSubview:_messageLabel];
		}
        
		if (cancelButtonTitle) {
			_cancelButton = [[MCRoundedButton alloc] initWithFrame:CGRectZero];
			_cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:kMCActionSheetButtonFontSize];
			[_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
			[_cancelButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
			[_contentView addSubview:_cancelButton];
		}
        
        NSMutableArray *actionButtons = [NSMutableArray array];
        for (NSString *buttonTitle in actionButtonTitles) {
            MCRoundedButton *actionButton = [[MCRoundedButton alloc] initWithFrame:CGRectZero];
			actionButton.titleLabel.font = [UIFont systemFontOfSize:kMCActionSheetButtonFontSize];
			[actionButton setTitle:buttonTitle forState:UIControlStateNormal];
			[actionButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
			[_contentView addSubview:actionButton];
            [actionButtons addObject:actionButton];
        }
        self.actionButtons = [actionButtons copy];
        
        UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		horizontalEffect.minimumRelativeValue = @(-kMCActionSheetMotionOffset);
		horizontalEffect.maximumRelativeValue = @(kMCActionSheetMotionOffset);
		[self addMotionEffect:horizontalEffect];
        
		UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		verticalEffect.minimumRelativeValue = @(-kMCActionSheetMotionOffset);
		verticalEffect.maximumRelativeValue = @(kMCActionSheetMotionOffset);
		[self addMotionEffect:verticalEffect];
        
		[self setNeedsLayout];
		[self tintColorDidChange];
    }
    
    return self;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actionButtonTitles:(NSArray *)actionButtonTitles completionHandler:(void (^)(BOOL, NSUInteger))completion {
    return [[self alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle actionButtonTitles:actionButtonTitles completionHandler:completion];
}

#pragma mark - UIView

- (void)tintColorDidChange {
	UIColor *darkColor = self.tintColor ? : [UIColor colorWithWhite:0.133 alpha:1];
	UIColor *lightColor = [UIColor colorWithWhite:0.86 alpha:1];
    
	self.titleLabel.textColor = darkColor;
	self.messageLabel.textColor = darkColor;
	self.cancelButton.tintColor = darkColor;
	self.cancelButton.selectedTitleColor = lightColor;
    
    for (MCRoundedButton *actionButton in self.actionButtons) {
        actionButton.tintColor = darkColor;
        actionButton.selectedTitleColor = lightColor;
    }
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
	CGSize contentSize = CGSizeMake(kMCActionSheetWidth, kMCActionSheetPadding);
	CGFloat contentWidth = kMCActionSheetWidth - 2 * kMCActionSheetPadding;
    
	if (self.titleLabel) {
		CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		self.titleLabel.frame = CGRectMake(kMCActionSheetPadding, contentSize.height, contentWidth, titleSize.height);
		contentSize.height += titleSize.height + kMCActionSheetPadding/2.0;
	}
    
	if (self.messageLabel) {
		CGSize messageSize = [self.messageLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		self.messageLabel.frame = CGRectMake(kMCActionSheetPadding, contentSize.height, contentWidth, messageSize.height);
		contentSize.height += messageSize.height + kMCActionSheetPadding/2.0;
	}
    
    for (MCRoundedButton *actionButton in self.actionButtons) {
		actionButton.frame = CGRectMake(kMCActionSheetPadding, contentSize.height, contentWidth, kMCActionSheetButtonHeight);
        contentSize.height += kMCActionSheetButtonHeight + kMCActionSheetPadding/2.0;
    }
    
    if (self.cancelButton) {
        if ([self.actionButtons count] > 0) {
            contentSize.height += kMCActionSheetPadding/2.0;
        }
        
		self.cancelButton.frame = CGRectMake(kMCActionSheetPadding, contentSize.height, contentWidth, kMCActionSheetButtonHeight);
        contentSize.height += kMCActionSheetButtonHeight + kMCActionSheetPadding;
	}
    
	self.contentView.frame = (CGRect) {.size = contentSize };
}

- (CGSize)intrinsicContentSize {
	CGSize contentSize = CGSizeMake(kMCActionSheetWidth, kMCActionSheetPadding);
	CGFloat contentWidth = kMCActionSheetWidth - 2 * kMCActionSheetPadding;
	if (self.titleLabel) {
		CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		contentSize.height += titleSize.height + kMCActionSheetPadding/2.0;
	}
    
	if (self.messageLabel) {
		CGSize messageSize = [self.messageLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
		contentSize.height += messageSize.height + kMCActionSheetPadding/2.0;
	}
    
    contentSize.height += (kMCActionSheetButtonHeight + kMCActionSheetPadding/2.0) * [self.actionButtons count];

    if (self.cancelButton) {
        if ([self.actionButtons count] > 0) {
            contentSize.height += kMCActionSheetPadding/2.0;
        }

        contentSize.height += kMCActionSheetButtonHeight + kMCActionSheetPadding;
    }
    
	return contentSize;
}

- (void)sizeToFit {
	self.frame = (CGRect) {.size = [self intrinsicContentSize] };
}

#pragma mark - Methods

- (void)show {
	[[MCModalController sharedInstance] queueModalView:self];
}

- (void)dismiss {
	[[MCModalController sharedInstance] dismissActiveView];
}

- (void)buttonPress:(id)sender {
	[self dismiss];
	if (self.completionHandler) {
		self.completionHandler(sender == self.cancelButton, [self.actionButtons indexOfObject:sender]);
	}
}

- (void)animatePresentationInWindow:(UIWindow *)window completionHandler:(void (^)())completion {
	CGRect bounds = window.bounds;
    
    CGFloat centerX = floorf(CGRectGetWidth(bounds) / 2.0);
    CGFloat centerModalX = floorf(CGRectGetWidth(self.frame)/2.0);
    CGFloat centerModalY = floorf(CGRectGetHeight(self.frame)/2.0);
    
	self.transform = CGAffineTransformMakeScale(1.0, 1.4);
	self.center = CGPointMake(centerX, CGRectGetHeight(bounds) + floorf(CGRectGetHeight(self.frame) / 2.0));
	self.cancelButton.center = CGPointMake(centerModalX, CGRectGetMidY(self.cancelButton.frame) + 50);
    for (MCRoundedButton *actionButton in self.actionButtons) {
        actionButton.center = CGPointMake(centerModalX, CGRectGetMidY(actionButton.frame) + 50);
    }
    
	__weak typeof(self) weakSelf = self;
    
	[UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.center = CGPointMake(centerX, CGRectGetHeight(bounds) - centerModalY - 10);
	} completion: ^(BOOL finished) {
	}];
    
	[UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.transform = CGAffineTransformIdentity;
	    strongSelf.cancelButton.center = CGPointMake(centerModalX, CGRectGetMidY(self.cancelButton.frame) - 50);
        for (MCRoundedButton *actionButton in strongSelf.actionButtons) {
            actionButton.center = CGPointMake(centerModalX, CGRectGetMidY(actionButton.frame) - 50);
        }
	} completion: ^(BOOL finished) {
	    if (completion) {
	        completion();
		}
	}];
}

- (void)animateDismissalInWindow:(UIWindow *)window completionHandler:(void (^)())completion {
	CGRect bounds = window.bounds;
    
	__weak typeof(self) weakSelf = self;
    
	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.center = CGPointMake(floorf(CGRectGetWidth(bounds) / 2.f), CGRectGetHeight(bounds) + floorf(1.5 * CGRectGetHeight(strongSelf.frame)));
        
	    CGFloat angle = floorf(drand48() * kMCActionSheetAngleRange * 2) - kMCActionSheetAngleRange;
	    strongSelf.transform = CGAffineTransformMakeRotation(angle / 180 * M_PI);
	} completion: ^(BOOL finished) {
	    typeof(self) strongSelf = weakSelf;
	    [strongSelf removeFromSuperview];
        
	    if (completion) {
	        completion();
		}
	}];
}

@end
