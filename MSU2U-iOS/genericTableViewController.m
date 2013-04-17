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
        NSLog(@"Error with json: %@",error);
        //do nothing
    }
    
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(fetchQ,^{
        
            [self.refreshControl beginRefreshing];
            
            //### JSON Downloading begins and ends here
            if(self.childNumber == [NSNumber numberWithInt:7])
            {
                //NSLog(@"### I'm Twitter!\n");
                for(int i=0; i<[self.twitterProfilesAndHashtags count]; i++)
                {
                    //Is this a #hashtag?
                    if([[self.twitterProfilesAndHashtags objectAtIndex:i]hasPrefix:@"#"])
                    {
                        //NSLog(@"### I'm a hashtag!n");
                        //Yep, it is a hashtag, so I need to treat this differently.
                        NSString * hashTag = [[self.twitterProfilesAndHashtags objectAtIndex:i]stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        self.jsonURL = [@"http://search.twitter.com/search.json?q=%23" stringByAppendingString:hashTag];
                        NSData * jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:self.jsonURL] encoding:NSUTF8StringEncoding error:nil]dataUsingEncoding:NSUTF8StringEncoding];
                        NSError * error = nil;
                        NSDictionary * results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error] : nil;
                        NSArray * myData = [results objectForKey:@"results"];
                        
                        //I'm blocking because I'm in the fetcher thread, and I can't otherwise access the context because it was created in a different thread.
                        [document.managedObjectContext performBlock:^{	
                        	for(NSDictionary * dataInfo in myData)
                        	{
                            		[Tweet tweetWithInfo:dataInfo isProfile:FALSE inManagedObjectContext:document.managedObjectContext];
                        	}
                        }];
                    }
                    //No, this is a profile such as @matthewfarm
                    else
                    {
                        //NSLog(@"###I'm a profile!\n");
                        self.jsonURL = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@&include_rts=1",[self.twitterProfilesAndHashtags objectAtIndex:i]];
                        NSArray * myData = [self downloadCurrentData:self.jsonURL];
                        //NSLog(@"myData = %@\n",myData);
                        
                        //I'm blocking because I'm in the fetcher thread, and I can't otherwise access the context because it was created in a different thread.
                        [document.managedObjectContext performBlock:^{
                        	for(NSDictionary * dataInfo in myData)
                        	{
                            		[Tweet tweetWithInfo:dataInfo isProfile:TRUE inManagedObjectContext:document.managedObjectContext];
                        	}
                        }];
                    }
                }
            }
            //News
            else if(self.childNumber == [NSNumber numberWithInt:3])
            {
                hud.labelText = @"Downloading...";
                NSArray * myWichitanData = [self downloadCurrentData:self.jsonURL];
                NSArray * mySportsNewsData = [self downloadCurrentData:self.jsonSportsNewsURL];
                hud.labelText = @"Loading...";
                NSLog(@"mySportsNewsData = %@\n",mySportsNewsData);
                [document.managedObjectContext performBlock:^{
                    for(NSDictionary * dataInfo in myWichitanData)
                    {
                        [News newsWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                    }
                    for(NSDictionary * dataInfo in mySportsNewsData)
                    {
                        [News newsWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                    }
                }];
            }
            //EVENTS and DIRECTORY
            else
            {
                //Everything but Twitter feeds are processed the same way so that's why they are all in this block. The Database Crew creates these feeds for us so they all match in their formatting, unlike Twitter created feeds which need to be handled a bit differently
                hud.labelText = @"Downloading...";
                NSArray * myData = [self downloadCurrentData:self.jsonURL];
                hud.labelText = @"Loading...";
                
                //I'm blocking because I'm in the directory fetcher thread, and I can't otherwise access the context because it was created in a different thread.
                [document.managedObjectContext performBlock:^{
                    for(NSDictionary * dataInfo in myData)
                    {
                        //DEPENDS ON THE CHILD THAT I'M WORKING WITH
                        if(self.childNumber == [NSNumber numberWithInt:2])
                            [Event eventWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                        else if(self.childNumber == [NSNumber numberWithInt:4])
                            [Employee employeeWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
                    }
                }];
            }//end-else
            
            [self.refreshControl endRefreshing];
            notCurrentlyRefreshing = TRUE;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
    });
}

-(void)setupFetchedResultsController
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    
    //### What should I show in my table?
    //News
    if(self.childNumber == [NSNumber numberWithInt:2])
    {
        NSPredicate * predicate;
        switch(self.showEventsForIndex)
        {
            case 0:
            {
                //ALL
                predicate =[NSPredicate predicateWithFormat:@"startdate >= %@",[NSDate date]];
                break;
            }
            case 1:
            {
                //HOME GAMES ONLY
                predicate = [NSPredicate predicateWithFormat:@"startdate >= %@ AND isHomeGame LIKE[c] 'yes'",[NSDate date]];
                break;
            }
            case 2:
            {
                //AWAY GAMES ONLY
                predicate =[NSPredicate predicateWithFormat:@"startdate >= %@ AND isHomeGame LIKE[c] 'no'",[NSDate date]];
                break;
            }
        }
        [request setPredicate:predicate];
    }
    //Directory
    else if(self.childNumber == [NSNumber numberWithInt:4])
    {
        NSPredicate * predicate;
        if(self.showDirectoryFavoritesOnly)
        {
            predicate = [NSPredicate predicateWithFormat:@"favorite LIKE[c] 'yes'"];
            [request setPredicate:predicate];
        }
        //else set not predicate for your request
    }
    //Twitter
    else if(self.childNumber == [NSNumber numberWithInt:7])
    {
        NSPredicate * predicate;
        
        switch(self.showTweetsForIndex)
        {
            case 0:
            {
                //do nothing because I want to show all Tweets
                break;
            }
            case 1:
            {
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
                
                [components setHour:-[components hour]];
                [components setMinute:-[components minute]];
                [components setSecond:-[components second]];
                NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
                
                [components setHour:-24];
                [components setMinute:0];
                [components setSecond:0];
                NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
                
                predicate = [NSPredicate predicateWithFormat:@"created_at >= %@",yesterday];
                [request setPredicate:predicate];
                break;
            }
        }
    }
    //NEWS
    else if(self.childNumber == [NSNumber numberWithInt:3])
    {
        switch(self.showNewsForIndex)
        {
            case 0:
            {
                break;
                //do nothing because I want to show ALL of the news
            }
            case 1:
            {
                //show ONLY 'The Wichitan' news
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"publication LIKE[c] 'The Wichitan'"];
                [request setPredicate:predicate];
                break;
            }
            case 2:
            {
                //show ONLY 'MSU Mustangs' sports related news
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"publication LIKE[c] 'MSU Mustangs'"];
                [request setPredicate:predicate];
                break;
            }
            case 3:
            {
                //show ONLY 'Campus' related news
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"publication LIKE[c] 'Campus'"];
                [request setPredicate:predicate];
                break;
            }
        }
    }
    
    //2. How should I sort the data in my table?
    //IF NOT TWITTER AND NOT EVENTS AND NOT NEWS
    if(self.childNumber != [NSNumber numberWithInt:7] && self.childNumber != [NSNumber numberWithInt:2] && self.childNumber != [NSNumber numberWithInt:3])
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    else if(self.childNumber == [NSNumber numberWithInt:7] || self.childNumber == [NSNumber numberWithInt:3])
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:NO]];
    else
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.myDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    //3. What should I do if there's NOTHING to show in my table?
    if([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0)
    {
        if(self.childNumber == [NSNumber numberWithInt:4])
        {
            if(!self.showDirectoryFavoritesOnly)
                [self refresh];
        }
        else if(self.childNumber == [NSNumber numberWithInt:2])
        {
            if(self.showEventsForIndex == 0)
                [self refresh];
        }
        else if(self.childNumber == [NSNumber numberWithInt:3])
        {
            if(self.showNewsForIndex == 0)
                [self refresh];
        }
        else if(self.childNumber == [NSNumber numberWithInt:7])
        {
            if(self.showTweetsForIndex == 0)
                [self refresh];
        }
        else
        {
            [self refresh];
        }
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
        NSLog(@"My document exists but it is neither opened nor closed? Strange error from which we can not recover.\n");
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
    NSLog(@"Hello?????\n");
    //Set debug to TRUE for the CoreDataTableViewController class
    self.debug = TRUE;
    
    //Refresh Control
    //Make sure the Directory Favorites and Directory History do NOT have the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1];
    
    //Retrieve the user defaults so that the last update for this table may be retrieved and shown to the user
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Setting refresh controls...\n");
    //Set the refresh control attributed string to the retrieved last update
    switch([self.childNumber integerValue])
    {
        case 2:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"eventsRefreshTime"]];break;
        case 3:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"newsRefreshTime"]];break;
        case 4:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"directoryRefreshTime"]];break;
        case 7:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"twitterRefreshTime"]];break;
        default:NSLog(@"My child number is %@\n",self.childNumber);
    }
    
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
    NSLog(@"Setting up the fetched data arrays to be empty...\n");
    //Setup the arrays which will be used to hold the Core Data for the respective Table View Controller
    self.dataArray = [[NSMutableArray alloc]initWithObjects:nil];
    self.filteredDataArray = [[NSMutableArray alloc]initWithObjects:nil];
    
    //I did have the [super viewWillAppear:animated]; right here before.
    NSLog(@"Checking if I should fetch...\n");
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
        case 2:[defaults setObject:refreshTime forKey:@"eventsRefreshTime"];break;
        case 3:[defaults setObject:refreshTime forKey:@"newsRefreshTime"];break;
        case 4:[defaults setObject:refreshTime forKey:@"directoryRefreshTime"];break;
        case 7:[defaults setObject:refreshTime forKey:@"tweetsRefreshTime"];break;
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
        return [self.filteredDataArray count];
	else
	{
        int count = 0;
        
        if(self.childNumber == [NSNumber numberWithInt:2])
            for (Event * currentEvents in [self.fetchedResultsController fetchedObjects])
                count++;
        else if(self.childNumber == [NSNumber numberWithInt:3])
            for (News * currentNews in [self.fetchedResultsController fetchedObjects])
                count++;
        else if(self.childNumber == [NSNumber numberWithInt:4])
            for(Employee * currentEmployees in [self.fetchedResultsController fetchedObjects])
                count++;
        else if(self.childNumber == [NSNumber numberWithInt:7])
            for(Tweet * currentTweets in [self.fetchedResultsController fetchedObjects])
                count++;
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
    
    if(self.childNumber == [NSNumber numberWithInt:2] || self.childNumber == [NSNumber numberWithInt:3])
    {
        //News and Events both have titles to show in their cell
        cell.textLabel.text = [self.dataObject title];
        if(self.childNumber == [NSNumber numberWithInt:2])
        {
            cell.detailTextLabel.text = [self.dataObject desc];
        }
        //News uses something called "short_description"
        else if(self.childNumber == [NSNumber numberWithInt:3])
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@",[self.dataObject last_changed],[self.dataObject short_description]];
        }
        
        //THIS IS A NEWS CELL, SO LET'S FIGURE OUT WHICH IMAGE TO SHOW IN THE CELL ROW
        if(self.childNumber == [NSNumber numberWithInt:3])
        {
            NSString * defaultImage;
            if([[self.dataObject publication] isEqualToString:@"The Wichitan"])
            {
                defaultImage = @"theWichitan.jpg";
            }
            else if([[self.dataObject publication] isEqualToString:@"MSU Mustangs"])
            {
                defaultImage = @"101-gameplan.png";
            }
            
            //Download a 50x50 image
            [cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject image]] placeholderImage:[UIImage imageNamed:defaultImage] options:0 andResize:CGSizeMake(50, 50)];
            
            //Ensure that the table cell image is restricted to 50x50
            CGSize size = {50,50};
            cell.imageView.image = [self imageWithImage:cell.imageView.image scaledToSize:size];
            
        }
        else if(self.childNumber == [NSNumber numberWithInt:2])
        {
            NSArray * sportCategories = [[NSArray alloc]initWithObjects:@"Men's Cross Country/Track",@"Women's Cross Country/Track",@"Men's Basketball",@"Women's Basketball",@"Football",@"Men's Golf",@"Women's Golf",@"Men's Soccer",@"Women's Soccer",@"Softball",@"Men's Tennis",@"Women's Tennis",@"Volleyball", nil];
            NSArray * sportImages = [[NSArray alloc]initWithObjects:@"crossCountry.jpeg",@"crossCountry.jpeg",@"basketball.jpeg",@"basketball.jpeg",@"football.jpeg",@"golf.jpeg",@"golf.jpeg",@"soccer.jpeg",@"soccer.jpeg",@"softball.jpeg",@"tennis.jpeg",@"tennis.jpeg",@"volleyball.jpeg", nil];
            
            for(int i=0; i<[sportCategories count]; i++)
            {
                //If I find my current sport category in the title string, then set my event category equal to the sport category that was found in the title string and break
                if([[self.dataObject category] rangeOfString:[sportCategories objectAtIndex:i]].location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:[sportImages objectAtIndex:i]];
                    break;
                }
            }
            
            //Resize image
            CGSize size = {50,50};
            cell.imageView.image = [self imageWithImage:cell.imageView.image scaledToSize:size];
        }
    }
    else if(self.childNumber == [NSNumber numberWithInt:4])
    {        
        //Directory cells, Directory Favorites, and Directory History
        NSString * directoryName = [self concatenatePrefix:[self.dataObject name_prefix] firstName:[self.dataObject fname] middleName:[self.dataObject middle] lastName:[self.dataObject lname]];
        
        cell.textLabel.text = directoryName;
        cell.detailTextLabel.text = [self.dataObject position_title_1];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject picture]] placeholderImage:[UIImage imageNamed:@"Unknown.jpg"] options:0 andResize:CGSizeMake(40, 50)];
        //[cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject picture]] placeholderImage:[UIImage imageNamed:@"Unknown.jpg"]];
        CGSize size = {40,50};
        cell.imageView.image = [self imageWithImage:cell.imageView.image scaledToSize:size];
    }
    else if(self.childNumber == [NSNumber numberWithInt:7])
    {
        cell.textLabel.text = [self.dataObject text];        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ by %@",[NSDateFormatter localizedStringFromDate:[self.dataObject created_at] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],[self.dataObject screen_name]];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject profile_image_url]] placeholderImage:[UIImage imageNamed:@"twitter.png"] options:0 andResize:CGSizeMake(50, 50)];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject profile_image_url]] placeholderImage:[UIImage imageNamed:@"twitter.png"]];
        CGSize size = {50,50};
        cell.imageView.image = [self imageWithImage:cell.imageView.image scaledToSize:size];
    }
    return cell;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

    if(self.childNumber == [NSNumber numberWithInt:2])
        [segue.destinationViewController sendEventInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:3])
    {
        //[segue.destinationViewController sendNewsInformation:self.dataObject];
        [segue.destinationViewController sendURL:[self.dataObject link] andTitle:[self.dataObject publication]];
    }
    else if(self.childNumber == [NSNumber numberWithInt:4])
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
    else if(self.childNumber == [NSNumber numberWithInt:7])
    {
        //[segue.destinationViewController sendTweetInformation:self.dataObject];
        NSLog(@"Going to http://www.twitter.com/%@/status/%@",[self.dataObject screen_name],[self.dataObject max_id]);
        [segue.destinationViewController sendURL:[NSString stringWithFormat:@"http://www.twitter.com/%@/status/%@",[self.dataObject screen_name],[self.dataObject max_id]] andTitle:[self.dataObject screen_name]];
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
    //Events Tab
    if(self.childNumber == [NSNumber numberWithInt:2])
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
    //Twitter Tab
    else if(self.childNumber == [NSNumber numberWithInt:7])
    {
        for (Employee *currentTweets in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentTweets];
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

@end
