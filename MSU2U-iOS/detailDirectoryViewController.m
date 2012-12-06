//
//  detailDirectoryViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/4/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailDirectoryViewController.h"

@interface detailDirectoryViewController ()
@property (weak,nonatomic) NSString * receivedName;
@property (weak,nonatomic) NSString * receivedPosition;
@property (weak,nonatomic) NSString * receivedDepartment;
@property (weak,nonatomic) NSString * receivedPhone;
@property (weak,nonatomic) NSString * receivedEmail;
@property (weak,nonatomic) NSString * receivedWebsite;
@property (weak,nonatomic) NSString * receivedLocation;
@property (weak,nonatomic) NSString * receivedImage;
@property (weak,nonatomic) NSString * receivedFax;
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
    
    //Initialize my arrays
    tableLabel = [[NSArray alloc]initWithObjects:@"phone",@"email",@"website",@"fax",@"location",nil];
    
    NSLog(@"Here is what I got: %@ (name), %@ (position), %@ (department), %@ (phone), %@ (email), %@ (website), %@ (location), %@ (image), %@ (fax), %@ (favorite), %@ (history)\n",self.receivedName,self.receivedPosition,self.receivedDepartment,self.receivedPhone,self.receivedEmail,self.receivedWebsite,self.receivedLocation,self.receivedImage,self.receivedFax,self.receivedFavorite,self.receivedHistory);
    
    tableContent = [[NSArray alloc]initWithObjects:self.receivedPhone,self.receivedEmail,self.receivedWebsite,self.receivedFax,self.receivedLocation,nil];
    
    //Set all of the text labels
    self.fullnameLabel.text = self.receivedName;
    self.positionLabel.text = self.receivedPosition;
    self.department.text = self.receivedDepartment;
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullname == %@", self.receivedName];
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
    NSLog(@"Is %@ in my history? %@\n",currentEmployee.fullname,currentEmployee.history);
}

-(void)sendEmployeeInformation:(Employee *)employeeInfo
{
    self.receivedEmail = employeeInfo.email;
    self.receivedDepartment = employeeInfo.department;
    self.receivedName = employeeInfo.fullname;
    self.receivedImage = employeeInfo.image;
    self.receivedPosition = employeeInfo.position;
    self.receivedLocation = employeeInfo.location;
    self.receivedWebsite = employeeInfo.website;
    self.receivedFax = employeeInfo.fax;
    self.receivedPhone = employeeInfo.phone;
    self.receivedFavorite = employeeInfo.favorite;
    self.receivedHistory = employeeInfo.history;
    
    //Makek sure none of these are empty
    if([self.receivedEmail length] == 0)self.receivedEmail = @"N/A";
    if([self.receivedLocation length] == 0)self.receivedLocation = @"N/A";
    if([self.receivedWebsite length] == 0)self.receivedWebsite = @"N/A";
    if([self.receivedFax length] == 0)self.receivedFax = @"N/A";
    if([self.receivedPhone length] == 0)self.receivedPhone = @"N/A";
}

-(void)downloadImage
{
    self.receivedImage = [self.receivedImage stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.photo setImageWithURL:[NSURL URLWithString:self.receivedImage]
                   placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)makePhoneCall
{
    //Remove all unwanted characters from phone number
    NSString *cleanedString = [[self.receivedPhone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Identifier for retrieving reusable cells.
    static NSString *cellIdentifier = @"contactCell";
    
    // Attempt to request the reusable cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Set the text of the cell to the row index.
    cell.textLabel.text = [tableContent objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [tableLabel objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You pressed row with indexPath.row of %i\n",indexPath.row);
    if(indexPath.row == 0)
    {
        NSLog(@"I pressed the phone button!\n");
        //[self askUserForCallPermission];
        [self makePhoneCall];
    }
    else if(indexPath.row == 1)
    {
        if([MFMailComposeViewController canSendMail])
        {
            NSLog(@"I pressed the email button!\n");
            NSLog(@"Getting ready to write an email...\n");
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:[NSArray arrayWithObject:self.receivedEmail]];
            [controller setSubject:@""];
            NSString * openingStatement = self.receivedName;
            openingStatement = [openingStatement stringByAppendingString:@",\n\n"];
            [controller setMessageBody:openingStatement isHTML:NO];
            if (controller) [self presentModalViewController:controller animated:YES];
        }
        else
        {
            NSLog(@"Oops! Can't send e-mail!");
        }
    }
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fullname == %@", self.receivedName];
    [request setPredicate:predicate];
    
    //Alright, let's put the request into action on the "Employee" entity
    [request setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.directoryDatabase.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.directoryDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    //I should have one employee returned to me assuming names will be unique
    Employee * currentEmployee = [results objectAtIndex:0];
    
    if([currentEmployee.favorite isEqualToString:@"no"])
    {
        NSLog(@"%@ favorite employee: no\n",self.receivedName);
        currentEmployee.favorite = @"yes";
        
        //Put a star on the banner of this person's directory page
        //[self.view addSubview:self.favoriteView];
        [self.favoriteView setImage:[UIImage imageNamed:@"star.png"]];
    }
    else
    {
        NSLog(@"%@ favorite employee: yes\n",self.receivedName);
        currentEmployee.favorite = @"no";
        [self.favoriteView setImage:[UIImage imageNamed:@"noStar.png"]];
        
    }
    //Save!!!
    //[self.directoryDatabase updateChangeCount:UIDocumentChangeDone];
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
    NSLog(@"%@ history is %@\n",self.receivedName,self.receivedHistory);
    if(!self.receivedHistory)
    {
        //Going to put this person into my history
        NSLog(@"Going to put this person into my history...\n");
        [self putEmployeeInHistory];
    }
}
@end
