//
//  MCModalView.m
//  Pods
//
//  Created by Matthew Cheok on 2/7/14.
//
//

#import "MCModalView.h"

@implementation MCModalView

- (void)animatePresentationInWindow:(UIWindow *)window completionHandler:(void (^)())completion {
    [NSException raise:NSInternalInconsistencyException format:@"Must override this method in subclass!"];
}

- (void)animateDismissalInWindow:(UIWindow *)window completionHandler:(void (^)())completion {
    [NSException raise:NSInternalInconsistencyException format:@"Must override this method in subclass!"];
}

@end
