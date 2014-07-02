//
//  MCAlertController.h
//  Pods
//
//  Created by Matthew Cheok on 2/7/14.
//
//

#import <Foundation/Foundation.h>
#import "MCModalView.h"

@interface MCModalController : NSObject

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) MCModalView *activeView;

@property (nonatomic, strong) NSMutableArray *queue;

+ (instancetype)sharedInstance;
- (void)queueModalView:(MCModalView *)view;
- (void)presentNextView;
- (void)dismissActiveView;

@end