//
//  detailGameType2ViewController.h
//  MSU2U-iOS
//
//  Created by Hieu Tran on 1/22/14.
//  Copyright (c) 2014 Matthew Farmer. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Game+Create.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "campusMapViewController.h"
#import "addEventToCalendar.h"


@interface detailGameType2ViewController : UITableViewController{
    Game * receivedGame;

}

-(void)sendGameInformation:(Game*)gameInfo;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundPhoto;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *homePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *awayPhoto;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *startingDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *homeTeamName;
@property (strong, nonatomic) IBOutlet UILabel *awayTeamName;
@property (weak, nonatomic) IBOutlet UILabel *hostPlaceName;

- (IBAction)sharePressed:(UIBarButtonItem *)sender;

@end
