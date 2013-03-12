//
//  detailTwitterViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "detailTwitterViewController.h"

@interface detailTwitterViewController ()

@end

@implementation detailTwitterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Set the labels
    self.screen_name.text = receivedTweet.screen_name;
    self.created_at.text = receivedTweet.created_at;
    self.name.text = receivedTweet.name;
    self.text.text = receivedTweet.text;
    
    //Download the images
    [self downloadImage];
}

-(void)downloadImage
{
    receivedTweet.profile_image_url = [receivedTweet.profile_image_url stringByReplacingOccurrencesOfString:@" " withString:@""];
    receivedTweet.profile_background_image_url = [receivedTweet.profile_background_image_url stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.profile_image_url setImageWithURL:[NSURL URLWithString:receivedTweet.profile_image_url]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self.profile_background_image_url setImageWithURL:[NSURL URLWithString:receivedTweet.profile_background_image_url]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)sendTweetInformation:(Tweet *)tweetInfo
{
    receivedTweet = tweetInfo;
}

- (IBAction)retweet:(UIButton *)sender {
}

- (IBAction)comment:(UIButton *)sender {
}
@end
