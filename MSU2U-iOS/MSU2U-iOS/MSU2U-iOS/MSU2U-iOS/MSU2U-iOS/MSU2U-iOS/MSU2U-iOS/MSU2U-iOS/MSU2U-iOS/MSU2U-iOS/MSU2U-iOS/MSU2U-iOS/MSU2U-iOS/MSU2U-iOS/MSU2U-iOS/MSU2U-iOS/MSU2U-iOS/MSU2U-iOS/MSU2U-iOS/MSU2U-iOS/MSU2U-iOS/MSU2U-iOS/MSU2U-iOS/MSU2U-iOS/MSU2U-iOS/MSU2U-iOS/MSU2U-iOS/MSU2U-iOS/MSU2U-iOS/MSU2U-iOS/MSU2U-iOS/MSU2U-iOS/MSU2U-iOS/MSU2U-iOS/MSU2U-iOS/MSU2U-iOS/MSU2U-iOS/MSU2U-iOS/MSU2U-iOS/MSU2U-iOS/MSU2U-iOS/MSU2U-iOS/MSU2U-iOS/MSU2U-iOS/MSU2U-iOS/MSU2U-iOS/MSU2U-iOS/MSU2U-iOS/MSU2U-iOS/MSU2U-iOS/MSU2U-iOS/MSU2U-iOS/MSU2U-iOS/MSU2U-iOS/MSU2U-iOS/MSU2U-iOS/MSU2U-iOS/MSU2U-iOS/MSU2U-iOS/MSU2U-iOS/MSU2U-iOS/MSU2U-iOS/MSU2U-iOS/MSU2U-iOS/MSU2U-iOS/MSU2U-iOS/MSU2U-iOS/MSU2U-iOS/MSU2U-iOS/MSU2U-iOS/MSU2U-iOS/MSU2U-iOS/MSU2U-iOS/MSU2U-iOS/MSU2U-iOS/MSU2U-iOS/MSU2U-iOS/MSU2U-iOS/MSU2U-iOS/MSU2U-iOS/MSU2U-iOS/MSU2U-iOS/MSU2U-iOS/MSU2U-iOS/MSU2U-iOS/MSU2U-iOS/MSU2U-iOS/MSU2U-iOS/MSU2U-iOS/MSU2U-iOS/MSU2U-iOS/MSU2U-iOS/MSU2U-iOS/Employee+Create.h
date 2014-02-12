//
//  Employee+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/15/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "Employee.h"

@interface Employee (Create)
+(Employee *)employeeWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
@end
