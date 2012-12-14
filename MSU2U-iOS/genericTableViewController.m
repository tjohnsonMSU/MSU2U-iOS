//
//  genericTableViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/23/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "genericTableViewController.h"

@interface genericTableViewController ()

@end

@implementation genericTableViewController

//######################################################################################
//#                 PAUL HEGARTY CORE DATA STUFF
//######################################################################################

//for sure
- (NSArray *)executeDataFetch:(NSString *)query
{
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}

- (NSArray *)downloadCurrentData:(NSString*)jsonURL
{
    NSString *request = [NSString stringWithFormat:jsonURL];
    return [self executeDataFetch:request];
}

-(void)fetchDataFromOnline:(UIManagedDocument*)document
{
    NSLog(@"I'm in fetchDataFromOnline...\n");
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Data Fetcher", NULL);
    
    dispatch_async(fetchQ,^{
        NSLog(@"I'm in the dispatch_async...\n");
        
        NSArray * myData = [self downloadCurrentData:self.jsonURL];
        
        //I'm blocking because I'm in the directory fetcher thread, and I can't otherwise access the context because it was created in a different thread.
        [document.managedObjectContext performBlock:^{
            for(NSDictionary * dataInfo in myData)
            {
                NSLog(@"in the for loop.... inserting data into my database...\n");
                
                //DEPENDS ON THE CHILD THAT I'M WORKING WITH
                if(self.childNumber == [NSNumber numberWithInt:1])
                    [Sport sportWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                else if(self.childNumber == [NSNumber numberWithInt:2])
                    [Event eventWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                else if(self.childNumber == [NSNumber numberWithInt:3])
                    [News newsWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                else if(self.childNumber == [NSNumber numberWithInt:4])
                    [Employee employeeWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
            }
        }];
    });
    NSLog(@"I'm leaving fetchDataFromOnline...\n");
}

-(void)setupFetchedResultsController
{
    //Setting up the Fetched Results Controller
    NSLog(@"I'm in setupFetchedResultsController...childNumber %@\n",self.childNumber);
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    
    //DIRECTORY FAVORITES AND DIRECTORY HISTORY SHOULD HAVE A FILTER THAT RESTRICTS THE DATA IN MY TABLE
    if(self.childNumber == [NSNumber numberWithInt:5])
    {
        //DIRECTORY FAVORITES = 5
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"favorite LIKE[c] 'yes'"];
        [request setPredicate:predicate];
    }
    else if(self.childNumber == [NSNumber numberWithInt:6])
    {
        //DIRECTORY HISTORY = 6
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"history != nil"];
        [request setPredicate:predicate];
    }
    //Filter News/Sports/Events Tables based upon user defaults?
    else if(self.childNumber == [NSNumber numberWithInt:3])
    {
        //Check the user defaults
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        //CHECK THE SWITCHES. SEE WHAT PREDICATE I SHOULD APPLY TO THESE TABLES!
        NSString * myPredicate = @"";
        
        if([defaults boolForKey:@"wichitanNewsIsOn"])
        {
            myPredicate = [myPredicate stringByAppendingString:@"publication LIKE[c] 'The Wichitan'"];
        }
        if([defaults boolForKey:@"sportsNewsIsOn"])
        {
            //If I already started my predicate string, then I need to concatenate ||.
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"publication LIKE[c] 'Sports News'"];
        }
        if([defaults boolForKey:@"campusNewsIsOn"])
        {
            //If I already started my predicate string, then I need to concatenate ||.
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"publication LIKE[c] 'Campus News'"];
        }
        NSLog(@"My constructed predicate is %@\n",myPredicate);
        
        //Only if I actually added some text to myPredicate due to a switch being on will I set my request's predicate.
        if([myPredicate length] == 0)
        {
            //There is no such thing as a sport of type "NOTHING" so effectively this will return no one, which is what I want
            //  since all of the news switches have been disable.
            myPredicate = [myPredicate stringByAppendingString:@"publication LIKE[c] 'NOTHING'"];
        }
        
        //set the predicate to your constructed predicate string
        NSPredicate * predicate = [NSPredicate predicateWithFormat:myPredicate];
        [request setPredicate:predicate];
    }
    else if(self.childNumber == [NSNumber numberWithInt:2])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * myPredicate = @"";
        
        if([defaults boolForKey:@"artIsOn"])
        {
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'art'"];
        }
        if([defaults boolForKey:@"academicIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'academic'"];
        }
        if([defaults boolForKey:@"campusIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'campus'"];
        }
        if([defaults boolForKey:@"museumIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'museum'"];
        }
        if([defaults boolForKey:@"musicIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'music'"];
        }
        if([defaults boolForKey:@"personnelIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'personnel'"];
        }
        if([defaults boolForKey:@"theaterIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'theater'"];
        }
        NSLog(@"My constructed predicate is %@\n",myPredicate);
        
        if([myPredicate length] == 0)
        {
            //There is no such thing as a sport of type "NOTHING" so effectively this will return no one, which is what I want
            //  since all of the news switches have been disable.
            myPredicate = [myPredicate stringByAppendingString:@"category LIKE[c] 'NOTHING'"];
        }
        
        //set the predicate to your constructed predicate string
        NSPredicate * predicate = [NSPredicate predicateWithFormat:myPredicate];
        [request setPredicate:predicate];
    }
    else if(self.childNumber == [NSNumber numberWithInt:1])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString * myPredicate = @"";
        
        if([defaults boolForKey:@"crossCountryIsOn"])
        {
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE [c] 'Cross Country'"];
        }
        if([defaults boolForKey:@"basketballMenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'BasketballMen'"];
        }
        if([defaults boolForKey:@"basketballWomenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'BasketballWomen'"];
        }
        if([defaults boolForKey:@"footballIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'Football'"];
        }
        if([defaults boolForKey:@"golfMenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'GolfMen'"];
        }
        if([defaults boolForKey:@"golfWomenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'GolfWomen'"];
        }
        if([defaults boolForKey:@"soccerMenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'SoccerMen'"];
        }
        if([defaults boolForKey:@"soccerWomenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'SoccerWomen'"];
        }
        if([defaults boolForKey:@"softballIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'Softball'"];
        }
        if([defaults boolForKey:@"tennisMenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'TennisMen'"];
        }
        if([defaults boolForKey:@"tennisWomenIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'TennisWomen'"];
        }
        if([defaults boolForKey:@"volleyballIsOn"])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'Volleyball'"];
        }
        NSLog(@"My constructed predicate is %@\n",myPredicate);

        if([myPredicate length] == 0)
        {
            //There is no such thing as a sport of type "NOTHING" so effectively this will return no one, which is what I want
            //  since all of the news switches have been disable.
            myPredicate = [myPredicate stringByAppendingString:@"sportType LIKE[c] 'NOTHING'"];
        }
        
        //set the predicate to your constructed predicate string
        NSPredicate * predicate = [NSPredicate predicateWithFormat:myPredicate];
        [request setPredicate:predicate];
    }
    
    //Fetch all of the data. Be sure to sort the data correctly depending on which child is currently being viewed
    if(self.childNumber != [NSNumber numberWithInt:6])
    {
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    else
    {
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    //This is where we've captured the necessary data in our fetched results controller from our Core Data. All of the table view delegate methods
    //  will work with the data locaed within the fetchedResultsController. If we have no data in core data, then we'll download it first.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.myDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSLog(@"I'm leaving setupFetchedResultsController...\n");
    
    //Making sure I have information in my database already. If not, then I should download!
    if([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0)
    {
        NSLog(@"There were 0 objects in my table... I will attempt an update from online!\n");
        
        //IF I'M IN DIRECTORY FAVORITES (5) OR DIRECTORY HISTORY (6), I DON'T WANT TO DOWNLOAD ANYTHING!
        if(self.childNumber != [NSNumber numberWithInt:5] && self.childNumber != [NSNumber numberWithInt:6])
        {
            [self fetchDataFromOnline:self.myDatabase];
        }
    }
    else
    {
        //I know there are items in the database already.
        NSLog(@"Looks like I have data already in my database, I'll just load what I've got.\n");
    }
}

-(void)useDocument
{
    NSLog(@"I'm in useDocument...\n");
    
    //Does my file not exist yet?
    if(![[NSFileManager defaultManager]fileExistsAtPath:[self.myDatabase.fileURL path]])
    {
        NSLog(@"genericViewController: I need to fetch items from online...\n");
        [self.myDatabase saveToURL:self.myDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             NSLog(@"genericViewController: Database does not exist yet...\n");
             [self setupFetchedResultsController];
         }];
    }
    //What if my document is closed?
    else if(self.myDatabase.documentState == UIDocumentStateClosed)
    {
        NSLog(@"genericViewDirectory: My document is closed...\n");
        [self.myDatabase openWithCompletionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
         }];
    }
    //What if my document is already open?
    else if(self.myDatabase.documentState == UIDocumentStateNormal)
    {
        NSLog(@"genericViewDirectory: My document is already open...\n");
        [self setupFetchedResultsController];
    }
    else
    {
        NSLog(@"Well, it seems it is neither closed, opened, or non-existent. Therefore, it exists... yet it is not closed or opened?\n");
        NSLog(@"I'll assume it doesn't exist yet.\n");
    }
}

-(void)setMyDatabase:(UIManagedDocument *)myDatabase
{
    NSLog(@"genericViewController: I'm setting the database!\n");
    //If someone sets this document externally, I need to start using it.
    //In the setter, anytime someone sets this (as long as it has changed), then set it.
    if(_myDatabase != myDatabase)
    {
        _myDatabase = myDatabase;
        [self useDocument];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //Identify in the output window what method I am in for debuggin purposes
    NSLog(@"genericViewController: View will appear\n");
    
    //Should I setup any navigation bar buttons for this view? Put all of the rules here for your table view controllers
    if(self.childNumber == [NSNumber numberWithInt:4])
    {
        //Don't show a bar button item for these views
        NSLog(@"I don't want to show a bar button item in the top right corner because this is childNumber=%@\n",self.childNumber);
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else if(self.childNumber == [NSNumber numberWithInt:5] || self.childNumber == [NSNumber numberWithInt:6])
    {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                         style:UIBarButtonSystemItemDone target:self action:@selector(clearMyTable)];
        self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    }
    else if(self.childNumber == [NSNumber numberWithInt:1] || self.childNumber == [NSNumber numberWithInt:2] || self.childNumber == [NSNumber numberWithInt:3])
    {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Subscribe"
                                                       style:UIBarButtonSystemItemDone target:self action:@selector(goToMySubscriptionView)];
        self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    }
    else
    {
        NSLog(@"Hm, I didn't even try a bar button item. My childNumber=%@\n",self.childNumber);
    }
    
    //Setup the arrays which will be used to hold the Core Data for the respective Table View Controller
    self.dataArray = [[NSMutableArray alloc]initWithObjects:nil];
    self.filteredDataArray = [[NSMutableArray alloc]initWithObjects:nil];
    
    //I did have the [super viewWillAppear:animated]; right here before.
    
    if(!self.myDatabase)
    {
        [[MYDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.myDatabase = document;
        }];
        NSLog(@"OK, I am at the statement right after I try to get a document from MYDocumentHandler\n");
    }
    else
    {
        NSLog(@"I already have a managed docoument for this view.\n");
        [self setupFetchedResultsController];
    }
}

-(void)makeSureUserWantsToClearTable
{
    NSString * viewIamAt;
    
    //If the user is clearing the favorites table...
    if(self.childNumber == [NSNumber numberWithInt:5]){viewIamAt = @"favorites";}
    //If the user is clearing the history table...
    else if(self.childNumber == [NSNumber numberWithInt:6]){viewIamAt = @"history";}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear the table" message:@"Do you want to remove all employees in your %@?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

//Perform the action that the user chose from the UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"I pressed button 1");
    }
}

-(void)goToMySubscriptionView
{
    NSLog(@"gotToMySubscriptionView\n");
    
    //Segue over to the subscription view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITableViewController *yourViewController = (UITableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"subscriptionView"];
    [self.navigationController pushViewController:yourViewController animated:YES];
    
}

-(void) clearMyTable
{
    //If I hit the clear button, I need to fetch this employee from Core Data so I can manipulate their 'Favorite' attribute
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //I only want the employee that has this current employee's name which I'm showing on the detail view
    //DIRECTORY FAVORITES AND DIRECTORY HISTORY SHOULD HAVE A FILTER THAT RESTRICTS THE DATA IN MY TABLE
    if(self.childNumber == [NSNumber numberWithInt:5])
    {
        //DIRECTORY FAVORITES = 5
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"favorite LIKE[c] 'yes'"];
        [request setPredicate:predicate];
    }
    else if(self.childNumber == [NSNumber numberWithInt:6])
    {
        //DIRECTORY HISTORY = 6
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"history != nil"];
        [request setPredicate:predicate];
    }
    
    //Alright, let's put the request into action on the "Employee" entity
    [request setEntity:[NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.myDatabase.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *results = [self.myDatabase.managedObjectContext executeFetchRequest:request error:&error];
    
    //Get all of the data that satisfies my request
    if(self.childNumber == [NSNumber numberWithInt:5])
    {
        for(Employee * currentEmployee in results)
        {
            if([currentEmployee.favorite isEqualToString:@"yes"])
            {
                NSLog(@"%@ is being changed from favorite 'yes' to \n",currentEmployee.fullname);
                currentEmployee.favorite = @"no";
                NSLog(@"no");
            }
        }
    }
    else if(self.childNumber == [NSNumber numberWithInt:6])
    {
        for(Employee * currentEmployee in results)
        {
            if(currentEmployee.history)
            {
                NSLog(@"%@ is being changed from %@ to \n",currentEmployee.fullname,currentEmployee.history);
                currentEmployee.history = nil;
                NSLog(@"nil");
            }
        }
    }
    //Save!!!
    //[self.directoryDatabase updateChangeCount:UIDocumentChangeDone];
}

//######################################################################################
//#                 TABLE VIEW STUFF
//######################################################################################
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"genericViewController: numberOfRowsInSection=");
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        NSLog(@"searchDisplayController has %u rows\n",[self.filteredDataArray count]);
        return [self.filteredDataArray count];
    }
	else
	{
        int count = 0;
        if(self.childNumber == [NSNumber numberWithInt:1])
        {
            for (Sport * currentSports in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:2])
        {
            for (Event * currentEvents in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:3])
        {
            for (News * currentNews in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:4])
        {
            NSLog(@"My child number is %@",self.childNumber);
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:5])
        {
            NSLog(@"My child number is %@",self.childNumber);
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:6])
        {
            NSLog(@"My child number is %@",self.childNumber);
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        NSLog(@"Regular table has %i rows\n",count);
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"genericViewController: cellForRowAtIndexPath\n");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.cellIdentifier];
    }
    
    //A generic object, whether it's a news, sports, employee, etc., this will work for any situation
    self.dataObject = nil;
    
    // Check to see whether the normal table or search results table is being displayed and set the employee object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        self.dataObject = [self.filteredDataArray objectAtIndex:[indexPath row]];
    }
	else
	{
        self.dataObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if(self.childNumber == [NSNumber numberWithInt:1] || self.childNumber == [NSNumber numberWithInt:2] || self.childNumber == [NSNumber numberWithInt:3])
    {
        //Sports, News, and Events all have titles and contents to show in their cell
        cell.textLabel.text = [self.dataObject title];
        cell.detailTextLabel.text = [self.dataObject content];
        
        //THIS IS A NEWS CELL, SO LET'S FIGURE OUT WHICH IMAGE TO SHOW IN THE CELL ROW
        if(self.childNumber == [NSNumber numberWithInt:3])
        {
            if([[self.dataObject publication] isEqualToString:@"The Wichitan"])
            {
                cell.imageView.image = [UIImage imageNamed:@"theWichitan.jpg"];
            }
            else if([[self.dataObject publication] isEqualToString:@"Campus News"])
            {
                cell.imageView.image = [UIImage imageNamed:@"140-gradhat.png"];
            }
            else if([[self.dataObject publication] isEqualToString:@"Sports News"])
            {
                cell.imageView.image = [UIImage imageNamed:@"101-gameplan.png"];
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:1])
        {
            if([[self.dataObject sportType] isEqualToString:@"Football"])
                cell.imageView.image = [UIImage imageNamed:@"football.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"Volleyball"])
                cell.imageView.image = [UIImage imageNamed:@"volleyball.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"Softball"])
                cell.imageView.image = [UIImage imageNamed:@"softball.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"BasketballMen"] || [[self.dataObject sportType] isEqualToString:@"BasketballWomen"])
                cell.imageView.image = [UIImage imageNamed:@"basketball.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"TennisMen"] || [[self.dataObject sportType] isEqualToString:@"TennisWomen"])
                cell.imageView.image = [UIImage imageNamed:@"tennis.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"SoccerMen"] || [[self.dataObject sportType] isEqualToString:@"SoccerWomen"])
                cell.imageView.image = [UIImage imageNamed:@"soccer.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"Cross Country"])
                cell.imageView.image = [UIImage imageNamed:@"crossCountry.jpeg"];
            else if([[self.dataObject sportType] isEqualToString:@"GolfMen"] || [[self.dataObject sportType] isEqualToString:@"GolfWomen"])
                cell.imageView.image = [UIImage imageNamed:@"golf.jpeg"];
        }
        else if(self.childNumber == [NSNumber numberWithInt:2])
        {
            if([[self.dataObject category] isEqualToString:@"art"])
            {
                cell.imageView.image = [UIImage imageNamed:@"art.jpeg"];
            }
            else if([[self.dataObject category] isEqualToString:@"campus"])
            {
                cell.imageView.image = [UIImage imageNamed:@"campus.jpeg"];
            }
            else if([[self.dataObject category] isEqualToString:@"personnel"])
            {
                cell.imageView.image = [UIImage imageNamed:@"personnel.jpeg"];
            }
            else if([[self.dataObject category] isEqualToString:@"music"])
            {
                cell.imageView.image = [UIImage imageNamed:@"music.jpeg"];
            }
            else if([[self.dataObject category] isEqualToString:@"theater"])
            {
                cell.imageView.image = [UIImage imageNamed:@"theater.jpeg"];
            }
            else if([[self.dataObject category] isEqualToString:@"academic"])
            {
                cell.imageView.image = [UIImage imageNamed:@"academic.jpeg"];
            }
            else if([[self.dataObject category] isEqualToString:@"museum"])
            {
                cell.imageView.image = [UIImage imageNamed:@"museum.jpeg"];
            }
        }
    }
    else if(self.childNumber == [NSNumber numberWithInt:4] || self.childNumber == [NSNumber numberWithInt:5] || self.childNumber == [NSNumber numberWithInt:6])
    {
        NSLog(@"I must be a directory item...childNumber %@\n",self.childNumber);
        //Directory cells, Directory Favorites, and Directory History
        cell.textLabel.text = [self.dataObject fullname];
        cell.detailTextLabel.text = [self.dataObject position];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform segue to candy detail
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:self.segueIdentifier sender:tableView];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"I'm preparing for a segue to %@\n",self.segueIdentifier);
    
    self.dataObject = nil;
    
    if(sender == self.searchDisplayController.searchResultsTableView)
    {
        NSLog(@"search display row...\n");
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        self.dataObject = [self.filteredDataArray objectAtIndex:[indexPath row]];
    }
    else
    {
        NSLog(@"main display row...\n");
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        self.dataObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    NSLog(@"Sending data to detail view controller...\n");
    //Send the JSON data to the detail view controller
    
    if(self.childNumber == [NSNumber numberWithInt:1])
        [segue.destinationViewController sendSportInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:2])
        [segue.destinationViewController sendEventInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:3])
        [segue.destinationViewController sendNewsInformation:self.dataObject];
    else if(self.childNumber >= [NSNumber numberWithInt:4])
        [segue.destinationViewController sendEmployeeInformation:self.dataObject];
}



//######################################################################################
//#                 Search Display Controller Delegate Methods
//######################################################################################
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredDataArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    
    //Put all of the current relevant data (depending on the current tab) into a mutable array
    
    //DEPENDS ON THE CHILD I'M WORKING WITH
    //Sports Tab
    if(self.childNumber == [NSNumber numberWithInt:1])
    {
        for (Sport *currentSports in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentSports];
    }
    //Events Tab
    else if(self.childNumber == [NSNumber numberWithInt:2])
    {
        for (Event *currentEvents in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentEvents];
    }
    //News Tab
    else if(self.childNumber == [NSNumber numberWithInt:3])
    {
        for (News *currentNews in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentNews];
    }
    //Directory Search Tab
    else if(self.childNumber == [NSNumber numberWithInt:4])
    {
        for (Employee *currentEmployees in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentEmployees];
    }
    //Directory Favorites Tab
    else if(self.childNumber == [NSNumber numberWithInt:5])
    {
        for (Employee *currentEmployees in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentEmployees];
    }
    //Directory History Tab
    else if(self.childNumber == [NSNumber numberWithInt:6])
    {
        for (Employee *currentEmployees in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentEmployees];
    }
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@",self.keyToSearchOn,searchText];
    NSArray *tempArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    
    /* ==ONLY NECESSARY IF YOU ARE USING BUTTONS BELOW THE SEARCH BAR TO CHOOSE GENERAL CATEGORY (SEARCH KEYWORDS)
     if(![scope isEqualToString:@"All"]) {
     // Further filter the array with the scope
     NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
     tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
     }
     */
    
    self.filteredDataArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Search Button

/*
 - (IBAction)goToSearch:(id)sender
 {
 // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
 // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
 [self.searchBar becomeFirstResponder];
 }
 */

@end
