//
//  FacebookUploadImage.m
//  MultiUnitRestaurant
//
//  Created by Rakesh Kumar on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookUploadImage.h"


@implementation FacebookUploadImage

- (id)init
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self = [super init];
    return self;
}

-(void) uploadPhotoImage:(UIImage*)image withCaption:(NSString*)caption {
   	NSData *imgData = UIImagePNGRepresentation(image);
    
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:imgData forKey:@"image"];
	if([caption length] > 0)
	{
		[params setObject:caption forKey:@"caption"];
	}
	
	[self requestUploadPhoto:params];
}

-(void) requestUploadPhoto:(NSMutableDictionary *)requestParams 
{
   
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	//[[NSNotificationCenter defaultCenter] postNotificationName:kImageUploadedOnFacebook object:nil];
}


/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	//[[NSNotificationCenter defaultCenter] postNotificationName:kImageUploadRequestFailedForFacebook object:nil];
}


@end
