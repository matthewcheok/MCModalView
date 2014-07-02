//
//  MCModalView.h
//  Pods
//
//  Created by Matthew Cheok on 2/7/14.
//
//

#import <UIKit/UIKit.h>

@interface MCModalView : UIView

- (void)animatePresentationInWindow:(UIWindow *)window completionHandler:(void (^)())completion;
- (void)animateDismissalInWindow:(UIWindow *)window completionHandler:(void (^)())completion;

@end
