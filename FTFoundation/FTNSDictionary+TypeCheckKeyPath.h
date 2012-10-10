//
//  Copyright (c) 2012 feedtailor inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionaryTypeCheckKeyPath)

- (id)ft_objectForKeyPath:(NSString *)keyPath;

- (NSString *)ft_stringForKeyPath:(NSString *)keyPath;
- (NSString *)ft_stringForKeyPath:(NSString *)keyPath lengthRange:(NSRange)lengthRange;
- (NSArray *)ft_arrayForKeyPath:(NSString *)keyPath;
- (NSArray *)ft_arrayForKeyPath:(NSString *)keyPath countRange:(NSRange)countRange;
- (NSDictionary *)ft_dictionaryForKeyPath:(NSString *)keyPath;
- (NSNumber *)ft_numberForKeyPath:(NSString *)keyPath;
- (NSNumber *)ft_numberForKeyPath:(NSString *)keyPath minimum:(NSNumber *)minimum maximum:(NSNumber *)maximum;
- (NSNumber *)ft_boolForKeyPath:(NSString *)keyPath;
- (NSNull *)ft_nullForKeyPath:(NSString *)keyPath;

@end
