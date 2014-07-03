//
//  MCAlertController.m
//  Pods
//
//  Created by Matthew Cheok on 2/7/14.
//
//

#import "MCModalController.h"
#import "MCTransparentWindow.h"

@implementation MCModalController

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

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerActiveView) name:MCTransparentWindowIsAnimatingBoundsChangeNotification object:nil];

		srand48(time(0));
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MCTransparentWindowIsAnimatingBoundsChangeNotification object:nil];
}

- (void)queueModalView:(UIView *)view {
	[self.queue addObject:view];
	[self presentNextView];
}

- (void)centerActiveView {
	CGRect bounds = self.window.bounds;
	self.activeView.center = CGPointMake(floorf(CGRectGetWidth(bounds) / 2.f), floorf(CGRectGetHeight(bounds) / 2.f));
}

- (void)presentNextView {
	if (self.activeView || [self.queue count] < 1) {
		return;
	}

	MCModalView *activeView = [self.queue firstObject];
	[self.queue removeObjectAtIndex:0];

	self.activeView = activeView;
	self.window.hidden = NO;

	__weak typeof(self) weakSelf = self;

	[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.backgroundView.alpha = 1.0;
	} completion:nil];

	[activeView sizeToFit];
	[activeView layoutIfNeeded];

	[self.window addSubview:activeView];
	[activeView animatePresentationInWindow:self.window completionHandler:nil];
}

- (void)dismissActiveView {
	if (!self.activeView) {
		return;
	}

	__weak typeof(self) weakSelf = self;

	if ([self.queue count] < 1) {
		[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
		    typeof(self) strongSelf = weakSelf;
		    strongSelf.backgroundView.alpha = 0;
		} completion: ^(BOOL finished) {
		    typeof(self) strongSelf = weakSelf;
		    if (!strongSelf.activeView && [strongSelf.queue count] < 1) {
		        [strongSelf.window setHidden:YES];
			}
		}];
	}

	MCModalView *activeView = self.activeView;
	[activeView animateDismissalInWindow:self.window completionHandler: ^{
	    typeof(self) strongSelf = weakSelf;
	    strongSelf.activeView = nil;
	    [strongSelf presentNextView];
	}];
}

@end
