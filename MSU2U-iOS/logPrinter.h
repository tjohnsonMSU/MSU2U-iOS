//
//  logPrinter.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/8/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface logPrinter : NSObject{
    int indention;
    NSString * formatString;
}
@property BOOL showOutput;
-(void)outputClass:(Class)myClass Function:(SEL)function Message:(NSString*)message;
-(void)functionEnteredClass:(Class)myClass Function:(SEL)function;
-(void)functionExitedClass:(Class)myClass Function:(SEL)function;
@end
