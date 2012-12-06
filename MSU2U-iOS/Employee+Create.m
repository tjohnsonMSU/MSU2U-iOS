//
//  Employee+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/15/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "Employee+Create.h"

@implementation Employee (Create)

+(Employee *)employeeWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Employee * employee = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    request.predicate = [NSPredicate predicateWithFormat:@"fullname = %@", [info objectForKey:@"fullname"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullname" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * employees = [context executeFetchRequest:request error:&error];
    
    if(!employees || ([employees count] > 1))
    {
        //handle error
    }
    else if(![employees count])
    {
        employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
        
        //These attributes are received from the server
        employee.fullname = [info objectForKey:@"fullname"];
        employee.phone = [info objectForKey:@"phone"];
        employee.email = [info objectForKey:@"email"];
        employee.fax = [info objectForKey:@"fax"];
        employee.department = [info objectForKey:@"department"];
        employee.position = [info objectForKey:@"position"];
        employee.location = [info objectForKey:@"location"];
        employee.image = [info objectForKey:@"image"];
        employee.website = [info objectForKey:@"website"];
        
        //These are attributes I'm interested in on the iOS side, thus will not be found from the server
        employee.favorite = @"no";
        employee.history = nil;
    }
    else
    {
        employee = [employees lastObject];
    }
    
    return employee;
}

@end
