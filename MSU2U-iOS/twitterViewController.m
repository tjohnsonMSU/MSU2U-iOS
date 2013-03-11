//
//  twitterViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "twitterViewController.h"

@interface twitterViewController ()
@property (nonatomic, retain) NSMutableArray * socialContent;
@property (nonatomic, retain) NSString * jsonURL;
@property (nonatomic, retain) NSArray * screenName;
@end

@implementation twitterViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.socialContent = [[NSMutableArray alloc]init];
    
    //Figure out which feeds I need to download from
    self.screenName = [[NSArray alloc]initWithObjects:@"MSUMustangs",@"matthewfarm",@"MWSUCampusWatch",@"MidwesternAVP",@"msu2u_devteam",@"WichitanOnline",@"MSUUnivDev",@"#SocialStampede", nil];
    
    //Make some determination if you should download new data or not
    [self fetchDataFromOnline];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)executeDataFetch:(NSString *)query
{
    //Get all of the Tweet Data
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if(error)
        NSLog(@"[!]JSON ERROR in Twitter download!!!\n");
    
    return results;
}

- (NSArray *)downloadCurrentData:(NSString*)jsonURL
{
    NSString *request = [NSString stringWithFormat:jsonURL];
    return [self executeDataFetch:request];
}

-(void)fetchDataFromOnline
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        hud.labelText = @"Refreshing...";
        NSLog(@"self.screenName count is %d\n",[self.screenName count]);
        for(int i=0; i<[self.screenName count]; i++)
        {
            NSLog(@"%d....\n",i);
            
            //Determine if this is a profile or hashtag
            if([[self.screenName objectAtIndex:i] hasPrefix:@"#"])
            {
                //Hashtag
                NSString * hashTag = [[self.screenName objectAtIndex:i]stringByReplacingOccurrencesOfString:@"#" withString:@""];
                self.jsonURL = [@"http://search.twitter.com/search.json?q=%23" stringByAppendingString:hashTag];
                
                //My theory is that, because the hastag search JSON data is not an array, but rather a dictionary, I'll have
                //  to have NSDictionary * results = json ? [.....]
                NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:self.jsonURL] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
                NSLog(@"My screen_name test is %@\n",[[[results objectForKey:@"results"]objectAtIndex:0]objectForKey:@"screen_name"]);
                
                NSArray * myData = [results objectForKey:@"results"];
                for(NSDictionary * dataInfo in myData)
                {
                    tweet * myTweet = [[tweet alloc]init];
                    myTweet.text = [dataInfo objectForKey:@"text"];
                    myTweet.profile_image_url = [dataInfo objectForKey:@"profile_image_url"];
                    myTweet.created_at = [dataInfo objectForKey:@"created_at"];
                    myTweet.screen_name = [dataInfo objectForKey:@"screen_name"];
                    [self.socialContent addObject:myTweet];
                }
            }
            else
            {
                //Profile
                self.jsonURL = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@&include_rts=1",[self.screenName objectAtIndex:i]];
                
                NSArray * myData = [self downloadCurrentData:self.jsonURL];
                for(NSDictionary * dataInfo in myData)
                {
                    tweet * myTweet = [[tweet alloc]init];
                    myTweet.text = [dataInfo objectForKey:@"text"];
                    myTweet.created_at = [dataInfo objectForKey:@"created_at"];
                    myTweet.screen_name = [[dataInfo objectForKey:@"user"] objectForKey:@"screen_name"];
                    myTweet.profile_image_url = [[dataInfo objectForKey:@"user"] objectForKey:@"profile_image_url"];
                    [self.socialContent addObject:myTweet];
                }
            } 
        }
        
        //I will now sort the tweets by date to put the newest ones on top
        [self.socialContent sortUsingDescriptors:[NSArray arrayWithObjects:
                                                  [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:FALSE],
                                                  [NSSortDescriptor sortDescriptorWithKey:@"screen_name" ascending:TRUE],nil]];
        
        NSLog(@"Reload data!\n");
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    
    //If I want to restrict my Twitter feed to contain only the latest tweets regardless of who they are from in my
    //  screenName array, I need to use the following condition. If I have less than 50 tweets, I'll just show everything I've got.
    if([self.socialContent count] > ([self.screenName count]*5))
        rowCount = ([self.screenName count]*5);
    else
        rowCount = [self.socialContent count];
    
    NSLog(@"I'm returning %d rows.\n",rowCount);
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    tweet * temp = [self.socialContent objectAtIndex:indexPath.row];
    cell.textLabel.text = temp.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ by %@",temp.created_at,temp.screen_name];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:temp.profile_image_url]
                   placeholderImage:[UIImage imageNamed:@"Default.png"]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
