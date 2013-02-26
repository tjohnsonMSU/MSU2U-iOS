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
    NSLog(@"Attempting to add this event to calendar: %@, %@\n",self.title,self.startDate);
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = self.title;
    
    //Get the Date prepared
    NSCalendar *greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //Rip apart my receivedStartDate (2013-1-1) to 2013 1 1
    NSArray *dateBits = [self.startDate componentsSeparatedByString: @"-"];
    NSArray *timeBits;
    NSArray *amOrPm;
    if([self.startTime isEqualToString:@"N/A"])
    {
        NSLog(@"There is no start time...\n");
        timeBits = [[NSArray alloc]initWithObjects:@"12", nil];
    }
    else
    {
        NSLog(@"Start time is %@...\n",self.startTime);
        timeBits = [self.startTime componentsSeparatedByString: @":"];
        amOrPm = [[timeBits objectAtIndex:1] componentsSeparatedByString:@" "];
        NSLog(@"amOrPm at index 1 is %@...\n",[amOrPm objectAtIndex:1]);
    }
    
    NSLog(@"My bits: year is %d, month is %d, day is %d, time is %d, am or pm is %@\n",[[dateBits objectAtIndex:2]intValue],[[dateBits objectAtIndex:0]intValue],[[dateBits objectAtIndex:1]intValue],[[timeBits objectAtIndex:0]intValue],[amOrPm objectAtIndex:1]);
    
    comps.day = [[dateBits objectAtIndex:1] intValue];
    comps.month = [[dateBits objectAtIndex:0] intValue];
    comps.year = [[dateBits objectAtIndex:2] intValue];
    
    //What should the hour be?
    if([[timeBits objectAtIndex:0] intValue] >= 0 && [[timeBits objectAtIndex:0]intValue] <= 24)
    {
        if([[amOrPm objectAtIndex:1]isEqualToString:@"PM"])
        {
            //convert to military time
            comps.hour = [[timeBits objectAtIndex:0]intValue]+12;
        }
        else
        {
            //leave as is because this is in the morning and is already in military time
            comps.hour = [[timeBits objectAtIndex:0] intValue];
        }
        event.allDay = NO;
    }
    else
    {
        NSLog(@"The start time for this event is < 0 or > 24 which is screwy, so I'll just this is an all day event...\n");
        event.allDay = YES;
    }
    
    NSDate *eventDate = [greg dateFromComponents:comps];
    
    event.startDate = eventDate;
    
    //time interval is in seconds. I need to know an end time to calculate this, but for now I'll just say an hour.
    event.endDate   = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate];
    
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    
    //Figure out if this event date is in the past. If so, don't add it and let the user know you didn't add it and why!
    UIAlertView *alert;
    if([self isFutureDay:eventDate])
    {
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
        if (!err)
        {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Event Created Successfully!"
                     message:self.title
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
