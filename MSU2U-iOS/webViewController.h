//
//  webViewController.h
//  MSU2U-iOS
//
//  Created by cmpsinstructor on 4/16/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController{
    NSString * websiteURL;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void) sendURL:(NSString*)x;

@end
