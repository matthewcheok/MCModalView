MCAlertView ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
===========

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/MCAlertView/badge.png)](https://github.com/matthewcheok/MCAlertView)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/MCAlertView/badge.svg)](https://github.com/matthewcheok/MCAlertView)

UIAlertView replacement supporting iPhone/iPad and device rotations.

##Screenshot
![Screenshot](https://raw.github.com/matthewcheok/MCAlertView/master/MCAlertView.gif "Example of MCAlertView")

## Installation

Add the following to your [CocoaPods](http://cocoapods.org/) Podfile

    pod 'MCAlertView', '~> 0.1'

or clone as a git submodule,

or just copy files in the ```MCAlertView``` folder into your project.

## Using MCAlertView

### Presenting alerts

Initialize and display alerts like this:

    MCAlertView *alertView1 = [MCAlertView alertViewWithTitle:@"Alert 1" message:@"This is a message." actionButtonTitle:@"OK" cancelButtonTitle:@"Cancel" completionHandler:^(BOOL cancelled) {
        NSLog(@"Alert 1 cancelled? %d", cancelled);
    }];
    [alertView1 show];

### Appearance Customization

You can configure `tintColor` to change the tintColor.

    alertView1.tintColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.6 alpha:1];

Change fonts used by setting the `font` property on `titleLabel`, `messageLabel`, `actionButton` and `cancelButton`.

## License

MCAlertView is under the MIT license.
