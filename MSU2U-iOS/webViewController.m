//
//  webViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/15/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()
@property (strong, nonatomic) NSString * receivedURL;
@property (strong, nonatomic) NSString * receivedTitle;
@end

@implementation webViewController

-(void)sendWebsiteToVisit:(NSString *)websiteURL andTitle:(NSString *)websiteTitle
{
    //Capture the URL for use in another method
    self.receivedURL = websiteURL;
    self.receivedTitle = websiteTitle;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSURL *targetURL = [NSURL URLWithString:websiteURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

- (IBAction)shareButton:(id)sender {
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:self.receivedURL];
    
    SHKItem *item;
    
    if([self.receivedTitle length] == 0)
    {
        self.receivedTitle = @"Unknown";
    }
    else
    {
        item = [SHKItem URL:url title:self.receivedTitle contentType:SHKURLContentTypeWebpage];
    }
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showInView:self.view];
}

@end
