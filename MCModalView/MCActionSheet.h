//
//  MCActionSheet.h
//  Pods
//
//  Created by Matthew Cheok on 2/7/14.
//
//

#import "MCModalView.h"
#import "MCRoundedButton.h"

@interface MCActionSheet : MCModalView

@property (strong, nonatomic, readonly) UIView *contentView;
@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *messageLabel;

@property (strong, nonatomic, readonly) MCRoundedButton *cancelButton;
@property (strong, nonatomic, readonly) NSArray *actionButtons;

@property (copy, nonatomic) void (^completionHandler)(BOOL cancelled, NSUInteger selectedActionIndex);

+ (instancetype)actionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actionButtonTitles:(NSArray *)actionButtonTitles completionHandler:(void (^)(BOOL cancelled, NSUInteger selectedActionIndex))completion;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actionButtonTitles:(NSArray *)actionButtonTitles completionHandler:(void (^)(BOOL cancelled, NSUInteger selectedActionIndex))completion;

/**
 Presents the alert view
 */
- (void)show;

/**
 Dismisses the alert view
 */
- (void)dismiss;

@end
