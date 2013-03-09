//
//  Employee.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/7/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "logPrinter.h"


@interface Employee : NSManagedObject{
    logPrinter * log;
}

@property (nonatomic, retain) NSString * deleted;
@property (nonatomic, retain) NSString * dept_id_1;
@property (nonatomic, retain) NSString * dept_id_2;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * favorite;
@property (nonatomic, retain) NSString * fax1;
@property (nonatomic, retain) NSString * fax2;
@property (nonatomic, retain) NSString * fname;
@property (nonatomic, retain) NSString * history;
@property (nonatomic, retain) NSString * last_changed;
@property (nonatomic, retain) NSString * link_to_more_info;
@property (nonatomic, retain) NSString * lname;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * middle;
@property (nonatomic, retain) NSString * name_prefix;
@property (nonatomic, retain) NSString * office_bldg_id_1;
@property (nonatomic, retain) NSString * office_bldg_id_2;
@property (nonatomic, retain) NSString * office_rm_num_1;
@property (nonatomic, retain) NSString * office_rm_num_2;
@property (nonatomic, retain) NSString * person_id;
@property (nonatomic, retain) NSString * phone1;
@property (nonatomic, retain) NSString * phone2;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * position_title_1;
@property (nonatomic, retain) NSString * position_title_2;
@property (nonatomic, retain) NSString * website1;
@property (nonatomic, retain) NSString * website2;

-(void)printMyInfo;
-(NSString*)getFullName;
-(NSString*)getShortenedName;
-(NSString*)getLocation:(int)n;
-(NSString*)getPositions;
-(NSString*)getDepartments;

@end
