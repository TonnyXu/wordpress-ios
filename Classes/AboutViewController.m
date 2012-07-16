//
//  AboutViewController.m
//  WordPress
//
//  Created by Dan Roundhill on 2/15/11.
//  Copyright 2011 WordPress. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize buttonsView;
@synthesize logoView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    [super viewDidLoad];
	
    self.navigationItem.title = NSLocalizedString(@"About", @"About this app (information page title)");
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome_bg_pattern.png"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if( IS_IPHONE ) {
        if ( YES == UIInterfaceOrientationIsLandscape(interfaceOrientation) ) {
            self.logoView.hidden = YES;
            CGRect frame = buttonsView.frame;
            frame.origin.y = -20.0f;
            self.buttonsView.frame = frame;
        } else {
            self.logoView.hidden = NO;
            CGRect frame = buttonsView.frame;
            frame.origin.y = 90.0f;
            self.buttonsView.frame = frame;
        }
    }
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void)viewTermsOfService:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://wordpress.com/tos/"]];
}

-(void)viewPrivacyPolicy:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://automattic.com/privacy/"]];
}

-(void)viewWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://automattic.com/"]];
}

@end
