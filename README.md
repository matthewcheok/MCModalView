MCModalView ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
===========

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/MCModalView/badge.png)](https://github.com/matthewcheok/MCModalView)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/MCModalView/badge.svg)](https://github.com/matthewcheok/MCModalView)

UIAlertView/UIActionSheet replacement supporting iPhone/iPad and device rotations.

##Screenshot
![Screenshot](https://raw.github.com/matthewcheok/MCModalView/master/AlertViews.gif "Example of MCModalView")
![Screenshot](https://raw.github.com/matthewcheok/MCModalView/master/ActionSheets.gif "Example of MCModalView")

## Installation

Add the following to your [CocoaPods](http://cocoapods.org/) Podfile

    pod 'MCModalView', '~> 0.2'

or clone as a git submodule,

or just copy files in the ```MCModalView``` folder into your project.

## Using MCModalView

### Presenting alerts

Initialize and display alerts like this:

    MCAlertView *alertView1 = [MCAlertView alertViewWithTitle:@"Alert 1" message:@"This is a message." actionButtonTitle:@"OK" cancelButtonTitle:@"Cancel" completionHandler:^(BOOL cancelled) {
        NSLog(@"Alert 1 cancelled? %d", cancelled);
    }];
    [alertView1 show];

### Presenting action sheets

Initialize and display action sheets like this:

    [[MCActionSheet actionSheetWithTitle:nil message:nil cancelButtonTitle:@"Cancel" actionButtonTitles:@[@"Add a Contact", @"Choose from Address Book"] completionHandler: ^(BOOL cancelled, NSUInteger selectedActionIndex) {
        NSLog(@"Action Sheet cancelled? %d Selected? %lu", cancelled, selectedActionIndex);
    }] show];

### Appearance Customization

You can configure `tintColor` to change the tintColor.

    alertView1.tintColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.6 alpha:1];

Change fonts used by setting the `font` property on `titleLabel`, `messageLabel`, `actionButton` and `cancelButton`.

## License

MCModalView is under the MIT license.
