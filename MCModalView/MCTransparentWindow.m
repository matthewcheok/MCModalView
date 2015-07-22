//
//  MCTransparentWindow.m
//  Pods
//
//  Created by Matthew Cheok on 28/4/14.
//
//

#import "MCTransparentWindow.h"

NSString* const MCTransparentWindowWillAnimateBoundsChangeNotification = @"MCTransparentWindowWillAnimateBoundsChangeNotification";
NSString* const MCTransparentWindowIsAnimatingBoundsChangeNotification = @"MCTransparentWindowIsAnimatingBoundsChangeNotification";
NSString* const MCTransparentWindowDidAnimateBoundsChangeNotification = @"MCTransparentWindowDidAnimateBoundsChangeNotification";

@implementation MCTransparentWindow

+ (instancetype)windowWithLevel:(UIWindowLevel)level {
    return [[self alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(UIWindowLevel)level {
    self = [super init];
    if (self) {
        self.windowLevel = level;
        self.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        [self updateBoundsForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoundsForOrientationChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - Methods

static CGAffineTransform TransformAccountingForOrientation(UIInterfaceOrientation orientation, CGRect bounds) {
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"9.0" options: NSNumericSearch];
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformRotate(transform, -M_PI / 2);
            if (order == NSOrderedAscending) {
                transform = CGAffineTransformTranslate(transform, -CGRectGetWidth(bounds) / 2, CGRectGetHeight(bounds) / 2);
            }
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformRotate(transform, M_PI / 2);
            if (order == NSOrderedAscending) {
                transform = CGAffineTransformTranslate(transform, CGRectGetWidth(bounds) / 2, -CGRectGetHeight(bounds) / 2);
            }
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformRotate(transform, M_PI);
            if (order == NSOrderedAscending) {
                transform = CGAffineTransformTranslate(transform, -CGRectGetWidth(bounds) / 2, -CGRectGetHeight(bounds) / 2);
            }
            break;
            
        default: {
            if (order == NSOrderedAscending) {
                transform = CGAffineTransformTranslate(transform, CGRectGetWidth(bounds) / 2, CGRectGetHeight(bounds) / 2);
            }
            break;
        }
    }
    
    return transform;
}

- (void)updateBoundsForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
        bounds = [UIScreen mainScreen].fixedCoordinateSpace.bounds;
    }
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        bounds.size = CGSizeMake(CGRectGetHeight(bounds), CGRectGetWidth(bounds));
    }
    
    self.transform = TransformAccountingForOrientation(interfaceOrientation, bounds);
    self.bounds = bounds;
}

- (void)updateBoundsForOrientationChange:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MCTransparentWindowWillAnimateBoundsChangeNotification object:nil userInfo:nil];
    
    UIInterfaceOrientation interfaceOrientation = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
        [self updateBoundsForOrientation:interfaceOrientation];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCTransparentWindowIsAnimatingBoundsChangeNotification object:nil userInfo:nil];
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MCTransparentWindowDidAnimateBoundsChangeNotification object:nil userInfo:nil];
    }];
}

#pragma mark - UIView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
}

@end
