//
//  FacebookUploadImage.h
//  MultiUnitRestaurant
//
//  Created by Rakesh Kumar on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MultiUnitRestaurantAppDelegate.h"
#import "AppDelegate.h"
#import "FBRequest.h"
@interface FacebookUploadImage : NSObject <FBRequestDelegate >
{
    AppDelegate *appDelegate;
}

 -(void) requestUploadPhoto:(NSMutableDictionary *)requestParams;
-(void) uploadPhotoImage:(UIImage*)image withCaption:(NSString*)caption;
@end
