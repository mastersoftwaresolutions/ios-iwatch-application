//
//  InterfaceController.m
//  WatchkitDemo WatchKit Extension
//
//  Created by Poonam Parmar on 3/11/15.
//  Copyright (c) 2015 MSS. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()
{
    BOOL colorChange;
    NSMutableArray *contactArrayExt;
    NSMutableArray *shareArray;
}
@end


@implementation InterfaceController
@synthesize contactTabl;


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    colorChange=YES;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    shareArray = [NSMutableArray new];
    contactArrayExt = [NSMutableArray new];
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.com.mss.WatchkitDemo"];
    
   // NSLog(@"Array is ==>%@",[mySharedDefaults objectForKey:@"contactDetails"]);
    
    contactArrayExt = [[mySharedDefaults objectForKey:@"contactDetails"] mutableCopy];
    
    [self setupTable];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}



- (void)setupTable
{
   NSMutableArray *rowTypesList = [NSMutableArray array];
    for (int i=0; i<contactArrayExt.count; i++) {
        [rowTypesList addObject:@"tableIdentifier"];
    }
   
    
    [contactTabl setRowTypes:rowTypesList];
    
    for (NSInteger i = 0; i < contactTabl.numberOfRows; i++)
    {
        NSObject *row = [contactTabl rowControllerAtIndex:i];
        tableIdentifier *importantRow = (tableIdentifier *) row;
            
            [importantRow.nameLbl setText:[NSString stringWithFormat:@"%@ %@",[[contactArrayExt valueForKey:@"FirstName"] objectAtIndex:i],[[contactArrayExt valueForKey:@"lastName"] objectAtIndex:i]]];
            [importantRow.phoneLbl setText:[[contactArrayExt valueForKey:@"phone"] objectAtIndex:i]];
            [importantRow.emailLbl setText:[[contactArrayExt valueForKey:@"email"]objectAtIndex:i]];
       
    }
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
//    NSDictionary *d=[NSDictionary dictionaryWithObject:@"hi" forKey:@"nm"];
//    [self presentControllerWithName:@"ProfileInterfaceController" context:d];
    NSLog(@"%ld",(long)rowIndex);
    
    NSString*nameString = [NSString stringWithFormat:@"%@ %@",[[contactArrayExt valueForKey:@"FirstName"] objectAtIndex:rowIndex],[[contactArrayExt valueForKey:@"lastName"] objectAtIndex:rowIndex]];
    NSString*phoneString = [[contactArrayExt valueForKey:@"phone"] objectAtIndex:rowIndex];
    NSString*emailString = [[contactArrayExt valueForKey:@"email"]objectAtIndex:rowIndex];
    
            NSMutableDictionary *contDictionary = [NSMutableDictionary new];
            [contDictionary setObject:nameString forKey:@"name"];
            [contDictionary setObject:phoneString forKey:@"phone"];
            [contDictionary setObject:emailString forKey:@"email"];
    
    
    [shareArray addObject:contDictionary];
    
    NSUserDefaults *shareUserDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mss.WatchkitDemo"];
    [shareUserDefault setObject:shareArray forKey:@"SharedContacts"];
    
    
    
}


@end
