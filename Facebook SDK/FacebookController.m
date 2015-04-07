//
//  FacebookController.m
//  Countdown
//
//  Created by Sergey Nikitenko on 12/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FacebookController.h"
#import "Facebook.h"
#import "LoadingIndicatorVC.h"

NSString* kFbAppId = @"af5a78351b15de59b899f745c0a74b9d";

typedef enum eFacebookActionType
{
	FC_NO_ACTION,
	FC_LOGIN,
	FC_GET_UID,
	FC_PUBLISH_STREAM,
	FC_UPLOAD_PHOTO,
	FC_CHECKIN,
}FacebookActionType;


@interface FacebookController ()

@property (nonatomic, retain) NSMutableDictionary* requestParams;
@property (nonatomic, retain) UIViewController* loadingIndicatorController;


-(void) showLoadingIndicator;
-(void) hideLoadingIndicator;

@end

@implementation FacebookController

@synthesize delegate;
@synthesize requestParams;
@synthesize lastError;
@synthesize loadingIndicatorController;

static FacebookController* sharedInstance = nil;

+(FacebookController*) sharedController
{
	if(sharedInstance==nil)
	{
		sharedInstance = [[FacebookController alloc] init];
	}
	return sharedInstance;
}

-(id) init
{
	if(self=[super init])
	{
		action = FC_NO_ACTION;
	}
	return self;
}

-(BOOL) isLoggedIn
{
	return [facebook isSessionValid];
}


-(void) requestLogin
{
	 
    NSArray* permissions = [NSArray arrayWithObjects: @"publish_stream", @"offline_access", @"user_checkins", @"publish_checkins",@"user_events", @"friends_events", @"create_event",nil];
	[facebook authorize:kFbAppId permissions:permissions delegate:self];
}

-(void) requestUid
{
	[facebook requestWithGraphPath:@"me" andDelegate:self];
}

-(void) requestPublishStream
{
	[facebook requestWithGraphPath:@"me/feed" andParams:requestParams andHttpMethod:@"POST" andDelegate:self];
}

-(void) requestUploadPhoto
{
	[facebook requestWithMethodName:@"facebook.photos.upload" andParams:requestParams andHttpMethod:@"POST" andDelegate:self];
}

-(void) requestCheckin
{
	[facebook requestWithGraphPath:@"me/checkins" andParams:requestParams andHttpMethod:@"POST" andDelegate:self];
}


-(void) logout
{
}

-(void) login
{
	
}

-(void) loginAndGetUid
{
	NSLog(@"FacebookController loginAndGetUid");
	NSAssert(action==FC_NO_ACTION, @"FacebookController request is already in progress");
	action = FC_GET_UID;
	
	[self login];
	
	if( [self isLoggedIn] )
	{
		[self requestUid];
		[self showLoadingIndicator];
	}
}

-(void) publishStream:(NSDictionary*)publishParams
{
	NSLog(@"FacebookController publishStream");
	NSAssert(action==FC_NO_ACTION, @"FacebookController request is already in progress");
	action = FC_PUBLISH_STREAM;
	
	self.requestParams = [NSMutableDictionary dictionaryWithDictionary:publishParams];
	
	[self login];
	
	if( [self isLoggedIn] )
	{
		[self requestPublishStream];
		[self showLoadingIndicator];
	}
}

-(void) uploadPhoto:(NSDictionary*)uploadParams
{
	NSLog(@"FacebookController uploadPhoto");
	NSAssert(action==FC_NO_ACTION, @"FacebookController request is already in progress");
	action = FC_UPLOAD_PHOTO;
	
	self.requestParams = [NSMutableDictionary dictionaryWithDictionary:uploadParams];
	
	[self login];
	
	if( [self isLoggedIn] )
	{
		[self requestUploadPhoto];
		[self showLoadingIndicator];
	}
}

-(void) checkin:(NSDictionary*)checkinParams
{
	NSLog(@"FacebookController checkin");
	NSAssert(action==FC_NO_ACTION, @"FacebookController request is already in progress");
	action = FC_CHECKIN;
	
	self.requestParams = [NSMutableDictionary dictionaryWithDictionary:checkinParams];
	
	[self login];
	
	if( [self isLoggedIn] )
	{
		[self requestCheckin];
		[self showLoadingIndicator];
	}
}




- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"FacebookController fbDidNotLogin");
	
	self.requestParams = nil;
	[facebook release];
	facebook = nil; 
	
	if(!cancelled)
	{
		NSString* errMsg = @"Facebook login failed";
		NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
		self.lastError = [NSError errorWithDomain:@"facebookErrDomain" code:499 userInfo:errorInfo];
	}
	
	FacebookActionType fat = action;
	action = FC_NO_ACTION;
	
	if( [delegate respondsToSelector:@selector(facebookDidLoginSuccessfully:)] )
	{
		[delegate facebookDidLoginSuccessfully:NO];
	}
	
	if(fat==FC_GET_UID)
	{
		if( [delegate respondsToSelector:@selector(facebookDidGetUid:successfully:)] )
		{
			[delegate facebookDidGetUid:nil successfully:NO];
		}
	}
	else if(fat==FC_PUBLISH_STREAM )
	{
		if( [delegate respondsToSelector:@selector(facebookDidPublishSuccessfully:)] )
		{
			[delegate facebookDidPublishSuccessfully:NO];
		}
	}
	else if(fat==FC_UPLOAD_PHOTO )
	{
		if( [delegate respondsToSelector:@selector(facebookDidUploadPhotoSuccessfully:)] )
		{
			[delegate facebookDidUploadPhotoSuccessfully:NO];
		}
	}
	else if(fat==FC_CHECKIN )
	{
		if( [delegate respondsToSelector:@selector(facebookDidCheckinSuccessfully:)] )
		{
			[delegate facebookDidCheckinSuccessfully:NO];
		}
	}	
}

-(void) fbDidLogin 
{
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error 
{
	NSLog(@"FacebookController request:didFailWithError: %@",[error localizedDescription]);
	
	self.lastError = error;
	
	FacebookActionType fat = action;
	action = FC_NO_ACTION;
	
	if(fat==FC_GET_UID)
	{
		if( [delegate respondsToSelector:@selector(facebookDidGetUid:successfully:)] )
		{
			[delegate facebookDidGetUid:nil successfully:NO];
		}
	}
	else if(fat==FC_PUBLISH_STREAM)
	{
		self.requestParams = nil;
		if( [delegate respondsToSelector:@selector(facebookDidPublishSuccessfully:)] )
		{
			[delegate facebookDidPublishSuccessfully:NO];
		}
	}
	else if(fat==FC_UPLOAD_PHOTO)
	{
		self.requestParams = nil;
		if( [delegate respondsToSelector:@selector(facebookDidUploadPhotoSuccessfully:)] )
		{
			[delegate facebookDidUploadPhotoSuccessfully:NO];
		}
	}
	else if(fat==FC_CHECKIN)
	{
		self.requestParams = nil;
		if( [delegate respondsToSelector:@selector(facebookDidCheckinSuccessfully:)] )
		{
			[delegate facebookDidCheckinSuccessfully:NO];
		}
	}
	
}

- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"FacebookController request:didLoad: %@", result);
	self.lastError = nil;
	
	if(action==FC_GET_UID)
	{
		id uid = [result objectForKey:@"id"];
				
		[self hideLoadingIndicator];
		action = FC_NO_ACTION;
		
		if( [delegate respondsToSelector:@selector(facebookDidGetUid:successfully:)] )
		{
			[delegate facebookDidGetUid:uid successfully:YES];
		}
	}
	else if(action==FC_PUBLISH_STREAM)
	{
		[self hideLoadingIndicator];
		action = FC_NO_ACTION;
		self.requestParams = nil;
		
		if( [delegate respondsToSelector:@selector(facebookDidPublishSuccessfully:)] )
		{
			[delegate facebookDidPublishSuccessfully:YES];
		}
	}
	else if(action==FC_UPLOAD_PHOTO)
	{
		[self hideLoadingIndicator];
		action = FC_NO_ACTION;
		self.requestParams = nil;
		
		if( [delegate respondsToSelector:@selector(facebookDidUploadPhotoSuccessfully:)] )
		{
			[delegate facebookDidUploadPhotoSuccessfully:YES];
		}
	}
	else if(action==FC_CHECKIN)
	{
		[self hideLoadingIndicator];
		action = FC_NO_ACTION;
		self.requestParams = nil;
		
		if( [delegate respondsToSelector:@selector(facebookDidCheckinSuccessfully:)] )
		{
			[delegate facebookDidCheckinSuccessfully:YES];
		}
	}	
}




-(void) showLoadingIndicator
{
	if(loadingIndicatorController==nil)
	{
		self.loadingIndicatorController = [[[LoadingIndicatorVC alloc] initWithNibName:@"LoadingIndicatorVC" bundle:nil] autorelease];
		UIWindow* window = [[UIApplication sharedApplication] keyWindow];
		[window addSubview:loadingIndicatorController.view];
	}
}

-(void) hideLoadingIndicator
{
	if(loadingIndicatorController!=nil)
	{
		[loadingIndicatorController.view removeFromSuperview];
		loadingIndicatorController = nil;
	}
}


@end
