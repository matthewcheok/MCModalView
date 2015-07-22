//
//  MCAlertView.h
//  MCAdditions
//
//  Created by Matthew Cheok on 22/5/13.
//  Copyright (c) 2013 Matthew Cheok. All rights reserved.
//

#import "MCModalView.h"
#import "MCRoundedButton.h"

@interface MCAlertView : MCModalView

@property (strong, nonatomic, readonly) UIView *contentView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *messageLabel;

@property (strong, nonatomic, readonly) MCRoundedButton *cancelButton;
@property (strong, nonatomic, readonly) MCRoundedButton *actionButton;

@property (copy, nonatomic) void (^completionHandler)(BOOL cancelled);

/**
 Convenience initializer
 
 @param title             The title of the alert
 @param message           The message body of the alert
 @param actionButtonTitle The button that indicates affirmative action
 @param cancelButtonTitle The button that cancels the proposed action
 @param completion        The completion block that executes when an action is taken
 
 @return The alert view instance
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message actionButtonTitle:(NSString *)actionButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(void (^)(BOOL cancelled))completion;

/**
 Designated initializer
 
 @param title             The title of the alert
 @param message           The message body of the alert
 @param actionButtonTitle The button that indicates affirmative action
 @param cancelButtonTitle The button that cancels the proposed action
 @param completion        The completion block that executes when an action is taken
 
 @return The alert view instance
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actionButtonTitle:(NSString *)actionButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(void (^)(BOOL cancelled))completion;

/**
 Presents the alert view
 */
- (void)show;

/**
 Dismisses the alert view
 */
- (void)dismiss;

@end
