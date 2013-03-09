//
//  logPrinter.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/8/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "logPrinter.h"

@implementation logPrinter

-(id)init
{
    if(self = [super init])
    {
        self.showOutput = TRUE;
        indention = 0;
        formatString = @"";
    }
    return self;
}

-(void)outputClass:(Class)class Function:(SEL)function Message:(NSString*)message
{
    formatString = @"";
    if(self.showOutput)
    {        
        for(int i=0; i<indention; i++)
            formatString = [formatString stringByAppendingString:@" "];
        
        NSLog(@"%@[%@ %@] %@",formatString, NSStringFromClass(class),NSStringFromSelector(function),[NSString stringWithFormat:@"%@%@",message,@"\n"]);
    }
}

-(void)functionEnteredClass:(Class)class Function:(SEL)function
{
    [self outputClass:class Function:function Message:@"Entry"];
    indention+=3;
}

-(void)functionExitedClass:(Class)class Function:(SEL)function
{
    indention-=3;
    
    NSString * newline = @"";
    
    if(indention == 0)
        newline = @"\n";
    
    [self outputClass:class Function:function Message:[NSString stringWithFormat:@"Exit%@",newline]];
}

@end
