//
//  emergencyNumbersViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/24/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webViewController.h"
@interface emergencyNumbersViewController : UITableViewController{
    NSArray * emergencyNumber;
    int chosenRow, chosenSection;
}

@end
