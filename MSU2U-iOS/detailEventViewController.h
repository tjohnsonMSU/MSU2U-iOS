//
//  detailEventViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+Create.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "campusMapViewController.h"

@interface detailEventViewController : UITableViewController

-(void)sendEventInformation:(Event*)eventInfo;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
