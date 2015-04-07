//
//  FacebookController.h
//  Countdown
//
//  Created by Sergey Nikitenko on 12/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"


@protocol FacebookControllerDelegate <NSObject>
@optional

-(void) facebookDidLoginSuccessfully:(BOOL)successfully;
-(void) facebookDidGetUid:(NSString*)uid successfully:(BOOL)successfully;
-(void) facebookDidPublishSuccessfully:(BOOL)successfully;
-(void) facebookDidUploadPhotoSuccessfully:(BOOL)successfully;
-(void) facebookDidCheckinSuccessfully:(BOOL)successfully;

@end


@interface FacebookController : NSObject <FBDialogDelegate, FBRequestDelegate, FBSessionDelegate>
{
	Facebook* facebook;
	
	int action;
	NSMutableDictionary* requestParams;
	
	id<FacebookControllerDelegate> delegate;
	
	NSError* lastError;
	
	UIViewController* loadingIndicatorController;
}

@property (nonatomic, assign) id<FacebookControllerDelegate> delegate;
@property (nonatomic, retain) NSError* lastError;

+(FacebookController*) sharedController;

-(BOOL) isLoggedIn;
-(void) logout;
-(void) login;
-(void) loginAndGetUid;
-(void) publishStream:(NSDictionary*)publishParams;
-(void) uploadPhoto:(NSDictionary*)uploadParams;
-(void) checkin:(NSDictionary*)checkinParams;


@end

extern NSString* kFbAppId;
