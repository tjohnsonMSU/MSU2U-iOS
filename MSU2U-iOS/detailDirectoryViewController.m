//
//  detailDirectoryViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/4/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailDirectoryViewController.h"

@interface detailDirectoryViewController ()
@property (weak,nonatomic) NSString * receivedFName;
@property (weak,nonatomic) NSString * receivedMiddle;
@property (weak,nonatomic) NSString * receivedLName;
@property (weak,nonatomic) NSString * receivedPersonID;
@property (weak,nonatomic) NSString * receivedLastChanged;
@property (weak,nonatomic) NSString * deleted;
@property (weak,nonatomic) NSString * receivedPosition1;
@property (weak,nonatomic) NSString * receivedPosition2;
@property (weak,nonatomic) NSString * receivedNamePrefix;
@property (weak,nonatomic) NSString * receivedEmail;
@property (weak,nonatomic) NSString * receivedDeptID1;
@property (weak,nonatomic) NSString * receivedDeptID2;
@property (weak,nonatomic) NSString * receivedOfficeBldgID1;
@property (weak,nonatomic) NSString * receivedOfficeBldgID2;
@property (weak,nonatomic) NSString * receivedOfficeRmNum1;
@property (weak,nonatomic) NSString * receivedOfficeRmNum2;
@property (weak,nonatomic) NSString * receivedPhone1;
@property (weak,nonatomic) NSString * receivedFax1;
@property (weak,nonatomic) NSString * receivedPhone2;
@property (weak,nonatomic) NSString * receivedFax2;
@property (weak,nonatomic) NSString * receivedLinkToMoreInfo;
@property (weak,nonatomic) NSString * receivedPicture;

@property (weak,nonatomic) NSString * receivedFavorite;
@property (weak,nonatomic) NSDate * receivedHistory;
@end

@implementation detailDirectoryViewController

@synthesize directoryDatabase = _directoryDatabase;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Remove the default background from my table view
    self.contactTable.backgroundColor = [UIColor clearColor];
    self.contactTable.opaque = NO;
    self.contactTable.backgroundView = nil;
    
    NSLog(@"Here is what I got: %@ (name), %@ (position), %@ (department), %@ (phone), %@ (email), %@ (website), %@ (location), %@ (image), %@ (fax), %@ (favorite), %@ (history)\n",self.receivedLName,self.receivedPosition1,self.receivedDeptID1,self.receivedPhone1,self.receivedEmail,self.receivedLinkToMoreInfo,self.receivedOfficeBldgID1,self.receivedPicture,self.receivedFax1,self.receivedFavorite,self.receivedHistory);
    
    //Combine the building and office information into something known as a location.
    NSString * location1 = [NSString stringWithFormat:@"%@ %@",self.receivedOfficeBldgID1,self.receivedOfficeRmNum1];
    NSString * location2 = [NSString stringWithFormat:@"%@ %@",self.receivedOfficeBldgID2,self.receivedOfficeRmNum2];
    location1 = [location1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    location2 = [location2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //Initialize my arrays
    tableLabel = [[NSArray alloc]initWithObjects:@"Phone1",@"Phone2",@"Email",@"Website",@"Fax1",@"Fax2",@"Location1",@"Location2",nil];
    tableContent = [[NSArray alloc]initWithObjects:self.receivedPhone1,self.receivedPhone2,self.receivedEmail,self.receivedLinkToMoreInfo,self.receivedFax1,self.receivedFax2,location1,location2,nil];
    
    //Set all of the text labels
    self.fullnameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.receivedNamePrefix,self.receivedFName,self.receivedMiddle,self.receivedLName];
    self.positionLabel.text = [NSString stringWithFormat:@"%@ | %@",self.receivedPosition1,self.receivedPosition2];
    self.department.text = [NSString stringWithFormat:@"%@ | %@",self.receivedDeptID1,self.receivedDeptID2];
    
    for(int i=0; i<[tableContent count]; i++)
    {
        NSLog(@"tableContent[%d]=%@\n",i,[tableContent objectAtIndex:i]);
        NSLog(@"tableLabel[%d]=%@\n",i,[tableLabel objectAtIndex:i]);
    }
    
    //Initialize my favorite image view
    self.favoriteView = [[UIImageView alloc] initWithFrame:CGRectMake(265, 10, 50, 50)];
    NSString *imgFilepath = [[NSBundle mainBundle] pathForResource:@"noStar" ofType:@"png"];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFilepath];
    [self.favoriteView setImage:img];
    [self.view addSubview:self.favoriteView];
    
    //Should I set the favorite photo?
    if([self.receivedFavorite isEqualToString:@"yes"])
    {
        //Put a star on the banner of this person's directory page
        //[self.view addSubview:self.favoriteView];
        [self.favoriteView setImage:[UIImage imageNamed:@"star.png"]];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
}

-(void)putEmployeeInHistory
{
    //If I hit the favorite button, I need to fetch this employee from Core Data so I can manipulate their 'Favorite' attribute
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //I only want the employee that has this current employee's name which I'm showing on the detail view
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"person_id == %@", self.receivedPersonID];
    [request setPredicate:predicate];
    
    //Alright, let's put the request into action on the "Employee" entity
    [request setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.directoryDatabase.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.directoryDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    //I should have one employee returned to me assuming names will be unique
    Employee * currentEmployee = [results objectAtIndex:0];
    
    //Store the current date in this employees history becaues this will tell me the correct order of employees for the history table
    currentEmployee.history = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterFullStyle];
    NSLog(@"Is %@ in my history? %@\n",self.receivedLName,currentEmployee.history);
}

-(void)sendEmployeeInformation:(Employee *)employeeInfo
{
    self.receivedEmail = employeeInfo.email;
    self.receivedDeptID1 = employeeInfo.dept_id_1;
    self.receivedDeptID2 = employeeInfo.dept_id_2;
    self.receivedFName = employeeInfo.fname;
    self.receivedMiddle = employeeInfo.middle;
    self.receivedLName = employeeInfo.lname;
    self.receivedPersonID = employeeInfo.person_id;
    self.receivedLastChanged = employeeInfo.last_changed;
    self.receivedPosition1 = employeeInfo.position_title_1;
    self.receivedPosition2 = employeeInfo.position_title_2;
    self.receivedNamePrefix = employeeInfo.name_prefix;
    self.receivedEmail = employeeInfo.email;
    self.receivedDeptID1 = employeeInfo.dept_id_1;
    self.receivedDeptID2 = employeeInfo.dept_id_2;
    self.receivedOfficeBldgID1 = employeeInfo.office_bldg_id_1;
    self.receivedOfficeBldgID2 = employeeInfo.office_bldg_id_2;
    self.receivedOfficeRmNum1 = employeeInfo.office_rm_num_1;
    self.receivedOfficeRmNum2 = employeeInfo.office_rm_num_2;
    self.receivedPhone1 = employeeInfo.phone1;
    self.receivedPhone2 = employeeInfo.phone2;
    self.receivedFax1 = employeeInfo.fax1;
    self.receivedFax2 = employeeInfo.fax2;
    self.receivedLinkToMoreInfo = employeeInfo.link_to_more_info;
    self.receivedPicture = employeeInfo.picture;
    self.receivedFavorite = employeeInfo.favorite;
    self.receivedHistory = employeeInfo.history;
}

-(void)downloadImage
{
    self.receivedPicture = [self.receivedPicture stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.photo setImageWithURL:[NSURL URLWithString:self.receivedPicture]
                   placeholderImage:[UIImage imageNamed:@"Unknown.jpg"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)makePhoneCall:(NSString*)phoneNumber
{
    //Remove all unwanted characters from phone number
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    //Prepare to make the call. Once call is completed, the screen will return to the app.
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Let's find out how many rows I need in my table
    showInTableContent = [[NSMutableArray alloc]init];
    showInTableLabel = [[NSMutableArray alloc]init];
    
    //I will figure out what information this person has available and place it into my showInTable array
    for(int i=0; i<[tableContent count]; i++)
    {
        if([[tableContent objectAtIndex:i] length]>0)
        {
            NSLog(@"I think I will show %@...\n",[tableContent objectAtIndex:i]);
            [showInTableContent addObject:[tableContent objectAtIndex:i]];
            [showInTableLabel addObject:[tableLabel objectAtIndex:i]];
        }
    }
    
    for(int i=0; i<[showInTableContent count]; i++)
        NSLog(@"HERE IS WHAT I WILL SHOW IN MY TABLE: %@-%@\n",[showInTableContent objectAtIndex:i],[showInTableLabel objectAtIndex:i]);
    
    NSLog(@"I think I will show %d fields!\n",[showInTableContent count]);
    return [showInTableContent count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Identifier for retrieving reusable cells.
    static NSString * cellIdentifier;
    
    NSLog(@"I'm putting my cells in the table at indexPath.row=%d\n",indexPath.row);
    
    //Is this the Add to Contacts cell? It would be the last item in the table. If there are five items to show in the table, Add to Contacts would be the at index 5 because the five table items are 0-4.
    if(indexPath.row != ([showInTableContent count]))
    {
        cellIdentifier = @"contactCell";
    }
    else
    {
        cellIdentifier = @"actionCell";
    }
    
    // Attempt to request the reusable cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Set the text of the cell to the row index.
    if(indexPath.row != [showInTableContent count])
    {
        cell.textLabel.text = [showInTableContent objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [showInTableLabel objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = @"Add to Contacts";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You pressed row with indexPath.row of %i\n",indexPath.row);
    
    if(indexPath.row == [showInTableContent count])
    {
        NSLog(@"I pressed the 'Add to Contacts' button!\n");
        [self addToContacts];
    }
    else if([[showInTableLabel objectAtIndex:indexPath.row]isEqualToString:@"Phone1"] || [[showInTableLabel objectAtIndex:indexPath.row]isEqualToString:@"Phone2"])
    {
        NSLog(@"I pressed the phone button!\n");
        //[self askUserForCallPermission];
        [self makePhoneCall:self.receivedPhone1];
    }
    else if([[showInTableLabel objectAtIndex:indexPath.row] isEqualToString:@"Email"])
    {
        if([MFMailComposeViewController canSendMail])
        {
            NSLog(@"I pressed the email button!\n");
            NSLog(@"Getting ready to write an email...\n");
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:[NSArray arrayWithObject:self.receivedEmail]];
            [controller setSubject:@""];
            NSString * openingStatement = [NSString stringWithFormat:@"%@ %@,\n\n",self.receivedNamePrefix,self.receivedLName];
            [controller setMessageBody:openingStatement isHTML:NO];
            if (controller) [self presentModalViewController:controller animated:YES];
        }
        else
        {
            NSLog(@"Oops! Can't send e-mail!");
        }
    }
}

- (void) addToContactsPressed
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            [self addToContacts];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addToContacts];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

- (void) addToContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSMutableArray *array = nil;
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    if (accessGranted) {
        [self createContact:addressBook];
    }
    else
    {
        NSLog(@"Address Book access is not granted. Please enable access to contacts in your Settings App to use this feature.");
    }
}

- (void)createContact:(ABAddressBookRef)addressBook
{
    NSLog(@"Creating a contact...\n");
    CFErrorRef error = NULL;
    ABRecordRef newPerson = ABPersonCreate();
    
    NSLog(@"Preparing name,dept,position...\n");

    ABRecordSetValue(newPerson,kABPersonFirstNameProperty,(__bridge CFTypeRef)(self.receivedFName),&error);
    ABRecordSetValue(newPerson,kABPersonMiddleNameProperty,(__bridge CFTypeRef)(self.receivedMiddle),&error);
    ABRecordSetValue(newPerson,kABPersonLastNameProperty,(__bridge CFTypeRef)(self.receivedLName),&error);

    ABRecordSetValue(newPerson,kABPersonOrganizationProperty,(__bridge CFTypeRef)(self.receivedDeptID1),&error);
    ABRecordSetValue(newPerson,kABPersonJobTitleProperty,(__bridge CFTypeRef)(self.receivedPosition1),&error);
    
    //Phone Information
    NSLog(@"Preparing phone...");
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone,(__bridge CFTypeRef)(self.receivedPhone1), kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
    CFRelease(multiPhone);
    
    //Email
    NSLog(@"Preparing email...\n");
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail,(__bridge CFTypeRef)(self.receivedEmail),kABWorkLabel,NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, nil);
    CFRelease(multiEmail);
    
    //Address
    NSLog(@"Preparing address...\n");
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary * addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:@"3410 Taft Blvd" forKey:(NSString *)kABPersonAddressStreetKey];
    [addressDictionary setObject:@"Wichita Falls" forKey:(NSString*)kABPersonAddressCityKey];
    [addressDictionary setObject:@"Texas" forKey:(NSString*)kABPersonAddressStateKey];
    [addressDictionary setObject:@"76308" forKey:(NSString*)kABPersonAddressZIPKey];
    [addressDictionary setObject:@"United States" forKey:(NSString*)kABPersonAddressCountryKey];
    
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, nil);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress, &error);
    CFRelease(multiAddress);
    
    //Actually add the person record to the phone's contact book
    NSLog(@"Saving person to contacts...\n");
    ABAddressBookAddRecord(addressBook, newPerson, &error);
    ABAddressBookSave(addressBook, &error);
    
    NSLog(@"Were there errors?\n");
    UIAlertView *alert;
    if(error != NULL)
    {
        NSLog(@"Error in my Add to Contacts! %@\n",error);
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Oops!"
                 message:@"An error occurred in the code."
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
        //send the error to the app developers!
    }
    else
    {
        NSLog(@"OK, you successfully added a contact!\n");
        NSString * dialogMessage = [NSString stringWithFormat:@"%@ %@",self.receivedNamePrefix,self.receivedLName];
        dialogMessage = [dialogMessage stringByAppendingString:@" has been added to your contacts."];
        
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Success!"
                 message:dialogMessage
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
    }
    [alert show];
    NSLog(@"Exiting functions...");
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)favoriteButton:(UIBarButtonItem *)sender
{
    //If I hit the favorite button, I need to fetch this employee from Core Data so I can manipulate their 'Favorite' attribute
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //I only want the employee that has this current employee's name which I'm showing on the detail view
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"person_id == %@", self.receivedPersonID];
    [request setPredicate:predicate];
    
    //Alright, let's put the request into action on the "Employee" entity
    [request setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.directoryDatabase.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.directoryDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    //I should have one employee returned to me assuming names will be unique
    Employee * currentEmployee = [results objectAtIndex:0];
    
    if([currentEmployee.favorite isEqualToString:@"no"])
    {
        NSLog(@"%@ favorite employee: no\n",self.receivedLName);
        currentEmployee.favorite = @"yes";
        
        //Put a star on the banner of this person's directory page
        //[self.view addSubview:self.favoriteView];
        [self.favoriteView setImage:[UIImage imageNamed:@"star.png"]];
    }
    else
    {
        NSLog(@"%@ favorite employee: yes\n",self.receivedLName);
        currentEmployee.favorite = @"no";
        [self.favoriteView setImage:[UIImage imageNamed:@"noStar.png"]];
        
    }
    //Save!!!
    //[self.directoryDatabase updateChangeCount:UIDocumentChangeDone];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[cell detailTextLabel] setTextColor:[UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1]];
    /*
    cell.backgroundColor = [UIColor grayColor];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoFrame.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoFrame.png"]];
     */
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //if my directory database is nil
    if(!self.directoryDatabase)
    {
        [[MYDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.directoryDatabase = document;
            
            //Do stuff with the document, set up a fetched results controller, whatever.
            //THE PAUL HEGARTY STUFF WILL TAKE OVER FROM HERE.
        }];
    }
    else{
        NSLog(@"Yes it is, do nothing...\n");
    }
    //Since I visited this person, I should put them into my history
    NSLog(@"%@ history is %@\n",self.receivedLName,self.receivedHistory);
    if(!self.receivedHistory)
    {
        //Going to put this person into my history
        NSLog(@"Going to put this person into my history...\n");
        [self putEmployeeInHistory];
    }
}
@end
