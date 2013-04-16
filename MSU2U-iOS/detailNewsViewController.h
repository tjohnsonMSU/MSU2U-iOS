//
//  detailNewsViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/5/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News+Create.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "webViewController.h"
//ShareKit
#import "SHK.h"

@interface detailNewsViewController : UIViewController{
    News * receivedNews;
}

-(void)sendNewsInformation:(News*)news;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *description;
- (IBAction)sharePressed:(UIBarButtonItem *)sender;
- (IBAction)viewArticleOnline:(UIButton *)sender;
@end
