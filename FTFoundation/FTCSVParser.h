//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// 改行コード入りcolumnには未対応

@interface FTCSVParser : NSObject;

- (id)initWithCSVString:(NSString *)csvString;

// [column array] の array.
// skipInvalidRow = NO の場合、不正な列には array の代わりに NSNull が入る.
- (NSArray *)rows;	// skipInvalidRow = YES
- (NSArray *)rowsWithSkipInvalidRow:(BOOL)skipInvalidRow;

@end
