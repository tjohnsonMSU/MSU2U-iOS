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
    [log functionEnteredClass:[self class] Function:_cmd];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error)
        [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"JSON error: %@",error.localizedDescription]];
    //NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    [log functionExitedClass:[self class] Function:_cmd];
    
    return results;
}

- (NSArray *)downloadCurrentData:(NSString*)jsonURL
{
    [log functionEnteredClass:[self class] Function:_cmd];
    
    NSString *request = [NSString stringWithFormat:jsonURL];
    
    [log functionExitedClass:[self class] Function:_cmd];
    
    return [self executeDataFetch:request];
}

-(void)fetchDataFromOnline:(UIManagedDocument*)document
{
    [log functionEnteredClass:[self class] Function:_cmd];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Data Fetcher", NULL);
    
    dispatch_async(fetchQ,^{
        
        [log outputClass:[self class] Function:_cmd Message:@"dispatch_async: Fetchq"];
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
            hud.labelText = @"Downloading...";
            NSArray * myData = [self downloadCurrentData:self.jsonURL];
            hud.labelText = @"Loading...";
            //I'm blocking because I'm in the directory fetcher thread, and I can't otherwise access the context because it was created in a different thread.
            [document.managedObjectContext performBlock:^{
                for(NSDictionary * dataInfo in myData)
                {
                    [log outputClass:[self class] Function:_cmd Message:@"Inserting into database"];
                    
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
            
            [log outputClass:[self class] Function:_cmd Message:@"Finished inserting into database"];
                
                
                
            dispatch_async(dispatch_get_main_queue(), ^{
                [log outputClass:[self class] Function:_cmd Message:@"dispatch_async: Hide Progress View"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    
    });
    [log functionExitedClass:[self class] Function:_cmd];

}

-(void)setupFetchedResultsController
{
    [log functionEnteredClass:[self class] Function:_cmd];
    //Setting up the Fetched Results Controller
    [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"childNumber=%@",self.childNumber]];

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
        [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"Constructed Predicate is %@",myPredicate]];
        
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
        [log outputClass:[self class] Function:_cmd Message:@"There were 0 object in my table. Should I download more items?"];
        
        //As long as I'm not the Directory-Favorites or Directory-History tables, I'll continue.
        if(self.childNumber != [NSNumber numberWithInt:5] && self.childNumber != [NSNumber numberWithInt:6])
        {
            if(self.childNumber == [NSNumber numberWithInt:1])
            {
                [log outputClass:[self class] Function:_cmd Message:@"I am in Sports Table"];
                //I am the Sports table
                if(![self switchesAreAllOffFor:@"userDefaultsSportsKey"])
                {
                    [log outputClass:[self class] Function:_cmd Message:@"At least one sport is subscribed to, so update"];
                    [self refresh];
                }
            }
            else if(self.childNumber == [NSNumber numberWithInt:2])
            {
                [log outputClass:[self class] Function:_cmd Message:@"I am in Events table"];
                //I am the Events table
                if(![self switchesAreAllOffFor:@"userDefaultsEventsKey"])
                {
                    [log outputClass:[self class] Function:_cmd Message:@"At least one event switch is on, so update"];
                    [self refresh];
                }
            }
            else if(self.childNumber == [NSNumber numberWithInt:3])
            {
                [log outputClass:[self class] Function:_cmd Message:@"I am in News table"];
                //I am the News table
                //News is a special case because if the user is subscribed to sports news, yet has not chosen any sports to subscribe to in the sports table, there will not be any news shown.
                if(![self switchesAreAllOffFor:@"userDefaultsNewsKey"])
                {
                    [log outputClass:[self class] Function:_cmd Message:@"At least one news source switch is on, so upate"];
                    //Ok, so there is at least one News switch turned on, is it the sports news switch? If it is, I need to see if I am subscribed to any sports.
                    if(![self switchIsOffAtIndex:[NSNumber numberWithInt:1] forKey:@"userDefaultsNewsKey"] && [self switchIsOffAtIndex:[NSNumber numberWithInt:2] forKey:@"userDefaultsNewsKey"] && [self switchIsOffAtIndex:[NSNumber numberWithInt:0] forKey:@"userDefaultsNewsKey"])
                    {
                       [log outputClass:[self class] Function:_cmd Message:@"SportsNews is ON, others are OFF"];
                        //The Sports News switch is on and the Wichitan/Campus News are off. Therefore, if there are ANY sport switches turned on, then I will attempt an update. Otherwise, I won't.
                        if(![self switchesAreAllOffFor:@"userDefaultsSportsKey"])
                        {
                            [log outputClass:[self class] Function:_cmd Message:@"I'm subscribed to at least one sport, so update"];
                            [self refresh];
                        }
                        else
                        {
                            [log outputClass:[self class] Function:_cmd Message:@"I'm not subscribed to any sports events, don't try to update"];
                        }
                    }
                    else
                    {
                        [log outputClass:[self class] Function:_cmd Message:@"Update the table because there is no content here"];
                        //Oh, so then either the sports news is not turned on OR the Wichitan/Campus News is turned on. Because I have nothing to show in my table, I will attempt an update to see if there's anything available.
                        [self refresh];
                    }
                }
            }
            else if(self.childNumber == [NSNumber numberWithInt:4])
            {
                [log outputClass:[self class] Function:_cmd Message:@"I am in the Directory and it is empty, so auto update"];
                //This is the directory, which means there is no ability for the user to filter the listing and thus these must be refreshed
                [self refresh];
            }
        }
    }
    else if(self.childNumber == [NSNumber numberWithInt:5] || self.childNumber == [NSNumber numberWithInt:6])
    {
        [log outputClass:[self class] Function:_cmd Message:@"I'm in either Favorites/History so I'll never need to download anything"];
    }
    else
    {
        //I know there are items in the database already.
        [log outputClass:[self class] Function:_cmd Message:@"Data is already available in my database, so I'll load what I've got rather than attempt a download"];
    }
    [log functionExitedClass:[self class] Function:_cmd];
}

-(BOOL) switchIsOffAtIndex:(NSNumber*)myIndex forKey:(NSString*)myKey
{
    [log functionEnteredClass:[self class] Function:_cmd];
    [log outputClass:[self class] Function:_cmd Message:@""];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * objects = [defaults objectForKey:myKey];
    [log functionExitedClass:[self class] Function:_cmd];
    return (![defaults boolForKey:[objects objectAtIndex:[myIndex integerValue]]]);
}

//Get a yes or not answer as to whether all of the switches are on
-(BOOL) switchesAreAllOffFor:(NSString*)myKey
{
    [log functionEnteredClass:[self class] Function:_cmd];
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
    [log outputClass:[self class] Function:_cmd Message:@"All of my switches are off, so that's why there isn't anything to show. I won't bother downloading anything, either."];
    [log functionExitedClass:[self class] Function:_cmd];
    return YES;
}

-(NSString*)createPredicateForKeys:(NSArray*)myKeys usingSearchWords:(NSArray*)mySearchWords forAttribute:(NSString*)myAttribute
{
    [log functionEnteredClass:[self class] Function:_cmd];
    NSString * myPredicate = @"";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    for(int i=0; i<[myKeys count]; i++)
    {
        [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"My key: %@",[myKeys objectAtIndex:i]]];
        if([defaults boolForKey:[myKeys objectAtIndex:i]])
        {
            if([myPredicate length] > 0)
            {
                myPredicate = [myPredicate stringByAppendingString:@" || "];
            }
            [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"My attribute is %@",myAttribute]];
            [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"My search word is %@",[mySearchWords objectAtIndex:i]]];

            myPredicate = [myPredicate stringByAppendingString:myAttribute];
            myPredicate = [myPredicate stringByAppendingString:@" LIKE[c] "];
            myPredicate = [myPredicate stringByAppendingString:@"'"];
            myPredicate = [myPredicate stringByAppendingString:[mySearchWords objectAtIndex:i]];
            myPredicate = [myPredicate stringByAppendingString:@"'"];
        }
    }
    [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"My constructed predicate is %@",myPredicate]];
    
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
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)useDocument
{
    [log functionEnteredClass:[self class] Function:_cmd];
    
    //Does my file not exist yet?
    if(![[NSFileManager defaultManager]fileExistsAtPath:[self.myDatabase.fileURL path]])
    {
        [log outputClass:[self class] Function:_cmd Message:@"Fetching items from online"];
        [self.myDatabase saveToURL:self.myDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [log outputClass:[self class] Function:_cmd Message:@"UIManagedDocument does not exist yet"];
             [self setupFetchedResultsController];
         }];
    }
    //What if my document is closed?
    else if(self.myDatabase.documentState == UIDocumentStateClosed)
    {
        [log outputClass:[self class] Function:_cmd Message:@"UIManagedDocument is closed"];
        [self.myDatabase openWithCompletionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
         }];
    }
    //What if my document is already open?
    else if(self.myDatabase.documentState == UIDocumentStateNormal)
    {
        [log outputClass:[self class] Function:_cmd Message:@"UIManagedDocument is already open"];
        [self setupFetchedResultsController];
    }
    else
    {
        [log outputClass:[self class] Function:_cmd Message:@"UIManagedDocument exists yet is neither opened or closed, something strange happened"];
    }
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)setMyDatabase:(UIManagedDocument *)myDatabase
{
    [log functionEnteredClass:[self class] Function:_cmd];
    //If someone sets this document externally, I need to start using it.
    //In the setter, anytime someone sets this (as long as it has changed), then set it.
    if(_myDatabase != myDatabase)
    {
        [log outputClass:[self class] Function:_cmd Message:@"UIManagedDocument setting up"];
        _myDatabase = myDatabase;
        [self useDocument];
    }
    else
        [log outputClass:[self class] Function:_cmd Message:@"UIManagedDocument already set"];
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)viewWillAppear:(BOOL)animated
{
    log = [[logPrinter alloc]init];
    [log functionEnteredClass:[self class] Function:_cmd];
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
    
    //Should I setup any navigation bar buttons for this view? Put all of the rules here for your table view controllers
    if(self.childNumber == [NSNumber numberWithInt:4])
    {
        //Don't show a bar button item for these views
        [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"BarButtonItem will not be shown for Directory Search View"]];
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
    else if(self.childNumber == [NSNumber numberWithInt:5] || self.childNumber == [NSNumber numberWithInt:6])
    {
        [log outputClass:[self class] Function:_cmd Message:@"Setting 'Clear' BarButton for Directory Favorite or History View"];
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                         style:UIBarButtonSystemItemDone target:self action:@selector(clearMyTable)];
        self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    }
    else if(self.childNumber == [NSNumber numberWithInt:1] || self.childNumber == [NSNumber numberWithInt:2] || self.childNumber == [NSNumber numberWithInt:3])
    {
        [log outputClass:[self class] Function:_cmd Message:@"Setting 'Subscribe' BarButton for News, Sports, and Events"];
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Subscribe"
                                                       style:UIBarButtonSystemItemDone target:self action:@selector(goToMySubscriptionView)];
        self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    }
    else
    {
        [log outputClass:[self class] Function:_cmd Message:@"[!]ERROR: I did not recognize what view I'm in to determine if a BarButton item should be allocated"];
    }
    
    //Setup the arrays which will be used to hold the Core Data for the respective Table View Controller
    self.dataArray = [[NSMutableArray alloc]initWithObjects:nil];
    self.filteredDataArray = [[NSMutableArray alloc]initWithObjects:nil];
    
    //I did have the [super viewWillAppear:animated]; right here before.
    
    if(!self.myDatabase)
    {
        [log outputClass:[self class] Function:_cmd Message:@"Attempting performWithDocument"];
        [[MYDocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.myDatabase = document;
        }];
    }
    else
    {
        [log outputClass:[self class] Function:_cmd Message:@"Not Attempting performWithDocument"];
        [self setupFetchedResultsController];
    }
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)makeSureUserWantsToClearTable
{
    [log functionEnteredClass:[self class] Function:_cmd];
    NSString * viewIamAt;
    
    //If the user is clearing the favorites table...
    if(self.childNumber == [NSNumber numberWithInt:5]){viewIamAt = @"favorites";}
    //If the user is clearing the history table...
    else if(self.childNumber == [NSNumber numberWithInt:6]){viewIamAt = @"history";}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear the table" message:@"Do you want to remove all employees in your %@?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
    [log functionExitedClass:[self class] Function:_cmd];
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
    [log functionEnteredClass:[self class] Function:_cmd];
    
    //Segue over to the subscription view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITableViewController *yourViewController = (UITableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"subscriptionView"];
    [self.navigationController pushViewController:yourViewController animated:YES];
    
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void) clearMyTable
{
    [log functionEnteredClass:[self class] Function:_cmd];
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
                [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"%@ is being changed from favorite 'yes' to 'no'",currentEmployee.lname]];
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
                [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"%@ is being changed from %@ to nil",currentEmployee.lname,currentEmployee.history]];
                currentEmployee.history = nil;
            }
        }
    }
    //Save!!!
    //[self.directoryDatabase updateChangeCount:UIDocumentChangeDone];
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void) refresh
{
    [log functionEnteredClass:[self class] Function:_cmd];
    [self fetchDataFromOnline:self.myDatabase];
    
    //Set the attributable string for the refresh control
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    //Save this update string to the user defaults
    [self saveRefreshTime:lastUpdated];
    
    [self.refreshControl endRefreshing];
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)saveRefreshTime:(NSString*)refreshTime
{
    [log functionEnteredClass:[self class] Function:_cmd];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    switch([self.childNumber integerValue])
    {
        case 1:[defaults setObject:refreshTime forKey:@"sportsRefreshTime"];break;
        case 2:[defaults setObject:refreshTime forKey:@"eventsRefreshTime"];break;
        case 3:[defaults setObject:refreshTime forKey:@"newsRefreshTime"];break;
        case 4:[defaults setObject:refreshTime forKey:@"directoryRefreshTime"];break;
    }
    [defaults synchronize];

    [log functionExitedClass:[self class] Function:_cmd];
}

//######################################################################################
//#                 TABLE VIEW STUFF
//######################################################################################
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [log functionEnteredClass:[self class] Function:_cmd];
    [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"Number of Rows in Section = %d",section]];
    
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"Number of Rows in SearchDisplayController is %d",[self.filteredDataArray count]]];
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
            [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"I am childNumber=%@",self.childNumber]];
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:5])
        {
            [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"I am childNumber=%@",self.childNumber]];
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        else if(self.childNumber == [NSNumber numberWithInt:6])
        {
            [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"I am childNumber=%@",self.childNumber]];
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
            {
                count++;
            }
        }
        [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"Regular table has %d rows",count]];
        [log functionExitedClass:[self class] Function:_cmd];
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [log functionEnteredClass:[self class] Function:_cmd];
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
    [log functionExitedClass:[self class] Function:_cmd];
    return cell;
}

-(NSString*)concatenatePrefix:(NSString*)name_prefix firstName:(NSString*)firstName middleName:(NSString*)middleName lastName:(NSString*)lastName
{
    [log functionEnteredClass:[self class] Function:_cmd];
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
    [log functionExitedClass:[self class] Function:_cmd];
    return [[NSString stringWithFormat:@"%@%@%@%@",name_prefix,firstName,middleName,lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [log functionEnteredClass:[self class] Function:_cmd];
    // Perform segue to candy detail
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:self.segueIdentifier sender:tableView];
    }
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [log functionEnteredClass:[self class] Function:_cmd];
    [log outputClass:[self class] Function:_cmd Message:[NSString stringWithFormat:@"I'm preparing to segue to %@",self.segueIdentifier]];
    
    self.dataObject = nil;
    
    if(sender == self.searchDisplayController.searchResultsTableView)
    {
        [log outputClass:[self class] Function:_cmd Message:@"I'm processing a search display row"];
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        self.dataObject = [self.filteredDataArray objectAtIndex:[indexPath row]];
    }
    else
    {
        [log outputClass:[self class] Function:_cmd Message:@"I'm processing a main display row"];
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        self.dataObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    [log outputClass:[self class] Function:_cmd Message:@"Sending dataObject to detail view controller"];
    //Send the JSON data to the detail view controller
    
    if(self.childNumber == [NSNumber numberWithInt:1])
        [segue.destinationViewController sendSportInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:2])
        [segue.destinationViewController sendEventInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:3])
        [segue.destinationViewController sendNewsInformation:self.dataObject];
    else if(self.childNumber >= [NSNumber numberWithInt:4])
        [segue.destinationViewController sendEmployeeInformation:self.dataObject];
    [log functionExitedClass:[self class] Function:_cmd];
}



//######################################################################################
//#                 Search Display Controller Delegate Methods
//######################################################################################
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [log functionEnteredClass:[self class] Function:_cmd];
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
    [log functionExitedClass:[self class] Function:_cmd];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [log functionEnteredClass:[self class] Function:_cmd];
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    [log functionExitedClass:[self class] Function:_cmd];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [log functionEnteredClass:[self class] Function:_cmd];
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    [log functionExitedClass:[self class] Function:_cmd];
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
