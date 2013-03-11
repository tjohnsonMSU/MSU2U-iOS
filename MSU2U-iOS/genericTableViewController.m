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
    if (error)
    {
        //do nothing
    }
    //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    
    
    return results;
}

- (NSArray *)downloadCurrentData:(NSString*)jsonURL
{
    
    
    NSString *request = [NSString stringWithFormat:jsonURL];
    
    
    
    return [self executeDataFetch:request];
}

-(void)fetchDataFromOnline:(UIManagedDocument*)document
{
    
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Data Fetcher", NULL);
    
    dispatch_async(fetchQ,^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self.refreshControl beginRefreshing];
            hud.labelText = @"Downloading...";
            NSArray * myData = [self downloadCurrentData:self.jsonURL];
            hud.labelText = @"Loading...";
            //I'm blocking because I'm in the directory fetcher thread, and I can't otherwise access the context because it was created in a different thread.
            [document.managedObjectContext performBlock:^{
                for(NSDictionary * dataInfo in myData)
                {
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
            [self.refreshControl endRefreshing];
            notCurrentlyRefreshing = TRUE;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    
    });
    

}

-(void)setupFetchedResultsController
{
    
    //Setting up the Fetched Results Controller

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
            myPredicate = [myPredicate stringByAppendingString:@"(publication LIKE[c] 'Sports News' && ("];
            
            //Also, we need to check and see which sports the person has selected in the Sports tab. We will check the category of the news article to see if the user is likely to be interested in the story before putting it into the table so let's add some more filters.
            NSArray * keys = [defaults objectForKey:@"userDefaultsSportsKey"];
            NSArray * searchWords = [defaults objectForKey:@"typesOfSports"];
            
            //Add the sports predicate to the existing predicate (if any)
            myPredicate = [myPredicate stringByAppendingString:[self createPredicateForKeys:keys usingSearchWords:searchWords forAttribute:@"category"]];
            myPredicate = [myPredicate stringByAppendingString:@"))"];
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
        NSArray * keys = [defaults objectForKey:@"userDefaultsEventsKey"];
        NSArray * searchWords = [defaults objectForKey:@"typesOfEvents"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:[self createPredicateForKeys:keys usingSearchWords:searchWords forAttribute:@"category"]];
        [request setPredicate:predicate];
    }
    else if(self.childNumber == [NSNumber numberWithInt:1])
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * keys = [defaults objectForKey:@"userDefaultsSportsKey"];
        NSArray * searchWords = [defaults objectForKey:@"typesOfSports"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:[self createPredicateForKeys:keys usingSearchWords:searchWords forAttribute:@"sportType"]];
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
    
    //Making sure I have information in my database already. If not, then I need to determine whether I should download or leave the table empty.
    if([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0)
    {
        
        //As long as I'm not the Directory-Favorites or Directory-History tables, I'll continue.
        if(self.childNumber != [NSNumber numberWithInt:5] && self.childNumber != [NSNumber numberWithInt:6])
        {
            if(self.childNumber == [NSNumber numberWithInt:1])
            {
                //I am the Sports table
                if(![self switchesAreAllOffFor:@"userDefaultsSportsKey"])
                {
                    [self refresh];
                }
            }
            else if(self.childNumber == [NSNumber numberWithInt:2])
            {
                //I am the Events table
                if(![self switchesAreAllOffFor:@"userDefaultsEventsKey"])
                {
                    [self refresh];
                }
            }
            else if(self.childNumber == [NSNumber numberWithInt:3])
            {
                //I am the News table
                //News is a special case because if the user is subscribed to sports news, yet has not chosen any sports to subscribe to in the sports table, there will not be any news shown.
                if(![self switchesAreAllOffFor:@"userDefaultsNewsKey"])
                {
                    //Ok, so there is at least one News switch turned on, is it the sports news switch? If it is, I need to see if I am subscribed to any sports.
                    if(![self switchIsOffAtIndex:[NSNumber numberWithInt:1] forKey:@"userDefaultsNewsKey"] && [self switchIsOffAtIndex:[NSNumber numberWithInt:2] forKey:@"userDefaultsNewsKey"] && [self switchIsOffAtIndex:[NSNumber numberWithInt:0] forKey:@"userDefaultsNewsKey"])
                    {
                        //The Sports News switch is on and the Wichitan/Campus News are off. Therefore, if there are ANY sport switches turned on, then I will attempt an update. Otherwise, I won't.
                        if(![self switchesAreAllOffFor:@"userDefaultsSportsKey"])
                        {
                            [self refresh];
                        }
                        else
                        {
                            //do nothing
                        }
                    }
                    else
                    {
                        //Oh, so then either the sports news is not turned on OR the Wichitan/Campus News is turned on. Because I have nothing to show in my table, I will attempt an update to see if there's anything available.
                        [self refresh];
                    }
                }
            }
            else if(self.childNumber == [NSNumber numberWithInt:4])
            {
                //This is the directory, which means there is no ability for the user to filter the listing and thus these must be refreshed
                [self refresh];
            }
        }
    }
    else if(self.childNumber == [NSNumber numberWithInt:5] || self.childNumber == [NSNumber numberWithInt:6])
    {
        //do nothing
    }
    else
    {
        //I know there are items in the database already.
        //do nothing
    }
    
}

-(BOOL) switchIsOffAtIndex:(NSNumber*)myIndex forKey:(NSString*)myKey
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * objects = [defaults objectForKey:myKey];
    
    return (![defaults boolForKey:[objects objectAtIndex:[myIndex integerValue]]]);
}

//Get a yes or not answer as to whether all of the switches are on
-(BOOL) switchesAreAllOffFor:(NSString*)myKey
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * objects = [defaults objectForKey:myKey];
    for(int i=0; i<[objects count]; i++)
    {
        if([defaults boolForKey:[objects objectAtIndex:i]])
        {
            return NO;
        }
    }
    //If I get to this point, then all my switches were on
    
    return YES;
}

-(NSString*)createPredicateForKeys:(NSArray*)myKeys usingSearchWords:(NSArray*)mySearchWords forAttribute:(NSString*)myAttribute
{
    
    NSString * myPredicate = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    for(int i=0; i<[myKeys count]; i++)
    {
        if([defaults boolForKey:[myKeys objectAtIndex:i]])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }

            myPredicate = [myPredicate stringByAppendingString:myAttribute];
            myPredicate = [myPredicate stringByAppendingString:@" LIKE[c] "];
            myPredicate = [myPredicate stringByAppendingString:@"'"];
            myPredicate = [myPredicate stringByAppendingString:[mySearchWords objectAtIndex:i]];
            myPredicate = [myPredicate stringByAppendingString:@"'"];
        }
    }
    
    if([myPredicate length] > 0)
    {
        return myPredicate;
    }
    else
    {
        NSString * returnStatement = myAttribute;
        returnStatement = [returnStatement stringByAppendingString:@" LIKE[c] 'nothing'"];
        return returnStatement;
    }
    
}

-(void)useDocument
{
    //Does my file not exist yet?
    if(![[NSFileManager defaultManager]fileExistsAtPath:[self.myDatabase.fileURL path]])
    {
        [self.myDatabase saveToURL:self.myDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
         }];
    }
    //What if my document is closed?
    else if(self.myDatabase.documentState == UIDocumentStateClosed)
    {
        [self.myDatabase openWithCompletionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
         }];
    }
    //What if my document is already open?
    else if(self.myDatabase.documentState == UIDocumentStateNormal)
    {
        [self setupFetchedResultsController];
    }
    else
    {
        //do nothing
    }
    
}

-(void)setMyDatabase:(UIManagedDocument *)myDatabase
{
    
    //If someone sets this document externally, I need to start using it.
    //In the setter, anytime someone sets this (as long as it has changed), then set it.
    if(_myDatabase != myDatabase)
    {
        _myDatabase = myDatabase;
        [self useDocument];
    }
    else
    {
        //do nothing
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set debug to TRUE for the CoreDataTableViewController class
    self.debug = TRUE;
    
    //Refresh Control
    //Make sure the Directory Favorites and Directory History do NOT have the refresh control.
    if(self.childNumber != [NSNumber numberWithInt:5] && self.childNumber != [NSNumber numberWithInt:6])
    {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1];
        
        //Retrieve the user defaults so that the last update for this table may be retrieved and shown to the user
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        //Set the refresh control attributed string to the retrieved last update
        switch([self.childNumber integerValue])
        {
            case 1:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"sportsRefreshTime"]];break;
            case 2:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"eventsRefreshTime"]];break;
            case 3:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"newsRefreshTime"]];break;
            case 4:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"directoryRefreshTime"]];break;
        }
        
        [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        
        self.refreshControl = refreshControl;
    }
    
    //Should I setup any navigation bar buttons for this view? Put all of the rules here for your table view controllers. Directory/Social/Maps should not have a subscribe button
    if(self.childNumber == [NSNumber numberWithInt:4])
    {
        //Don't show a bar button item for these views
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
        //do nothing
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
    }
    else
    {
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

/*
//Perform the action that the user chose from the UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"I pressed button 1");
    }
}
*/

-(void)goToMySubscriptionView
{
    
    
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
                currentEmployee.favorite = @"no";
            }
        }
    }
    else if(self.childNumber == [NSNumber numberWithInt:6])
    {
        for(Employee * currentEmployee in results)
        {
            if(currentEmployee.history)
            {
                currentEmployee.history = nil;
            }
        }
    }
    //Save!!!
    //[self.directoryDatabase updateChangeCount:UIDocumentChangeDone];
    
}

-(void) refresh
{
    [self fetchDataFromOnline:self.myDatabase];
    
    //Set the attributable string for the refresh control
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    //Save this update string to the user defaults
    [self saveRefreshTime:lastUpdated];
}

-(void)saveRefreshTime:(NSString*)refreshTime
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    switch([self.childNumber integerValue])
    {
        case 1:[defaults setObject:refreshTime forKey:@"sportsRefreshTime"];break;
        case 2:[defaults setObject:refreshTime forKey:@"eventsRefreshTime"];break;
        case 3:[defaults setObject:refreshTime forKey:@"newsRefreshTime"];break;
        case 4:[defaults setObject:refreshTime forKey:@"directoryRefreshTime"];break;
    }
    [defaults synchronize];

    
}

//######################################################################################
//#                 TABLE VIEW STUFF
//######################################################################################
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
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

            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:5])
        {
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:6])
        {
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }        
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        if(self.childNumber == [NSNumber numberWithInt:3] || self.childNumber == [NSNumber numberWithInt:2])
        {
            cell.detailTextLabel.text = [self.dataObject content];
        }
        else
        {
            //Sports should show the date in the detail label
            NSString * sDate = @"(no date)";
            NSString * sTime = @"(no time)";
            if([[self.dataObject startDate] length] >  0)
            {
                sDate = [self.dataObject startDate];
            }
            if([[self.dataObject startTime] length] > 0)
            {
                sTime = [self.dataObject startTime];
            }
            NSString * timeAndDate = [sDate stringByAppendingString:[@" " stringByAppendingString:sTime]];
            cell.detailTextLabel.text = timeAndDate;
        }
        
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
        //Directory cells, Directory Favorites, and Directory History
        NSString * directoryName = [self concatenatePrefix:[self.dataObject name_prefix] firstName:[self.dataObject fname] middleName:[self.dataObject middle] lastName:[self.dataObject lname]];
        
        cell.textLabel.text = directoryName;
        cell.detailTextLabel.text = [self.dataObject position_title_1];
    }
    
    return cell;
}

-(NSString*)concatenatePrefix:(NSString*)name_prefix firstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName
{
    
    //If they are null, make them empty
    if([name_prefix length] == 0)
        name_prefix = @"";
    else
        name_prefix = [name_prefix stringByAppendingString:@" "];
    if([firstName length] == 0)
        firstName = @"";
    else
        firstName = [firstName stringByAppendingString:@" "];
    if([middleName length] == 0)
        middleName = @"";
    else
        middleName = [middleName stringByAppendingString:@" "];
    if([lastName length] == 0)
        lastName = @"";
    
    //Combine them now
    
    return [[NSString stringWithFormat:@"%@%@%@%@",name_prefix,firstName,middleName,lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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
    self.dataObject = nil;
    
    if(sender == self.searchDisplayController.searchResultsTableView)
    {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        self.dataObject = [self.filteredDataArray objectAtIndex:[indexPath row]];
    }
    else
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        self.dataObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    NSLog(@"My child number is %@\n",self.childNumber);
    if(self.childNumber == [NSNumber numberWithInt:1])
        [segue.destinationViewController sendSportInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:2])
        [segue.destinationViewController sendEventInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:3])
        [segue.destinationViewController sendNewsInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:4] || self.childNumber == [NSNumber numberWithInt:5] || self.childNumber == [NSNumber numberWithInt:6])
    {
        NSLog(@"My dataObject person_id is %@\n",[self.dataObject person_id]);
        if([[self.dataObject person_id]length]==0)
        {
            NSLog(@"My god... I was going to send an empty data object???\n");
        }
        else
        {
            NSLog(@"Well I guess I got stuff after all, step aside for person_id=%@!\n",[self.dataObject person_id]);
            [segue.destinationViewController sendEmployeeInformation:self.dataObject];
        }
    }
    else
    {
        NSLog(@"I'm screwed up badly!\n");
    }
    
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
    
    //###### Filter the array using NSPredicate
    //IF SEARCH TEXT IS ONE STRING, I'll check each attribute to see if there's a match.
    NSArray * tempArray;
    NSMutableArray * subPredicates;
    if([searchText componentsSeparatedByString:@" "].count == 1)
    {
        subPredicates = [[NSMutableArray alloc]init];
        for(int i=0; i<[self.keysToSearchOn count]; i++)
        {
            [subPredicates addObject:[NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@",[self.keysToSearchOn objectAtIndex:i],searchText]];
        }
        NSPredicate * predicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        
        tempArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    }
    //THE USER HAS TYPED MULTIPLE WORDS SO I NEED TO CHANGE MY SEARCH STRATEGY
    else
    {
        subPredicates = [[NSMutableArray alloc]init];
        NSArray * searchTerms = [searchText componentsSeparatedByString:@" "];
        NSLog(@"I see that I have %d components!\n",[searchTerms count]);
        for(int i=0; i<[searchTerms count]; i++)
        {
            for(int j=0; j<[self.keysToSearchOn count]; j++)
            {
                [subPredicates addObject:[NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@",[self.keysToSearchOn objectAtIndex:j],[searchTerms objectAtIndex:i]]];
            }
            NSPredicate * predicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
            NSLog(@"NSPredicate is %@\n",predicate);
            tempArray = [self.dataArray filteredArrayUsingPredicate:predicate];
        }
    }
    
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
