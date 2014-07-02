//
//  MCBorderedButton.h
//  MCAdditions
//
//  Created by Matthew Cheok on 6/2/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCRoundedButton : UIButton

@property (strong, nonatomic) UIColor *selectedTitleColor UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic, getter = isAnimating) BOOL animating;

@end
