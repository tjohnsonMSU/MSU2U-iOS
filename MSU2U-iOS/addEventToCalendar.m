//
//  addEventToCalendar.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/2/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "addEventToCalendar.h"

@implementation addEventToCalendar

-(void) addEventToMainCalendar
{
    NSLog(@"Attempting to add this event to calendar: %@, %@\n",self.calendarEventTitle,self.calendarEventStartDate);
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = self.calendarEventTitle;
    
    event.startDate = self.calendarEventStartDate;
    event.endDate   = self.calendarEventEndDate;
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    
    //Figure out if this event date is in the past. If so, don't add it and let the user know you didn't add it and why!
    UIAlertView *alert;
    if([self isFutureDay:self.calendarEventStartDate])
    {
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
        if (!err)
        {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Event Created Successfully!"
                     message:self.calendarEventTitle
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        }
    }
    else
    {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Event Creation Failed"
                 message:@"Can't add a past event to calendar"
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
    }
    [alert show];
}

- (BOOL)isFutureDay:(NSDate*)eventDate
{
    NSDate *today = [NSDate date]; // it will give you current date
    NSLog(@"Today's Date: %@\n",today);
    NSDate *newDate = eventDate; // your date
    NSLog(@"Event Date: %@\n",eventDate);
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:newDate]; // comparing two dates
    
    if(result==NSOrderedDescending)
        return false;
    else
        return true;
}

@end
