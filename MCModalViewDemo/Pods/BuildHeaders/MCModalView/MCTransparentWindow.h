//
//  MCTransparentWindow.h
//  Pods
//
//  Created by Matthew Cheok on 28/4/14.
//
//

#import <UIKit/UIKit.h>

extern NSString* const MCTransparentWindowWillAnimateBoundsChangeNotification;
extern NSString* const MCTransparentWindowIsAnimatingBoundsChangeNotification;
extern NSString* const MCTransparentWindowDidAnimateBoundsChangeNotification;

@interface MCTransparentWindow : UIWindow

+ (instancetype)windowWithLevel:(UIWindowLevel)level;
- (instancetype)initWithLevel:(UIWindowLevel)level;

- (void)updateBoundsForOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
