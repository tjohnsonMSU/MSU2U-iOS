//
//  addEventToCalendar.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/2/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface addEventToCalendar : UITableViewController{
    EKEventStore * eventStore;
}
@property (weak,nonatomic) NSString * title;
@property (weak,nonatomic) NSString * startDate;
@property (weak,nonatomic) NSString * startTime;

-(void) addEventToMainCalendar;

@end
