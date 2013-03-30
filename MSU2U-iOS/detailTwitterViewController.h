//
//  detailTwitterViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Tweet+Create.h"
#import <Social/Social.h>

@interface detailTwitterViewController : UIViewController{
    Tweet * receivedTweet;
}

@property (weak, nonatomic) IBOutlet UIImageView *profile_image_url;
@property (weak, nonatomic) IBOutlet UIImageView *profile_background_image_url;
@property (weak, nonatomic) IBOutlet UILabel *screen_name;
@property (weak, nonatomic) IBOutlet UILabel *created_at;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UITextView *text;
- (IBAction)retweet:(UIButton *)sender;

-(void)sendTweetInformation:(Tweet*)tweetInfo;

@end
