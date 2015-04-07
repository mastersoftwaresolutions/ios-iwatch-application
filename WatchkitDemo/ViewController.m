//
//  ViewController.m
//  WatchkitDemo
//
//  Created by Poonam Parmar on 3/11/15.
//  Copyright (c) 2015 MSS. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
@interface ViewController ()<FBRequestDelegate,FBLoginDialogDelegate,FBDialogDelegate,FBSessionDelegate>
{
    NSMutableArray *contactList;
    NSString *emailNumber;
    NSString *phoneNumber;
    UITableView *ContactsTable;
    NSMutableArray *sharedContactArray;
    
    //facebook
    
    Facebook *facebook;
    BOOL isFBLogged;
    NSString *myfacebookid;
    NSString *myfacebookifirstname;
    NSString *myfacebooklastname;
    NSString *myfacebookusername;
    NSString *myfacebookemail;
    NSString *facebookToken;
    AppDelegate *appDelegate;

}
@end

@implementation ViewController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //*** facebook *****//
    
    NSLog(@"app id : %@",appDelegate.facebookAppId);
    if (facebook == nil)
    {
        facebook = [[Facebook alloc] initWithAppId:appDelegate.facebookAppId];
    }
    NSArray* permissions =  [NSArray arrayWithObjects: @"email",@"public_profile", nil];
    
    NSLog(@"%@",permissions);
    [facebook authorize:permissions delegate:self];
    
    
    
    sharedContactArray = [NSMutableArray new];
    NSUserDefaults *sharedContactsUser = [[NSUserDefaults alloc] initWithSuiteName: @"group.com.mss.WatchkitDemo"];
    sharedContactArray = [[sharedContactsUser objectForKey:@"SharedContacts"] mutableCopy];
    NSLog(@"Array is ==>%@",sharedContactArray);
    

    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
    
    ContactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)style:UITableViewStyleGrouped];
    ContactsTable.backgroundColor=[UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0f];
    ContactsTable.bounces=NO;
    ContactsTable.pagingEnabled=NO;
    ContactsTable.delegate=self;
    ContactsTable.dataSource=self;
    [self.view addSubview:ContactsTable];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (void)getContactsWithAddressBook:(ABAddressBookRef)addressBook
{
    
    contactList = [NSMutableArray new];
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
         //        NSString *email  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonEmailProperty));
        NSLog(@"Name:%@ %@", firstName, lastName);
        
        
        
        
        
        // For Email ids
        ABMultiValueRef emailIs = ABRecordCopyValue(person, kABPersonEmailProperty);
        CFIndex numberEmail = ABMultiValueGetCount(emailIs);
        for (CFIndex i = 0; i < numberEmail; i++) {
            emailNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailIs, i));
            //NSLog(@"  email:%@", emailNumber);
        }
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            // NSLog(@"  phone:%@", phoneNumber);
        }
        
        CFRelease(phoneNumbers);
        NSMutableDictionary *dictionary = [NSMutableDictionary new];
        [dictionary setObject:firstName forKey:@"FirstName"];
        [dictionary setObject:lastName forKey:@"lastName"];
        [dictionary setObject:phoneNumber forKey:@"phone"];
        [dictionary setObject:emailNumber forKey:@"email"];
        [contactList addObject:dictionary];
        
    }
    
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.com.mss.WatchkitDemo"];
    // Use the shared user defaults object to update the user's account
    [mySharedDefaults setObject:contactList forKey:@"contactDetails"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return contactList.count;
    }
    else{
        return sharedContactArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Contact list";
    }
    else
    {
        return @"Shared Contact list";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if (indexPath.section==0) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        UILabel *namelabel=[[UILabel alloc] initWithFrame:CGRectMake(10,5,200,30)];
        namelabel.backgroundColor = [UIColor clearColor];
        namelabel.font=[UIFont fontWithName:nil size:13];
        namelabel.textColor=[UIColor colorWithRed:78/255.0f green:121/255.0f blue:23/255.0f alpha:1.0f];
        namelabel.text = [NSString stringWithFormat:@"%@ %@",[[contactList valueForKey:@"FirstName"] objectAtIndex:indexPath.row],[[contactList valueForKey:@"lastName"] objectAtIndex:indexPath.row]];
        [cell.contentView addSubview:namelabel];
        
        UILabel *phonelabel=[[UILabel alloc] initWithFrame:CGRectMake(10,25,200,30)];
        phonelabel.backgroundColor = [UIColor clearColor];
        phonelabel.font=[UIFont fontWithName:nil size:12];
        phonelabel.textColor=[UIColor colorWithRed:78/255.0f green:121/255.0f blue:23/255.0f alpha:1.0f];
        phonelabel.text = [[contactList valueForKey:@"phone"] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:phonelabel];
        
        UILabel *emaillabel=[[UILabel alloc] initWithFrame:CGRectMake(10,45,200,30)];
        emaillabel.backgroundColor = [UIColor clearColor];
        emaillabel.font=[UIFont fontWithName:nil size:12];
        emaillabel.textColor=[UIColor colorWithRed:78/255.0f green:121/255.0f blue:23/255.0f alpha:1.0f];
        emaillabel.text = [[contactList valueForKey:@"email"] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:emaillabel];
        return cell;
        
        
        
        
        
    }
    else{
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        
        UILabel *shareNamelbl=[[UILabel alloc] initWithFrame:CGRectMake(10,5,200,30)];
        shareNamelbl.backgroundColor = [UIColor clearColor];
        shareNamelbl.font=[UIFont fontWithName:nil size:13];
        shareNamelbl.textColor=[UIColor orangeColor];
        shareNamelbl.text=[[sharedContactArray valueForKey:@"name"] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:shareNamelbl];
        
        UILabel *sharephonelbl=[[UILabel alloc] initWithFrame:CGRectMake(10,25,200,30)];
        sharephonelbl.backgroundColor = [UIColor clearColor];
        sharephonelbl.font=[UIFont fontWithName:nil size:13];
        sharephonelbl.textColor=[UIColor orangeColor];
        sharephonelbl.text=[[sharedContactArray valueForKey:@"phone"] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:sharephonelbl];
        
        UILabel *sharEmaillbl=[[UILabel alloc] initWithFrame:CGRectMake(10,45,200,30)];
        sharEmaillbl.backgroundColor = [UIColor clearColor];
        sharEmaillbl.font=[UIFont fontWithName:nil size:13];
        sharEmaillbl.textColor=[UIColor orangeColor];
        sharEmaillbl.text=[[sharedContactArray valueForKey:@"email"] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:sharEmaillbl];
    
        
        
        return cell;
    }
    
}






- (BOOL) takeScreenshot
{
    
    NSMutableDictionary* params = [ NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,email,last_name,first_name",@"fields",nil];
    NSLog(@"%@",params);
     // [facebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];
    [facebook requestWithGraphPath:@"me"
                        andParams:params andDelegate:self];
    
    
    
    
    
    
    NSString *friendId=@"venki.mss";
    
    NSLog(@"%@",friendId);
    
    NSMutableDictionary* Requestparams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Hi please add me as a friend.",  @"message",
                                   friendId, @"to",
                                   nil];
    [facebook dialog:@"apprequests" andParams:Requestparams  andDelegate:self];
    
    
    
    
    
    
    return YES;
    
}
- (void)fbDidLogin
{
    isFBLogged = YES;
    [self takeScreenshot];
}
-(void)fbDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        
    }
    else
    {
        
    }
}
- (void)fbDidLogout
{
    isFBLogged = NO;
}

#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)showWithCustomView:(NSString*)str
{
    
}
- (void)request:(FBRequest *)request didLoad:(id)result
{
    isFBLogged=NO;
    facebookToken=facebook.accessToken;
    //NSLog(@"facebookarray %@",facebookToken);
    
    
    if ([result objectForKey:@"email"]==nil){
        
//        [CustomeAlert alertViewWithTitle:@"Radtab" okBtn:@"OK" message:@"Please do facebook login with email only"];
        return;
        
    }
    else
    {
        myfacebookid=[result objectForKey:@"id"];
        myfacebookifirstname = [result objectForKey:@"first_name"];
        myfacebooklastname = [result objectForKey:@"last_name"];
        myfacebookusername = [result objectForKey:@"name"];
        myfacebookemail = [result objectForKey:@"email"];
        NSLog(@"%@",myfacebookemail);
       // [self facebookDataSaved];
    }
    
    
    
    
    
}


- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    //[message setString:@"Error. Please try again."];
    //menuView.hidden = NO;
    NSLog(@"error %@",[error description]);
}


#pragma mark FBDialogDelegate
- (void)dialogDidComplete:(FBDialog *)dialog
{
    NSLog(@"publish successfully");
    if (isFBLogged)
    {
        [facebook logout:self];
    }
    else
    { // then the code above inside the else
        [facebook logout:self];
    }
}
@end
