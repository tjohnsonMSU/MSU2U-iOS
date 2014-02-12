//
//  addEventToCalendar.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/2/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface addEventToCalendar : UIViewController{
    EKEventStore * eventStore;
}
@property (weak,nonatomic) NSString * calendarEventTitle;
@property (retain,nonatomic) NSDate * calendarEventStartDate;
@property (retain,nonatomic) NSDate * calendarEventEndDate;

-(void) addEventToMainCalendar;

@end
