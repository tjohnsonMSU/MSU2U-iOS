//
//  campusMapInfoViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/3/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface campusMapInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress;
@property (weak, nonatomic) IBOutlet UIImageView *locationPhoto;
@property (weak, nonatomic) IBOutlet UITextView *locationDescription;

@property (weak, nonatomic) IBOutlet UIButton *locationPhone;
- (IBAction)callLocation:(UIButton *)sender;

-(void)sendLocationName:(NSString*)receivedLocationName;
@end
