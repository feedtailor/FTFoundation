//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

//
//  CSV Parser implementation copied from the following blog post.
//
//  http://cocoawithlove.com/2009/11/writing-parser-using-nsscanner-csv.html
//
//  ***
//
//  Created by Matt Gallagher on 2009/11/30.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>

@interface FTCSVParser : NSObject {
    FILE *file;
    NSScanner *scanner;
    NSString *separator;
    NSMutableArray *fieldNames;
    NSCharacterSet *endTextCharacterSet;
    BOOL separatorIsSingleChar;
}

- (id)initWithString:(NSString *)aCSVString
           separator:(NSString *)aSeparatorString
           hasHeader:(BOOL)header
          fieldNames:(NSArray *)names;

- (id)initWithFile:(NSString *)filename
         separator:(NSString *)aSeparatorString
         hasHeader:(BOOL)header
        fieldNames:(NSArray *)names;

- (NSArray *)rows;
- (NSDictionary *)nextRow;

@end
