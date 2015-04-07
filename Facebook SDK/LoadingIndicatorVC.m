//
//  LoadingIndicatorVC.m
//  Countdown
//
//  Created by onegray on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoadingIndicatorVC.h"


@implementation LoadingIndicatorVC

@synthesize activityIndicator;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[activityIndicator startAnimating];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.activityIndicator = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
