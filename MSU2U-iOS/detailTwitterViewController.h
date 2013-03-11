//
//  detailTwitterViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailTwitterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profile_image;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UITextView *text;
- (IBAction)retweet:(UIButton *)sender;
- (IBAction)comment:(UIButton *)sender;
@end
