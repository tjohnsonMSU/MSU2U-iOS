//
//  detailDirectoryViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/4/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailDirectoryViewController.h"

@interface detailDirectoryViewController ()
@end

@implementation detailDirectoryViewController

@synthesize directoryDatabase = _directoryDatabase;

- (void)setTableViewBackgroundToColor:(UIColor*)color
{
    //Remove the default background from my table view
    self.contactTable.backgroundColor = color;
    self.contactTable.opaque = NO;
    self.contactTable.backgroundView = nil;
}

- (NSString*)initalizeIfEmpty:(NSString*)x
{
    if([x length] == 0)
        x = @"";
    return x;
}

- (void)initalizedEmptyVariables
{
    if([myCurrentEmployee.website1 length] == 0)
        myCurrentEmployee.website1 = @"";
    if([myCurrentEmployee.website2 length] == 0)
        myCurrentEmployee.website2 = @"";
    
    //Only need to check the first ones because if the seconds didn't exist, they've already been initialized to @""
    if([myCurrentEmployee.phone1 length] == 0)
        myCurrentEmployee.phone1 = @"";
    if([myCurrentEmployee.fax1 length] == 0)
        myCurrentEmployee.fax1 = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the background of the table view to be transparent
    [self setTableViewBackgroundToColor:[UIColor clearColor]];
    
    //Combine the building and office information into something known as a location.
    NSString * location1 = [myCurrentEmployee getLocation:1];
    NSString * location2 = [myCurrentEmployee getLocation:2];
    
    //Initialize my table content and label arrays. These are critical because they contain the information that the table will display.
    
    //Initlalized unreceived variables
    if([myCurrentEmployee.website1 length] == 0)
        myCurrentEmployee.website1 = @"";
    if([myCurrentEmployee.website2 length] == 0)
        myCurrentEmployee.website2 = @"";
    
    tableLabel = [[NSArray alloc]initWithObjects:@"Phone1",@"Phone2",@"Email",@"Fax1",@"Fax2",@"Website1",@"Website2",@"Location1",@"Location2",nil];
    tableContent = [[NSArray alloc]initWithObjects:myCurrentEmployee.phone1,myCurrentEmployee.phone2,myCurrentEmployee.email,myCurrentEmployee.fax1,myCurrentEmployee.fax2,myCurrentEmployee.website1,myCurrentEmployee.website2,location1,location2,nil];
    
    //Set the name label for this person
    self.fullnameLabel.text = [myCurrentEmployee getFullName];
    
    //Format the position and department lables appropriately: if there are two positions/departsments, show a '|' between them. Otherwise, don't print a '|'.
    self.positionLabel.text = [myCurrentEmployee getPositions];
    self.department.text = [myCurrentEmployee getDepartments];
    
    //Initialize my favorite image view
    [self favoriteImageViewInitialization];
    
    //Download image for person off of the main UI thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
}

-(void)favoriteImageViewInitialization
{
    //First, allocate the view and set the view to show nothing
    self.favoriteView = [[UIImageView alloc] initWithFrame:CGRectMake(265, 10, 50, 50)];
    NSString *imgFilepath = [[NSBundle mainBundle] pathForResource:@"noStar" ofType:@"png"];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgFilepath];
    [self.favoriteView setImage:img];
    [self.view addSubview:self.favoriteView];
    
    //Should I change the favorite image view to show a star?
    if([myCurrentEmployee.favorite isEqualToString:@"yes"])
    {
        //Put a star on the banner of this person's directory page
        //[self.view addSubview:self.favoriteView];
        [self.favoriteView setImage:[UIImage imageNamed:@"star.png"]];
    }
}

-(void)putEmployeeInHistory
{
    //If I select this individual in my Directory search list, I need to fetch this employee from Core Data so I can manipulate their 'historty' attribute
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //I only want the employee that has this current employee's name which I'm showing on the detail view
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"person_id like[c] %@", myCurrentEmployee.person_id];
    [request setPredicate:predicate];
    
    //Alright, let's put the request into action on the "Employee" entity
    [request setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.directoryDatabase.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.directoryDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    //I should have one employee returned to me assuming 'person_id' will be unique
    Employee * currentEmployee = [results objectAtIndex:0];
    
    //Store the current date in this employees history becaues this will tell me the correct order of employees for the history table
    currentEmployee.history = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterFullStyle];
}

-(void)sendEmployeeInformation:(Employee *)employeeInfo
{
    //Very important that 'myCurrentEmployee' gets initialized here! employeeInfo was sent from the Directory Search view.
    myCurrentEmployee = employeeInfo;
    [myCurrentEmployee printMyInfo];
}

-(void)downloadImage
{
    NSString * pictureURL = [myCurrentEmployee.picture stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.photo setImageWithURL:[NSURL URLWithString:pictureURL]
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
            [showInTableContent addObject:[tableContent objectAtIndex:i]];
            [showInTableLabel addObject:[tableLabel objectAtIndex:i]];
        }
    }

    return [showInTableContent count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Identifier for retrieving reusable cells.
    static NSString * cellIdentifier;
    
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
    //LAST ROW always
    if(indexPath.row == [showInTableContent count])
        [self addToContacts];
    else if([[showInTableLabel objectAtIndex:indexPath.row]isEqualToString:@"Phone1"] || [[showInTableLabel objectAtIndex:indexPath.row]isEqualToString:@"Phone2"])
        [self makePhoneCall:myCurrentEmployee.phone1];
    else if([[showInTableLabel objectAtIndex:indexPath.row] isEqualToString:@"Email"])
    {
        if([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:[NSArray arrayWithObject:myCurrentEmployee.email]];
            [controller setSubject:@""];
            
            //TODO Should format this better
            NSString * openingStatement = [NSString stringWithFormat:@"Greetings %@,",[myCurrentEmployee getShortenedName]];
            
            [controller setMessageBody:openingStatement isHTML:NO];
            if (controller) [self presentModalViewController:controller animated:YES];
        }
        else
        {
            //do nothing
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
        //do nothing
    }
}

- (void)createContact:(ABAddressBookRef)addressBook
{
    CFErrorRef error = NULL;
    ABRecordRef newPerson = ABPersonCreate();

    ABRecordSetValue(newPerson,kABPersonFirstNameProperty,(__bridge CFTypeRef)(myCurrentEmployee.fname),&error);
    ABRecordSetValue(newPerson,kABPersonMiddleNameProperty,(__bridge CFTypeRef)(myCurrentEmployee.middle),&error);
    ABRecordSetValue(newPerson,kABPersonLastNameProperty,(__bridge CFTypeRef)(myCurrentEmployee.lname),&error);

    ABRecordSetValue(newPerson,kABPersonOrganizationProperty,(__bridge CFTypeRef)(myCurrentEmployee.position_title_1),&error);
    ABRecordSetValue(newPerson,kABPersonJobTitleProperty,(__bridge CFTypeRef)(myCurrentEmployee.position_title_2),&error);
    
    //Phone Information: TODO I should also add the second phone if there is one
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone,(__bridge CFTypeRef)(myCurrentEmployee.phone1), kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
    CFRelease(multiPhone);
    
    //Email
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail,(__bridge CFTypeRef)(myCurrentEmployee.email),kABWorkLabel,NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, nil);
    CFRelease(multiEmail);
    
    //Address: TODO Do all personnel have the same mailing address? Should there be some sort of ATTENTION?
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
    ABAddressBookAddRecord(addressBook, newPerson, &error);
    ABAddressBookSave(addressBook, &error);
    
    UIAlertView *alert;
    if(error != NULL)
    {
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
        NSString * dialogMessage = [myCurrentEmployee getShortenedName];
        dialogMessage = [dialogMessage stringByAppendingString:@" has been added to your contacts."];
        
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Success!"
                 message:dialogMessage
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
    }
    [alert show];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"person_id == %@", myCurrentEmployee.person_id];
    [request setPredicate:predicate];
    
    //Alright, let's put the request into action on the "Employee" entity
    [request setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.directoryDatabase.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.directoryDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    //I should have one employee returned to me assuming names will be unique
    Employee * currentEmployee = [results objectAtIndex:0];
    
    if([currentEmployee.favorite isEqualToString:@"no"])
    {
        currentEmployee.favorite = @"yes";
        
        //Put a star on the banner of this person's directory page
        //[self.view addSubview:self.favoriteView];
        [self.favoriteView setImage:[UIImage imageNamed:@"star.png"]];
    }
    else
    {
        currentEmployee.favorite = @"no";
        [self.favoriteView setImage:[UIImage imageNamed:@"noStar.png"]];
        
    }
    //Save!!!
    //[self.directoryDatabase updateChangeCount:UIDocumentChangeDone];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    }
    //Since I visited this person, I should put them into my history
    if(!myCurrentEmployee.history)
    {
        //Going to put this person into my history
        [self putEmployeeInHistory];
    }
}
@end
