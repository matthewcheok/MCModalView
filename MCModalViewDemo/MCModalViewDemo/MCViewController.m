//
//  MCViewController.m
//  MCAlertViewDemo
//
//  Created by Matthew Cheok on 12/6/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import "MCViewController.h"

#import <MCAlertView.h>
#import <MCActionSheet.h>

@interface MCViewController ()

@end

@implementation MCViewController

- (IBAction)handleShowAlertViewsButton:(id)sender {
	MCAlertView *alertView1 = [MCAlertView alertViewWithTitle:@"Alert 1" message:@"This is a message." actionButtonTitle:@"OK" cancelButtonTitle:@"Cancel" completionHandler: ^(BOOL cancelled) {
	    NSLog(@"Alert 1 cancelled? %d", cancelled);
	}];
	alertView1.tintColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.6 alpha:1];
	[alertView1 show];

	[[MCAlertView alertViewWithTitle:@"Alert 2" message:@"This message wraps multiple lines because it's so insanely long." actionButtonTitle:@"OK" cancelButtonTitle:@"Cancel" completionHandler: ^(BOOL cancelled) {
	    NSLog(@"Alert 2 cancelled? %d", cancelled);
	}] show];

	[[MCAlertView alertViewWithTitle:nil message:@"This alert has no title." actionButtonTitle:@"OK" cancelButtonTitle:@"Cancel" completionHandler: ^(BOOL cancelled) {
	    NSLog(@"Alert 3 cancelled? %d", cancelled);
	}] show];
}

- (IBAction)handleShowActionSheetsButton:(id)sender {
	[[MCActionSheet actionSheetWithTitle:nil message:nil cancelButtonTitle:@"Cancel" actionButtonTitles:@[@"Add a Contact", @"Choose from Address Book"] completionHandler: ^(BOOL cancelled, NSUInteger selectedActionIndex) {
	    NSLog(@"Action Sheet cancelled? %d Selected? %lu", cancelled, selectedActionIndex);
	}] show];
    [[MCActionSheet actionSheetWithTitle:@"Title" message:@"Some message" cancelButtonTitle:@"Cancel" actionButtonTitles:nil completionHandler: ^(BOOL cancelled, NSUInteger selectedActionIndex) {
	    NSLog(@"Action Sheet cancelled? %d Selected? %lu", cancelled, selectedActionIndex);
	}] show];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
