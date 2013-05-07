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
//#                 PAUL HEGARTY CORE DATA STUFF                                       #
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

//######## RSS STUFF
-(NSMutableArray*)executeRSSFetch:(NSString*)query
{
    stories = [[NSMutableArray alloc]init];
    
    //NSLog(@"Executing RSS Fetch at %@...\n",query);
    NSURL *rssURL =[[NSURL alloc] initWithString:query];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
    [parser setDelegate:self];
    [parser parse];
    
    //OK, all of my items are in my stories array. Return the array
    return stories;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		
        //Podcasts
        if(self.childNumber == [NSNumber numberWithInt:9])
        {
            [item setObject:currentTitle forKey:@"Title"];
            [item setObject:currentPubDate forKey:@"Pub_Date"];
            [item setObject:currentGuid forKey:@"Article_ID"];
            [item setObject:currentLink forKey:@"Link"];
        }
        //Events
        else if(self.childNumber == [NSNumber numberWithInt:2])
        {
            [item setObject:currentTitle forKey:@"title"];
            [item setObject:currentLink forKey:@"link"];
            [item setObject:currentDesc forKey:@"description"];
            [item setObject:currentSTeamLogo forKey:@"teamlogo"];
            [item setObject:currentSOpponentLogo forKey:@"opponentlogo"];
            [item setObject:currentEvLocation forKey:@"location"];
            [item setObject:currentEvStartDate forKey:@"startdate"];
            [item setObject:currentEvEndDate forKey:@"enddate"];
        }
        else if(self.childNumber == [NSNumber numberWithInt:3])
        {
            [item setObject:currentTitle forKey:@"Title"];
            [item setObject:currentGuid forKey:@"Article_ID"];
            [item setObject:currentLink forKey:@"Link"];
            [item setObject:currentCategory forKey:@"Category_1"];
            [item setObject:currentDcCreator forKey:@"Doc_Creator"];
            [item setObject:currentDesc forKey:@"Short_Description"];
            [item setObject:currentDesc forKey:@"Long_Description"];
            [item setObject:currentPubDate forKey:@"Pub_Date"];
            [item setObject:currentPubDate forKey:@"Last_Changed"];
            [item setObject:myCurrentPublication forKey:@"Publication"];
            
            //I need to get an image!!! Extract this from the description.
            NSString *src = nil;
            NSString *newsRSSFeed = [item objectForKey:@"Long_Description"];
            NSScanner *theScanner = [NSScanner scannerWithString:newsRSSFeed];
            // find start of IMG tag
            [theScanner scanUpToString:@"<img" intoString:nil];
            if (![theScanner isAtEnd]) {
                [theScanner scanUpToString:@"src" intoString:nil];
                NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                [theScanner scanCharactersFromSet:charset intoString:nil];
                [theScanner scanUpToCharactersFromSet:charset intoString:&src];
                // src now contains the URL of the img
            }
            
            if(!src)
                src = @"";
            [item setObject:src forKey:@"image"];
            
            //Clean up the description!
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*>"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            
            [regex replaceMatchesInString:[item objectForKey:@"Long_Description"]
                                  options:0
                                    range:NSMakeRange(0, [[item objectForKey:@"Long_Description"] length])
                             withTemplate:@""];
            
            [[item objectForKey:@"Long_Description"] replaceOccurrencesOfString:@"<br />" withString:@"" options:nil range:NSMakeRange(0,[[item objectForKey:@"Long_Description"] length])];
            
        }
        
		[stories addObject:[item copy]];
		//NSLog(@"adding story: %@", currentTitle);
	}
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
    
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
        currentTitle = [[NSMutableString alloc]init];
        currentDesc = [[NSMutableString alloc]init];
        currentPubDate = [[NSMutableString alloc]init];
        currentGuid = [[NSMutableString alloc]init];
        currentLink = [[NSMutableString alloc]init];
        currentEnclosureURL = [[NSMutableString alloc]init];
        currentEvGameID = [[NSMutableString alloc]init];
        currentEvLocation = [[NSMutableString alloc]init];
        currentEvStartDate = [[NSMutableString alloc]init];
        currentEvEndDate = [[NSMutableString alloc]init];
        currentSTeamLogo = [[NSMutableString alloc]init];
        currentSOpponentLogo = [[NSMutableString alloc]init];
        currentDcCreator = [[NSMutableString alloc]init];
        currentCategory = [[NSMutableString alloc]init];
        currentContentEncoded = [[NSMutableString alloc]init];
        
        [currentTitle appendString:@""];
        [currentDesc appendString:@""];
        [currentPubDate appendString:@""];
        [currentGuid appendString:@""];
        [currentLink appendString:@""];
        [currentEnclosureURL appendString:@""];
        [currentEvGameID appendString:@""];
        [currentEvLocation appendString:@""];
        [currentEvStartDate appendString:@""];
        [currentEvEndDate appendString:@""];
        [currentSTeamLogo appendString:@""];
        [currentSOpponentLogo appendString:@""];
        [currentDcCreator appendString:@""];
        [currentCategory appendString:@""];
        [currentContentEncoded appendString:@""];
	}
    //Check for enclosure URL (used by Podcasts to get the link). MUST ENSURE THAT MSUMUSTANGS ignores this, so don't allow childNumber of 3 because that will screw up the msumustang links
    else if([elementName isEqualToString:@"enclosure"] && self.childNumber != [NSNumber numberWithInt:3])
    {
        [currentLink appendString:[attributeDict objectForKey:@"url"]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"found characters: %@", string);
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"])
    {
        //NSLog(@"I am setting currentTitle = %@\n",string);
		[currentTitle appendString:string];
    }
	else if ([currentElement isEqualToString:@"pubDate"])
		[currentPubDate appendString:string];
    else if([currentElement isEqualToString:@"guid"])
        [currentGuid appendString:string];
    else if([currentElement isEqualToString:@"link"])
    {
        //NSLog(@"<<< appending string '%@' to currentLink...\n",string);
        [currentLink appendString:string];
        //NSLog(@"<<< complete!\n");
    }
    else if([currentElement isEqualToString:@"ev:gameid"])
        [currentEvGameID appendString:string];
    else if([currentElement isEqualToString:@"ev:location"])
        [currentEvLocation appendString:string];
    else if([currentElement isEqualToString:@"ev:startdate"])
        [currentEvStartDate appendString:string];
    else if([currentElement isEqualToString:@"ev:enddate"])
        [currentEvEndDate appendString:string];
    else if([currentElement isEqualToString:@"s:teamlogo"])
        [currentSTeamLogo appendString:string];
    else if([currentElement isEqualToString:@"s:opponentlogo"])
        [currentSOpponentLogo appendString:string];
    else if([currentElement isEqualToString:@"description"])
        [currentDesc appendString:string];
    else if([currentElement isEqualToString:@"dc:creator"])
        [currentDcCreator appendString:string];
    else if([currentElement isEqualToString:@"category"])
        [currentCategory appendString:string];
    else if([currentElement isEqualToString:@"content:encoded"])
        [currentDesc appendString:string];
}
//####### END RSS STUFF

- (NSArray *)downloadCurrentData:(NSString*)jsonURL
{
    NSString *request = [NSString stringWithFormat:@"%@",jsonURL];
    return [self executeDataFetch:request];
}

-(void)fetchDataFromOnline:(UIManagedDocument*)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Data Fetcher", NULL);
    
    MBProgressHUD *hud;
    
    if([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

    dispatch_async(fetchQ,^{
        
        [self.refreshControl beginRefreshing];
        hud.labelText = @"Downloading...";
        
        //### JSON Downloading begins and ends here
        if(self.childNumber == [NSNumber numberWithInt:7])
            [self getTweets:document];
        //News
        else if(self.childNumber == [NSNumber numberWithInt:3])
            [self getNews:document];
        //VIDEO
        else if(self.childNumber == [NSNumber numberWithInt:8])
            [self getVideos:document];
        else if(self.childNumber == [NSNumber numberWithInt:9])
            [self getPodcasts:document];
        else if(self.childNumber == [NSNumber numberWithInt:2])
            [self getEvents:document];
        else if(self.childNumber == [NSNumber numberWithInt:4])
            [self getDirectory:document];
        else
            NSLog(@"I did not recognize what view currently needs data to be loaded?\n");
            
        [self.refreshControl endRefreshing];
        notCurrentlyRefreshing = TRUE;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

-(void)getDirectory:(UIManagedDocument*)document
{
    NSArray * myData = [self downloadCurrentData:self.jsonURL];
    [document.managedObjectContext performBlock:^{
        for(NSDictionary * dataInfo in myData)
        {
            [Employee employeeWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
        }
    }];
}

-(void)getEvents:(UIManagedDocument*)document
{
    //NSArray * myData = [self downloadCurrentData:self.jsonURL];
    NSArray * myData = [self executeRSSFetch:@"http://www.msumustangs.com/calendar.ashx/calendar.rss?"];
    //NSLog(@"There were %d items in my event feed!\n",[myData count]);
    [document.managedObjectContext performBlock:^{
        for(NSDictionary * dataInfo in myData)
        {
            //NSLog(@"Going to insert stuff for %@!\n",[dataInfo objectForKey:@"title"]);
            [Game gameWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
        }
    }];
}

-(void)getPodcasts:(UIManagedDocument*)document
{
    //NSArray * myPodcastData = [self downloadCurrentData:self.jsonURL];
    NSArray * myPodcastData = [self executeRSSFetch:@"http://www.msumustangs.com/podcast.aspx"];
    
    //NSLog(@"Got my podcast data for %d stories...\n",[myPodcastData count]);
    [document.managedObjectContext performBlock:^{
        for(NSDictionary * dataInfo in myPodcastData)
        {
            NSComparisonResult result = [[self convertString:[dataInfo objectForKey:@"Pub_Date"] toDateWithFormat:@"MM/dd/yyyy"] compare:[self getDateFor:@"lastMonth"]];
            
            if(result != NSOrderedAscending)
            {
                //NSLog(@"Going to insert stuff for %@!\n",[dataInfo objectForKey:@"Title"]);
                [Podcast podcastWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
            }
            else
            {
                //NSLog(@"%@ is too old!\n",[dataInfo objectForKey:@"Title"]);
            }
        }
    }];
}

-(void)getNews:(UIManagedDocument*)document
{
    //NSArray * myWichitanData = [self downloadCurrentData:self.jsonURL];
    //NSArray * mySportsNewsData = [self downloadCurrentData:self.jsonSportsNewsURL];
    //NSArray * myMuseumNewsData = [self downloadCurrentData:self.jsonMuseumNewsURL];
    myCurrentPublication = @"The Wichitan";
    NSArray * myWichitanData = [self executeRSSFetch:self.rssWichitanNewsURL];
    myCurrentPublication = @"MSU Mustangs";
    NSArray * mySportsNewsData = [self executeRSSFetch:self.rssSportsNewsURL];
    myCurrentPublication = @"WF Museum of Art";
    NSArray * myMuseumNewsData = [self executeRSSFetch:self.rssMuseumNewsURL];
    
    //NSLog(@"Getting the news!\n");
    [document.managedObjectContext performBlock:^{
        for(NSDictionary * dataInfo in myWichitanData)
        {
            NSComparisonResult result = [[self convertString:[dataInfo objectForKey:@"Pub_Date"] toDateWithFormat:@"EEE, dd MMMM y HH:mm:ss ZZZZ"] compare:[self getDateFor:@"lastMonth"]];
                                         
            if(result != NSOrderedAscending)
            {
                [News newsWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
            }
            else
            {
                //NSLog(@"%@ is too old!\n",[dataInfo objectForKey:@"Title"]);
            }
        }
        for(NSDictionary * dataInfo in mySportsNewsData)
        {
            NSComparisonResult result = [[self convertString:[dataInfo objectForKey:@"Pub_Date"] toDateWithFormat:@"EEE, dd MMMM y HH:mm:ss ZZZZ"] compare:[self getDateFor:@"lastMonth"]];
                                         
            if(result != NSOrderedAscending)
            {
                [News newsWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
            }
            else
            {
                //NSLog(@"%@ is too old!\n",[dataInfo objectForKey:@"Title"]);
            }
        }
        for(NSDictionary * dataInfo in myMuseumNewsData)
        {
            NSComparisonResult result = [[self convertString:[dataInfo objectForKey:@"Pub_Date"] toDateWithFormat:@"EEE, dd MMMM y HH:mm:ss ZZZZ"] compare:[self getDateFor:@"lastMonth"]];
                                         
            if(result != NSOrderedAscending)
            {
                [News newsWithInfo:dataInfo inManagedObjectContext:document.managedObjectContext];
            }
            else
            {
                //NSLog(@"%@ is too old! (%@ is older than %@)\n",[dataInfo objectForKey:@"Title"],[dataInfo objectForKey:@"Pub_Date"],[self getDateFor:@"lastMonth"]);
            }
        }
    }];
}

-(void)getVideos:(UIManagedDocument*)document
{
    //Get videos for all VIMEO channels
    for(int i=0; i<[self.vimeoChannel count]; i++)
    {
        NSArray * myVimeoData = [self downloadCurrentData:[NSString stringWithFormat:@"http://vimeo.com/api/v2/%@/videos.json",[self.vimeoChannel objectAtIndex:i]]];
        
        //NSLog(@"myVimeoData = %@\n",myVimeoData);
        [document.managedObjectContext performBlock:^{
            for(NSDictionary * dataInfo in myVimeoData)
            {
                NSComparisonResult result = [[self convertString:[dataInfo objectForKey:@"upload_date"] toDateWithFormat:@"yyyy-MM-dd HH:mm:ss"] compare:[self getDateFor:@"lastYear"]];
                //NSLog(@"Is %@ before %@?\n",[dataInfo objectForKey:@"upload_date"],[self getDateFor:@"lastYear"]);
                if(result != NSOrderedAscending)
                {
                    [Video videoWithInfo:dataInfo isVimeo:YES inManagedObjectContext:document.managedObjectContext];
                }
                else
                {
                    //NSLog(@"%@ is too old! (%@ is older than %@)\n",[dataInfo objectForKey:@"title"],[dataInfo objectForKey:@"upload_date"],[self getDateFor:@"lastYear"]);
                }
            }
        }];
    }
    
    //Get videos for all YouTube channels
    for(int i=0; i<[self.youTubeChannel count]; i++)
    {
        NSArray * myYouTubeData = [self downloadCurrentData:[NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/users/%@/uploads?&v=2&max-results=20&alt=jsonc",[self.youTubeChannel objectAtIndex:i]]];
        
        NSDictionary * myInfo = myYouTubeData;
        NSArray * itemsAlone = [[myInfo objectForKey:@"data"] objectForKey:@"items"];
        
        [document.managedObjectContext performBlock:^{
            for(NSDictionary * dataInfo in itemsAlone)
            {
                NSComparisonResult result = [[self convertString:[dataInfo objectForKey:@"uploaded"] toDateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.000'Z'"] compare:[self getDateFor:@"lastYear"]];
                //NSLog(@"Is %@ before %@?\n",[dataInfo objectForKey:@"uploaded"],[self getDateFor:@"lastYear"]);
                if(result != NSOrderedAscending)
                {
                    [Video videoWithInfo:dataInfo isVimeo:NO inManagedObjectContext:document.managedObjectContext];
                }
                else
                {
                    //NSLog(@"%@ is too old! (%@ is older than %@)\n",[dataInfo objectForKey:@"title"],[dataInfo objectForKey:@"uploaded"],[self getDateFor:@"lastYear"]);
                }
            }
        }];
    }
}

-(void)getTweets:(UIManagedDocument*)document
{
    //Get access to the user's Twitter Account
    // Request access to the Twitter accounts
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             //self.tableView.separatorColor = nil;
             //[self.tableView setBackgroundView:nil];
             //[self.tableView setHidden:NO];
             NSArray *accounts = [accountStore accountsWithAccountType:accountType];
             
             // Check if the user has setup at least one Twitter account
             if (accounts.count > 0)
             {
                 ACAccount *twitterAccount = [accounts objectAtIndex:0];
                 
                 //Setup the request parameters
                 NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
                 [parameters setObject:@"1" forKey:@"include_rts"];
                 
                 //For all twitter accounts in my list
                 //[parameters setObject:@"midwesternstate" forKey:@"screen_name"];
                 
                 // Creating a request to get the info about a user on Twitter
                 [parameters setObject:@"midwestern" forKey:@"slug"];
                 [parameters setObject:@"midwesternstate" forKey:@"owner_screen_name"];
                 [parameters setObject:@"100" forKey:@"per_page"];
                 [parameters setObject:@"true" forKey:@"include_entities"];
                 
                 SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1/lists/statuses.json"] parameters:parameters];
                 [twitterInfoRequest setAccount:twitterAccount];
                 
                 // Making the request
                 [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // Check if we reached the reate limit
                         if ([urlResponse statusCode] == 429)
                         {
                             //NSLog(@"Rate limit reached");
                             [document.managedObjectContext performBlock:^{
                                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Rate Limit Reached" message:@"Twitter allows a maximum of 116 refreshes per hour per Twitter Account. Please try again later, or if you have received this message in error, please let us know at msu2u@mwsu.edu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
                             return;
                         }
                         // Check if there was an error
                         if (error)
                         {
                             //NSLog(@"Error: %@", error.localizedDescription);
                             [document.managedObjectContext performBlock:^{
                                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Download Error" message:@"Hmm, seems there was an error during the download. Ensure you have an active internet connection and try again later. If this problem persists, please let us know at: msu2u@mwsu.edu" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
                             return;
                         }
                         // Check if there is some response data
                         if (responseData)
                         {
                             //THIS IS WHERE I ACTUALLY HAVE ALL OF THE TWEETS
                             NSError *error = nil;
                             NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                             
                             [document.managedObjectContext performBlock:^{
                                 for(NSDictionary * dataInfo in TWData)
                                 {
                                     [Tweet tweetWithInfo:dataInfo isProfile:TRUE inManagedObjectContext:document.managedObjectContext];
                                 }
                             }];
                         }
                     });
                 }];
                 
                 //Make another request for @MidwesternState
                 // Making the request
                 NSMutableDictionary * newParameters = [[NSMutableDictionary alloc]init];
                 [newParameters setObject:@"midwesternstate" forKey:@"screen_name"];
                 [newParameters setObject:@"1" forKey:@"include_rts"];
                 [newParameters setObject:@"25" forKey:@"count"];
                 twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"] parameters:newParameters];
                 [twitterInfoRequest setAccount:twitterAccount];
                 
                 [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // Check if we reached the reate limit
                         if ([urlResponse statusCode] == 429)
                         {
                             NSLog(@"Rate limit reached");
                             [document.managedObjectContext performBlock:^{
                                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Rate Limit Reached" message:@"A Maximum of 116 refreshes per hour per Twitter Account is allowed. Please try again later, or if you have received this message in error, please let us know at msu2u@mwsu.edu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
                             return;
                         }
                         // Check if there was an error
                         if (error)
                         {
                             NSLog(@"Error: %@", error.localizedDescription);
                             [document.managedObjectContext performBlock:^{
                                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Download Error" message:@"Hmm, seems there was an error during the download. Ensure you have an active internet connection and try again later. If this problem persists, please let us know at: msu2u@mwsu.edu" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
                             return;
                         }
                         // Check if there is some response data
                         if (responseData)
                         {
                             NSError *error = nil;
                             NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                             
                             [document.managedObjectContext performBlock:^{
                                 for(NSDictionary * dataInfo in TWData)
                                 {
                                     [Tweet tweetWithInfo:dataInfo isProfile:TRUE inManagedObjectContext:document.managedObjectContext];
                                 }
                             }];
                         }
                     });
                 }];
                 //Make Another Request for #SocialStampede
                 NSMutableDictionary * newestParameters = [[NSMutableDictionary alloc]init];
                 [newestParameters setObject:@"socialstampede+OR+midwesternstate+OR+msu2u+OR+ClubMoffett+OR+CSCAtrium+OR+wichitanonline" forKey:@"q"];
                 
                 twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"http://search.twitter.com/search.json"] parameters:newestParameters];
                 [twitterInfoRequest setAccount:twitterAccount];
                 
                 [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // Check if we reached the reate limit
                         if ([urlResponse statusCode] == 429)
                         {
                             NSLog(@"Rate limit reached");
                             [document.managedObjectContext performBlock:^{
                                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Rate Limit Reached" message:@"A Maximum of 116 refreshes per hour per Twitter Account is allowed. Please try again later, or if you have received this message in error, please let us know at msu2u@mwsu.edu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
                             return;
                         }
                         // Check if there was an error
                         if (error)
                         {
                             NSLog(@"Error: %@", error.localizedDescription);
                             [document.managedObjectContext performBlock:^{
                                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Download Error" message:@"Hmm, seems there was an error during the download. Ensure you have an active internet connection and try again later. If this problem persists, please let us know at: msu2u@mwsu.edu" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
                             return;
                         }
                         // Check if there is some response data
                         if (responseData)
                         {
                             NSError *error = nil;
                             NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                             NSDictionary * results = TWData;
                             NSArray *realResults = [results objectForKey:@"results"];
                             
                             // Filter the preferred data
                             [document.managedObjectContext performBlock:^{
                                 for(NSDictionary * dataInfo in realResults)
                                 {
                                     [Tweet tweetWithInfo:dataInfo isProfile:FALSE inManagedObjectContext:document.managedObjectContext];
                                 }
                             }];
                         }
                     });
                 }];
             }
         }
         else
         {
             //User does not have a Twitter Account setup on their device
             [self purgeAllEntitiesOfType:@"Tweet"];
             //NSLog(@"No Twitter Account");
             [document.managedObjectContext performBlock:^{
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Setup Twitter Account" message:@"Please add a Twitter account in Settings and ensure that MSU2U has permission to access your Twitter account in order to use this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Help", nil];
                 [alert show];
             }];
             //Set my table background image!!!
             /*
             UIImageView *tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
             [tempImg setImage:[UIImage imageNamed:@"twitterNoAccount.png"]];
             [self.tableView setBackgroundView:tempImg];
             self.tableView.separatorColor = [UIColor clearColor];*/
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //nothing, OK was pressed
    }else if (buttonIndex == 1){
        webViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
        UIStoryboardSegue * segue = [[UIStoryboardSegue alloc]initWithIdentifier:@"toWebView" source:self destination:myController];
        //[self.navigationController pushViewController:myController animated:YES];
        [segue.destinationViewController sendURL:@"http://www.youtube.com/watch?v=TQk7a5rQm_s" andTitle:@"Twitter Setup" andMessagePrefix:@"How to Setup Twitter iOS Integration for iOS 5 and later."];
        [self.navigationController pushViewController:myController animated:YES];
        //[[segue.destinationViewController sendURL:[NSString stringWithFormat:@"http://www.twitter.com/%@/status/%@",[self.dataObject screen_name],[self.dataObject max_id]] andTitle:[self.dataObject screen_name] andMessagePrefix:[NSString stringWithFormat:@"Tweet from %@",[self.dataObject screen_name]]];
    }
}

-(NSDate*)convertString:(NSString*)string toDateWithFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:cst];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    [dateFormatter setDateFormat: format];
    
    NSDate *myDate = [dateFormatter dateFromString:string];
    return myDate;
}

-(NSDate*)getDateFor:(NSString*)timePeriod
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
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setMonth:-6];
    NSDate *lastSemester = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];

    NSDateComponents *componentsToSubtract2 = [[NSDateComponents alloc] init];
    [componentsToSubtract2 setYear:-1];
    NSDate * lastYear = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract2 toDate:[NSDate date] options:0];
    
    NSDateComponents *comp3 = [[NSDateComponents alloc]init];
    [comp3 setDay:-7];
    NSDate * lastWeek = [[NSCalendar currentCalendar] dateByAddingComponents:comp3 toDate:[NSDate date] options:0];
    
    //NSLog(@"Last week is %@\n",lastWeek);
    
    if([timePeriod isEqualToString:@"today"])
        return today;
    else if([timePeriod isEqualToString:@"yesterday"])
        return yesterday;
    else if([timePeriod isEqualToString:@"lastWeek"])
        return lastWeek;
    else if([timePeriod isEqualToString:@"thisWeek"])
        return thisWeek;
    else if([timePeriod isEqualToString:@"thisMonth"])
        return thisMonth;
    else if([timePeriod isEqualToString:@"lastMonth"])
        return lastMonth;
    else if([timePeriod isEqualToString:@"lastYear"])
        return lastYear;
    else if([timePeriod isEqualToString:@"lastSemester"])
        return lastSemester;
    else
        return [NSDate date];
}

-(void)purgeEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate
{
    __block void (^block)(void) = ^{
        //Fetch all of the specified entities from Core Data
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.myDatabase.managedObjectContext];
        [request setEntity:entity];
        NSError *error;
        
        //Set the predicate, similar to the concept of an SQL query
        [request setPredicate:predicate];
        NSArray *results = [self.myDatabase.managedObjectContext executeFetchRequest:request error:&error];
        
        //NSLog(@"I think %d articles are going to get deleted!\n",[results count]);
        //Delete all of the objects that meet the predicate's requirements
        for (NSManagedObject * n in results) {
            [self.myDatabase.managedObjectContext deleteObject:n];
        }
    };
    [self.myDatabase.managedObjectContext performBlock:block];
}

-(void)setupFetchedResultsController
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    
    //### What should I show in my table?
    //Events
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
        switch(self.showTweetsForIndex)
        {
            case 0:
            {
                //do nothing because I want to show all Tweets
                break;
            }
            case 1:
            {
                //show ONLY 'msu2u_devteam' tweets
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"screen_name LIKE[c] 'msu2u_devteam'"];
                [request setPredicate:predicate];
                break;
            }
        }
    }
    //NEWS
    else if(self.childNumber == [NSNumber numberWithInt:3])
    {
        //Delete all News articles that are older than 1 month
        NSPredicate * deletePredicate = [NSPredicate predicateWithFormat:@"pub_date <= %@",[self getDateFor:@"lastMonth"]];
        [self purgeEntity:self.entityName withPredicate:deletePredicate];
        
        //Now figure out what to show
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
                //show ONLY 'Museum' related news
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"publication LIKE[c] 'WF Museum of Art'"];
                [request setPredicate:predicate];
                break;
            }
        }
    }
    //Video
    else if(self.childNumber == [NSNumber numberWithInt:8])
    {
        //Delete all Videos that are older than 1 year old
        NSPredicate * deletePredicate = [NSPredicate predicateWithFormat:@"upload_date <= %@",[self getDateFor:@"lastYear"]];
        [self purgeEntity:self.entityName withPredicate:deletePredicate];
        
        switch(self.showVideoForIndex)
        {
            case 0:
            {
                break;
            }
            case 1:
            {
                //show ONLY 'Vimeo' videos
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"source LIKE[c] 'Vimeo'"];
                [request setPredicate:predicate];
                break;
            }
            case 2:
            {
                //show ONLY 'YouTube' videos
                NSPredicate * predicate;
                predicate = [NSPredicate predicateWithFormat:@"source LIKE[c] 'YouTube'"];
                [request setPredicate:predicate];
                break;
            }
        }
    }
    //Podcast
    else if(self.childNumber == [NSNumber numberWithInt:9])
    {
        //Delete all podcasts that are older than 6 months
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pubDate <= %@",[self getDateFor:@"lastMonth"]];
        [self purgeEntity:self.entityName withPredicate:predicate];
        
        switch(self.showPodcastForIndex)
        {
            case 0:
            {
                break;
            }
            case 1:
            {
                //Show Podcasts only from the last week
                 NSPredicate * predicate;
                 predicate = [NSPredicate predicateWithFormat:@"pubDate >= %@",[self getDateFor:@"lastWeek"]];
                 [request setPredicate:predicate];
                 break;
            }
        }
    }
    
    //2. How should I sort the data in my table?
    //IF NOT TWITTER AND NOT EVENTS AND NOT NEWS, SORT TABLE BY SOMETHING THAT IS NOT A DATE
    if(self.childNumber != [NSNumber numberWithInt:7] && self.childNumber != [NSNumber numberWithInt:2] && self.childNumber != [NSNumber numberWithInt:3] && self.childNumber != [NSNumber numberWithInt:8] && self.childNumber != [NSNumber numberWithInt:9])
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    //SORT TABLE BY DATES FROM NEWEST TO OLDEST
    else if(self.childNumber == [NSNumber numberWithInt:7] || self.childNumber == [NSNumber numberWithInt:3] || self.childNumber == [NSNumber numberWithInt:8] || self.childNumber == [NSNumber numberWithInt:9])
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:NO]];
    //SORT TABLE BY DATES FROM OLDEST TO NEWEST
    else
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorKey ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.myDatabase.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    //NSLog(@"I fetched my data for this table!");
    
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
        else if(self.childNumber == [NSNumber numberWithInt:8])
        {
            if(self.showVideoForIndex == 0)
                [self refresh];
        }
        else if(self.childNumber == [NSNumber numberWithInt:9])
        {
            if(self.showPodcastForIndex == 0)
                [self refresh];
        }
        else
        {
            NSLog(@"!@#!@# WHAT AM I TRYING TO REFRESH???\n");
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
    //NSLog(@"Hello?????\n");
    //Set debug to TRUE for the CoreDataTableViewController class
    self.debug = TRUE;
    
    //Refresh Control
    //Make sure the Directory Favorites and Directory History do NOT have the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:(55.0/255.0) green:(7.0/255.0) blue:(16.0/255.0) alpha:1];
    
    //Retrieve the user defaults so that the last update for this table may be retrieved and shown to the user
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    //NSLog(@"Setting refresh controls...\n");
    //Set the refresh control attributed string to the retrieved last update
    switch([self.childNumber integerValue])
    {
        case 2:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"eventsRefreshTime"]];break;
        case 3:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"newsRefreshTime"]];break;
        case 4:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"directoryRefreshTime"]];break;
        case 7:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"twitterRefreshTime"]];break;
        case 8:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"videoRefreshTime"]];break;
        case 9:refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[defaults objectForKey:@"podcastRefreshTime"]];break;
        default:NSLog(@"My child number is %@\n",self.childNumber);
    }
    
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
    //NSLog(@"Setting up the fetched data arrays to be empty...\n");
    //Setup the arrays which will be used to hold the Core Data for the respective Table View Controller
    self.dataArray = [[NSMutableArray alloc]initWithObjects:nil];
    self.filteredDataArray = [[NSMutableArray alloc]initWithObjects:nil];
    
    //I did have the [super viewWillAppear:animated]; right here before.
    //NSLog(@"Checking if I should fetch...\n");
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

-(void)purgeAllEntitiesOfType:(NSString*)entityName
{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do your long-running task here
    __block void (^block)(void) = ^{
        //NSLog(@"About to purge...\n");
        NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
        [allCars setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.myDatabase.managedObjectContext]];
        [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * cars = [self.myDatabase.managedObjectContext executeFetchRequest:allCars error:&error];
        
        //error handling goes here
        for (NSManagedObject * car in cars) {
            [self.myDatabase.managedObjectContext deleteObject:car];
        }
        NSError *saveError = nil;
        [self.myDatabase.managedObjectContext save:&saveError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do callbacks to any UI updates here, like for a status indicator
        });
    //});
    };
    
    [self.myDatabase.managedObjectContext performBlock:block];
}

-(void) downloadAllEntities
{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //SECOND, GET THE NEW DATA
    [self fetchDataFromOnline:self.myDatabase];
    
    //Set the attributable string for the refresh control
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    //Save this update string to the user defaults
    [self saveRefreshTime:lastUpdated];
    //});
}

-(void) refresh
{
    //Certain types of data I want to remove all of them during a refresh
    //[self purgeAllEntitiesOfType:self.entityName];
    switch([self.childNumber intValue])
    {
        //Events are at high risk of being re-scheduled on the fly, so it's safest to just delete all and put the new events in.
        case 2: [self purgeAllEntitiesOfType:self.entityName];break;
        
        //News will check to see if anything about itself has changed and make those changes individually
        //case 3: [self purgeAllEntitiesOfType:self.entityName];break;
        
        //Employee
        //case 4: [self purgeAllEntitiesOfType:self.entityName];break;
        
        //Video
        //case 8: [self purgeAllEntitiesOfType:self.entityName];break;
            
        //Podcast
        //case 9: [self purgeAllEntitiesOfType:self.entityName];break;
        
        //Tweet
        case 7: [self purgeAllEntitiesOfType:self.entityName];break;
        
        //default: NSLog(@"Reached default condition in refresh\n");break;
    }
    [self downloadAllEntities];
}

-(void)saveRefreshTime:(NSString*)refreshTime
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    switch([self.childNumber integerValue])
    {
        case 2:[defaults setObject:refreshTime forKey:@"eventsRefreshTime"];break;
        case 3:[defaults setObject:refreshTime forKey:@"newsRefreshTime"];break;
        case 4:[defaults setObject:refreshTime forKey:@"directoryRefreshTime"];break;
        case 7:[defaults setObject:refreshTime forKey:@"twitterRefreshTime"];break;
        case 8:[defaults setObject:refreshTime forKey:@"videoRefreshTime"];break;
        case 9:[defaults setObject:refreshTime forKey:@"podcastRefreshTime"];break;
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
            for (Game * currentEvents in [self.fetchedResultsController fetchedObjects])
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
        else if(self.childNumber == [NSNumber numberWithInt:8])
            for(Video * currentVideos in [self.fetchedResultsController fetchedObjects])
                count++;
        else if(self.childNumber == [NSNumber numberWithInt:9])
            for(Podcast * currentPodcasts in [self.fetchedResultsController fetchedObjects])
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
            else if([[self.dataObject publication] isEqualToString:@"WF Museum of Art"])
            {
                defaultImage = @"wfma50x50.png";
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
        
        //Twitter profile images could change often, so remove from the cache and force a redownload
        [[SDImageCache sharedImageCache] removeImageForKey:[self.dataObject profile_image_url] fromDisk:YES];
        [cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject profile_image_url]] placeholderImage:[UIImage imageNamed:@"twitter.png"] options:0 andResize:CGSizeMake(50, 50)];
        CGSize size = {50,50};
        cell.imageView.image = [self imageWithImage:cell.imageView.image scaledToSize:size];
    }
    else if(self.childNumber == [NSNumber numberWithInt:8])
    {
        cell.textLabel.text = [self.dataObject title];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ by %@",[NSDateFormatter localizedStringFromDate:[self.dataObject upload_date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],[self.dataObject user_name]];
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:[self.dataObject thumbnail_small]] placeholderImage:[UIImage imageNamed:@"70-tv.png"] options:0 andResize:CGSizeMake(107, 68)];
        CGSize size = {107,68};
        cell.imageView.image = [self imageWithImage:cell.imageView.image scaledToSize:size];
    }
    else if(self.childNumber == [NSNumber numberWithInt:9])
    {
        cell.textLabel.text = [self.dataObject title];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Posted on %@ by %@",[NSDateFormatter localizedStringFromDate:[self.dataObject pubDate] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle],[self.dataObject author]];
        
        if([[self.dataObject author] isEqualToString:@"MSUMustangs.com"])
        {
            [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://www.msumustangs.com/images/logos/m6.png"] placeholderImage:[UIImage imageNamed:@"70-tv.png"] options:0 andResize:CGSizeMake(50, 50)];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"podcast_default.png"];
        }
        
        //Resize image
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
    //NSLog(@"My child number is %@\n",self.childNumber);

    if(self.childNumber == [NSNumber numberWithInt:2])
        [segue.destinationViewController sendGameInformation:self.dataObject];
    else if(self.childNumber == [NSNumber numberWithInt:3])
    {
        //[segue.destinationViewController sendNewsInformation:self.dataObject];
        [segue.destinationViewController sendURL:[self.dataObject link] andTitle:[self.dataObject publication] andMessagePrefix:[self.dataObject title]];
        
        //SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[self.dataObject link]];
        //[self.navigationController pushViewController:webViewController animated:YES];
    }
    else if(self.childNumber == [NSNumber numberWithInt:4])
    {
        //NSLog(@"My dataObject person_id is %@\n",[self.dataObject person_id]);
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
        //NSLog(@"Going to http://www.twitter.com/%@/status/%@",[self.dataObject screen_name],[self.dataObject max_id]);
        [segue.destinationViewController sendURL:[NSString stringWithFormat:@"http://www.twitter.com/%@/status/%@",[self.dataObject screen_name],[self.dataObject max_id]] andTitle:[self.dataObject screen_name] andMessagePrefix:[NSString stringWithFormat:@"Tweet from %@",[self.dataObject screen_name]]];
        
    }
    else if(self.childNumber == [NSNumber numberWithInt:8])
    {
        //NSLog(@"Going to video link...%@",[self.dataObject url]);
        [segue.destinationViewController sendURL:[self.dataObject url] andTitle:[self.dataObject user_name] andMessagePrefix:[self.dataObject title]];
    }
    else if(self.childNumber == [NSNumber numberWithInt:9])
    {
        [segue.destinationViewController sendURL:[self.dataObject link] andTitle:[self.dataObject title] andMessagePrefix:[self.dataObject title]];
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
        for (Game *currentEvents in [self.fetchedResultsController fetchedObjects])
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
        for (Tweet *currentTweets in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentTweets];
    }
    else if(self.childNumber == [NSNumber numberWithInt:8])
    {
        for (Video *currentVideos in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentVideos];
    }
    else if(self.childNumber == [NSNumber numberWithInt:9])
    {
        for (Podcast * currentPodcasts in [self.fetchedResultsController fetchedObjects])
            [self.dataArray addObject:currentPodcasts];
    }
    
    //###### Filter the array using NSPredicate
    NSArray * tempArray = [[NSArray alloc]init];
    NSArray *words = [searchText componentsSeparatedByString:@" "];
    NSMutableArray *predicateList = [NSMutableArray array];
    for (NSString *word in words) {
        if ([word length] > 0) {
            NSString * buildingMyPredicate = [[NSString alloc]init];
            for(int i=0; i<[self.keysToSearchOn count]; i++)
            {
                NSString *escaped = [word stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
                if((i+1) != [self.keysToSearchOn count])
                {
                    buildingMyPredicate = [buildingMyPredicate stringByAppendingString:[NSString stringWithFormat:@"SELF.%@ CONTAINS[c] '%@' OR ",[self.keysToSearchOn objectAtIndex:i],escaped]];
                }
                else
                {
                    buildingMyPredicate = [buildingMyPredicate stringByAppendingString:[NSString stringWithFormat:@"SELF.%@ CONTAINS[c] '%@'",[self.keysToSearchOn objectAtIndex:i],escaped]];
                }
            }
            NSPredicate *pred = [NSPredicate predicateWithFormat:buildingMyPredicate];
            [predicateList addObject:pred];
        }
    }
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
    //NSLog(@"%@", predicate);
    tempArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    
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
