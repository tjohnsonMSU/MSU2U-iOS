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

-(void) sendURL:(NSString *)x andTitle:(NSString *)y
{
    websiteURL = x;
    self.title = y;
}

@end
