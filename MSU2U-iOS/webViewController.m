//
//  webViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/15/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()

@end

@implementation webViewController

-(void)sendWebsiteToVisit:(NSString *)websiteURL
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSURL *targetURL = [NSURL URLWithString:websiteURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    
    
    [self.view addSubview:webView];
}

- (IBAction)shareButton:(id)sender {
}

@end
