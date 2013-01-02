//
//  detailSportViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "campusMapViewController.h"
#import "Sport+Create.h"


@interface detailSportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray* tableLabel;
    NSArray* tableContent;
    UIBarButtonItem * rightButton;
}

@property (weak, nonatomic) IBOutlet UIImageView *awayPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *homePhoto;
@property (weak, nonatomic) IBOutlet UITableView *sportTable;
-(void)sendSportInformation:(Sport*)sportInfo;

@end
