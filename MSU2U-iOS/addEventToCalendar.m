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
    //UIAlertView * alert;
    EKEventStore *myEventStore = [[EKEventStore alloc] init];
    if ([myEventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [myEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    // display error message here
                    NSLog(@"Something happened early?!\n");
                    __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Our team is aware of the problem and are working towards a fix soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if (!granted)
                {
                    // display access denied error message here
                    NSLog(@"User does not allow calendar access!\n");
                    __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Calendar Access Required" message:@"Please enable access to your calendar in the Settings > Privacy > Calendars > MSU2U to use this feature" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    EKEvent *event  = [EKEvent eventWithEventStore:myEventStore];
                    event.title     = self.calendarEventTitle;
                    event.startDate = self.calendarEventStartDate;
                    event.endDate   = self.calendarEventEndDate;
                    
                    [event setCalendar:[myEventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [myEventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    if(!err)
                    {
                        NSLog(@"SUCCESS!!!\n");
                        __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:event.title message:@"Event added successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else
                    {
                        NSLog(@"I didn't save successfully :(\n");
                        __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Our team is aware of the problem and are working towards a fix soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
            });
        }];
    }
    else
    {
        // this code runs in iOS 4 or iOS 5
        // ***** do the important stuff here *****
        NSLog(@"Old ios version...\n");
        eventStore=[[EKEventStore alloc] init];
        EKEvent *addEvent=[EKEvent eventWithEventStore:eventStore];
        NSError * err;
        
        addEvent.title=self.calendarEventTitle;
        addEvent.startDate=self.calendarEventStartDate;
        addEvent.endDate=self.calendarEventEndDate;
        
        [addEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
        addEvent.alarms=[NSArray arrayWithObject:[EKAlarm alarmWithAbsoluteDate:addEvent.startDate]];
        [eventStore saveEvent:addEvent span:EKSpanThisEvent error:&err];
        
        if(!err)
        {
            NSLog(@"SUCCESS!!!\n");
            __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:addEvent.title message:@"Event added successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSLog(@"I didn't save successfully :(\n");
            __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"An error occurred" message:@"Our team is aware of the problem and are working towards a fix soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }

}

@end
