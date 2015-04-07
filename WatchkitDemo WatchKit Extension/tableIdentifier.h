//
//  tableIdentifier.h
//  WatchkitDemo
//
//  Created by Poonam Parmar on 3/18/15.
//  Copyright (c) 2015 MSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>
@interface tableIdentifier : NSObject
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nameLbl;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *emailLbl;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *phoneLbl;


@property (weak, nonatomic) IBOutlet WKInterfaceButton *btnOutlet;


@end
