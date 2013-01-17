//
//  webViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/15/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController
-(void)sendWebsiteToVisit:(NSString *)websiteURL;
- (IBAction)shareButton:(id)sender;
@end
