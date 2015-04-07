//
//  ViewController.h
//  WatchkitDemo
//
//  Created by Poonam Parmar on 3/11/15.
//  Copyright (c) 2015 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,FBRequestDelegate,FBSessionDelegate,FBLoginDialogDelegate>


@end
