//
//  Employee.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/21/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * favorite;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSString * history;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * website;

@end
