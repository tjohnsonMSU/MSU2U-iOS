//
//  detailNewsViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/5/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailNewsViewController.h"

@interface detailNewsViewController ()
@property (weak,nonatomic) NSString * receivedTitle;
@property (weak,nonatomic) NSString * receivedDescription;
@property (weak,nonatomic) NSString * receivedAuthor;
@property (weak,nonatomic) NSString * receivedDate;
@property (weak,nonatomic) NSString * receivedLink;
@property (weak,nonatomic) NSString * receivedCategory;
@property (weak,nonatomic) NSString * receivedImage;
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
    self.titleLabel.text = self.receivedTitle;
    self.authorLabel.text = self.receivedAuthor;
    self.description.text = self.receivedDescription;
    self.categoryLabel.text = self.receivedCategory;
    self.dateLabel.text = self.receivedDate;
    
    //Download the image in a background thread
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
     */
}

-(void)sendNewsInformation:(News *)news
{
    self.receivedTitle = news.title;
    self.receivedAuthor = news.author;
    self.receivedCategory = news.category;
    self.receivedDescription = news.content;
    self.receivedDate = news.date;
    self.receivedImage = news.image;
    self.receivedLink = news.link;
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender {
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:self.receivedLink];
    SHKItem *item = [SHKItem URL:url title:self.receivedTitle contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showInView:self.view];
}
@end
