//
//  detailNewsViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/5/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailNewsViewController.h"

@interface detailNewsViewController ()
@end

@implementation detailNewsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set all of the text labels
    self.titleLabel.text = receivedNews.title;
    self.authorLabel.text = receivedNews.doc_creator;
    self.description.text = receivedNews.long_description;
    self.categoryLabel.text = receivedNews.category_1;
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:receivedNews.last_changed dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    //Download the image in a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
}

-(void)downloadImage
{
    receivedNews.image = [receivedNews.image stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.photo setImageWithURL:[NSURL URLWithString:receivedNews.image]
                           placeholderImage:[UIImage imageNamed:@"wichitanLogo.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)sendNewsInformation:(News *)news
{
    receivedNews = news;
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender {
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:receivedNews.link];
    SHKItem *item = [SHKItem URL:url title:receivedNews.title contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showInView:self.view];
}
@end
