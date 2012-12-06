//
//  detailEventViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailEventViewController.h"

@interface detailEventViewController ()
@property (weak, nonatomic) NSString* receivedTitle;
@property (weak, nonatomic) NSString* receivedStartTime;
@property (weak, nonatomic) NSString* receivedDescription;
@property (weak, nonatomic) NSString* receivedLink;
@property (weak, nonatomic) NSString* receivedEvgameid;
@property (weak, nonatomic) NSString* receivedEvlocation;
@property (weak, nonatomic) NSString* receivedStartDate;
@property (weak, nonatomic) NSString* receivedEndDate;
@end

@implementation detailEventViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.descriptionTextView.text = self.receivedDescription;
    self.titleLabel.text = self.receivedTitle;
    
    if([self.receivedStartDate length]==0)
    {
        self.receivedStartDate = @"";
    }
    if([self.receivedStartTime length]==0)
    {
        self.receivedStartTime = @"";
    }
    NSString * timeDate = self.receivedStartDate;
    timeDate = [timeDate stringByAppendingString:@" at "];
    timeDate = [timeDate stringByAppendingString:self.receivedStartTime];
    
    self.timeDateLabel.text = timeDate;
    self.locationLabel.text = self.receivedEvlocation;
}

-(void)sendEventInformation:(Event*)eventInfo
{
    self.receivedTitle = eventInfo.title;
    self.receivedDescription = eventInfo.content;
    self.receivedEndDate = eventInfo.endDate;
    self.receivedStartTime = eventInfo.startTime;
    self.receivedStartDate = eventInfo.startDate;
    self.receivedEvlocation = eventInfo.evlocation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
