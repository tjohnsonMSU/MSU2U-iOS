//
//  mainMenuViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 10/14/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "logPrinter.h"

@interface mainMenuViewController : UITableViewController <UIScrollViewDelegate>{
    logPrinter * log;
}

@end
