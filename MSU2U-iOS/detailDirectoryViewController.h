//
//  detailDirectoryViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/4/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Employee+Create.h"
#import "MYDocumentHandler.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
@interface detailDirectoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray* tableLabel;
    NSArray* tableContent;
}

-(void)sendEmployeeInformation:(Employee*)employeeInfo;

-(void)makePhoneCall;

@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITableView *contactTable;
@property (nonatomic, strong) UIManagedDocument * directoryDatabase;
@property (strong, nonatomic) IBOutlet UIImageView *favoriteView;

- (IBAction)favoriteButton:(UIBarButtonItem *)sender;
- (void)putEmployeeInHistory;

@end
