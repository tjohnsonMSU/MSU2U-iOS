//
//  MYDocumentHandler.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "logPrinter.h"

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface MYDocumentHandler : NSObject{
    logPrinter * log;
}

@property (strong, nonatomic) UIManagedDocument *document;

+ (MYDocumentHandler *)sharedDocumentHandler;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end
