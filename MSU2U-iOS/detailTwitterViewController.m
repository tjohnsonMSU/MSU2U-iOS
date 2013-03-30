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
    self.created_at.text = [NSDateFormatter localizedStringFromDate:receivedTweet.created_at dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
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
                  placeholderImage:[UIImage imageNamed:@"twitterBG.png"]];
    [self.profile_background_image_url setImageWithURL:[NSURL URLWithString:receivedTweet.profile_background_image_url]
                  placeholderImage:[UIImage imageNamed:@"twitterBG.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)retweet:(UIButton *)sender {
    NSLog(@"Tweet tweet said the bird!\n");
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#SocialStampede "];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Please setup a Twitter Account for your device (Settings > Twitter) and ensure you have an internet connection and try again! :)"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)sendTweetInformation:(Tweet *)tweetInfo
{
    receivedTweet = tweetInfo;
}

@end
