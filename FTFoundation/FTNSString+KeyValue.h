//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FTNSStringsKeyValue)

-(NSDictionary*) ft_keyValueDictionary;
-(NSDictionary*) ft_keyValueDictionaryWithDelimiter:(NSString*)delimiter;

@end
