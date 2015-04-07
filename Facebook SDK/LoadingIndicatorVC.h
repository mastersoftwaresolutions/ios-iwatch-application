//
//  LoadingIndicatorVC.h
//  Countdown
//
//  Created by onegray on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingIndicatorVC : UIViewController {

	UIActivityIndicatorView* activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
