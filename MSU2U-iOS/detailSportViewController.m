//
//  detailSportViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailSportViewController.h"

@interface detailSportViewController ()
@property (weak, nonatomic) NSString* receivedTitle;
@property (weak, nonatomic) NSString* receivedStartTime;
@property (weak, nonatomic) NSString* receivedDescription;
@property (weak, nonatomic) NSString* receivedLink;
@property (weak, nonatomic) NSString* receivedEvgameid;
@property (weak, nonatomic) NSString* receivedEvlocation;
@property (weak, nonatomic) NSString* receivedStartDate;
@property (weak, nonatomic) NSString* receivedEndDate;
@property (weak, nonatomic) NSString* receivedSteamLogo;
@property (weak, nonatomic) NSString* receivedSopponentLogo;
@end

@implementation detailSportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Remove the default background from my table view
    self.sportTable.backgroundColor = [UIColor clearColor];
    self.sportTable.opaque = NO;
    self.sportTable.backgroundView = nil;
    
    //Initialize my arrays which will be used to populate data into my table rows
    tableLabel = [[NSArray alloc]initWithObjects:@"title",@"start date",@"start time",@"location",nil];
    tableContent = [[NSArray alloc]initWithObjects:self.receivedTitle,self.receivedStartDate,self.receivedStartTime,self.receivedEvlocation,nil];
    
    self.title = self.receivedStartDate;
    
    //Setup all the images
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
}

-(void)sendSportInformation:(Sport *)sportInfo
{
    self.receivedStartTime = sportInfo.startTime;
    self.receivedTitle = sportInfo.title;
    self.receivedDescription = sportInfo.content;
    self.receivedLink = sportInfo.link;
    self.receivedEvgameid = sportInfo.evgameid;
    self.receivedEvlocation = sportInfo.evlocation;
    self.receivedStartDate = sportInfo.startDate;
    self.receivedEndDate = sportInfo.endDate;
    self.receivedSteamLogo = sportInfo.steamLogo;
    self.receivedSopponentLogo = sportInfo.sopponentlogo;
    
    //For my table content, make sure the received information is not null or blank. If so, set it to N/A so my table view won't crash.
    if([self.receivedTitle length] == 0) self.receivedTitle = @"N/A";
    if([self.receivedStartDate length] == 0) self.receivedStartDate = @"N/A";
    if([self.receivedStartTime length] == 0) self.receivedStartTime = @"N/A";
    if([self.receivedEvlocation length] == 0) self.receivedEvlocation = @"N/A";
}

-(void)downloadImage
{
    NSLog(@"I received %@ (home) and %@ (away) as my logo links!\n",self.receivedSteamLogo,self.receivedSopponentLogo);
    self.receivedSteamLogo = [self.receivedSteamLogo stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.receivedSopponentLogo = [self.receivedSopponentLogo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.homePhoto setImageWithURL:[NSURL URLWithString:self.receivedSteamLogo]
               placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self.awayPhoto setImageWithURL:[NSURL URLWithString:self.receivedSopponentLogo]
                   placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//TABLE METHODS
-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Identifier for retrieving reusable cells
    NSString * cellIdentifier;
    if(indexPath.row != 3)
    {
        cellIdentifier = @"sportCell";
    }
    else
    {
        cellIdentifier = @"athleticLocationCell";
    }
    
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
@end
