//
//  webViewController.m
//  MSU2U-iOS
//
//  Created by cmpsinstructor on 4/16/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()

@end

@implementation webViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create a URL from the string provided in 'sendURL'
    NSURL *url = [NSURL URLWithString:websiteURL];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //[self.webView loadHTMLString:websiteURL baseURL:nil];
    [self.webView loadRequest:requestObj];
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender
{
    // Create the item to share (in this example, a url)
    SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ %@",messagePrefix, websiteURL]];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void) sendURL:(NSString *)x andTitle:(NSString *)y andMessagePrefix:(NSString *)z
{
    websiteURL = x;
    self.title = y;
    messagePrefix = z;
}

@end
