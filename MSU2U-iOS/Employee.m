//
//  Employee.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/7/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Employee.h"


@implementation Employee

@dynamic deleted;
@dynamic dept_id_1;
@dynamic dept_id_2;
@dynamic email;
@dynamic favorite;
@dynamic fax1;
@dynamic fax2;
@dynamic fname;
@dynamic history;
@dynamic last_changed;
@dynamic link_to_more_info;
@dynamic lname;
@dynamic location;
@dynamic middle;
@dynamic name_prefix;
@dynamic office_bldg_id_1;
@dynamic office_bldg_id_2;
@dynamic office_rm_num_1;
@dynamic office_rm_num_2;
@dynamic person_id;
@dynamic phone1;
@dynamic phone2;
@dynamic picture;
@dynamic position_title_1;
@dynamic position_title_2;
@dynamic website1;
@dynamic website2;

-(void)printMyInfo
{
    NSLog(@"name:%@ %@ %@ %@\n",self.name_prefix,self.fname,self.middle,self.lname);
    NSLog(@"Phones: %@ %@\n",self.phone1,self.phone2);
    NSLog(@"Faxes: %@ %@\n",self.fax1,self.fax2);
    NSLog(@"Locations: %@ %@ | %@ %@\n",self.office_bldg_id_1,self.office_rm_num_1,self.office_bldg_id_2,self.office_rm_num_2);
    NSLog(@"Positions: %@ %@\n",self.position_title_1,self.position_title_2);
    NSLog(@"Department: %@ %@\n",self.dept_id_1,self.dept_id_2);
    NSLog(@"Websites: %@ %@\n",self.website1,self.website2);
    NSLog(@"Deleted: %@\n",self.deleted);
    NSLog(@"favorite: %@\n",self.favorite);
    NSLog(@"picture: %@\n",self.picture);
    NSLog(@"last_changed: %@\n",self.last_changed);
    NSLog(@"Email: %@\n",self.email);
    NSLog(@"person_id: %@\n",self.person_id);
}

-(NSString*)getLocation:(int)n
{
    NSString * location = @"";
    
    if(n==1)
        location = [NSString stringWithFormat:@"%@ %@",self.office_bldg_id_1,self.office_rm_num_1];
    else if(n==2)
        location = [NSString stringWithFormat:@"%@ %@",self.office_bldg_id_2,self.office_rm_num_2];
    else
    {
        NSLog(@"[!]ERROR: No such thing as position %@ for an employee.\n",[NSNumber numberWithInt:n]);
        location = @"";
    }
    
    return [location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSString*)getFullName
{
    NSString * fullName = @"";
    if([self.name_prefix length] != 0)
        fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.name_prefix]];
    if([self.fname length] != 0)
        fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.fname]];
    if([self.middle length] != 0)
        fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.middle]];
    if([self.lname length] != 0)
        fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.lname]];
        
    return [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(NSString*)getShortenedName
{
    NSString * mailSalutation = @"";
    
    if([self.lname length] != 0)
    {
        if([self.name_prefix length] != 0)
            mailSalutation = [mailSalutation stringByAppendingString:[NSString stringWithFormat:@" %@ %@",self.name_prefix,self.lname]];
        else
            mailSalutation = [NSString stringWithFormat:@" %@",self.lname];
    }
    else
        mailSalutation = [mailSalutation stringByAppendingString:@""];
    
    return mailSalutation;
}

-(NSString*)getDepartments
{
    return [self detailStringFormatterFor:self.dept_id_1 and:self.dept_id_2];
}

-(NSString*)getPositions
{
    return [self detailStringFormatterFor:self.position_title_1 and:self.position_title_2];
}

-(NSString*)detailStringFormatterFor:(NSString*)a and:(NSString*)b
{
    NSString * c;
    if(a.length > 0 && b.length > 0)
    {
        //I have two strings
        c = [NSString stringWithFormat:@"%@ | %@",a,b];
    }
    else
    {
        if(a.length > 0)
            c = a;
        else
            c = b;
    }
    return c;
}

@end
