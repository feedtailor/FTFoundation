//
//  Copyright (c) 2012 feedtailor inc. All rights reserved.
//

#import "FTNSDictionary+TypeCheckKeyPath.h"

static const NSRange kNoRange = {
	.location = NSNotFound,
	.length = 0
};

static NSArray *keyPathComponentsWithKeyPath(NSString *keyPath)
{
	static NSCharacterSet *separator;
	static NSCache *cache;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		separator = [NSCharacterSet characterSetWithCharactersInString:@"."];
		cache = [[NSCache alloc] init];
		[cache setCountLimit:100];
	});

	NSArray *components = [cache objectForKey:keyPath];
	if(!components) {
		components = [keyPath componentsSeparatedByCharactersInSet:separator];
		[cache setObject:components forKey:keyPath];
	}

	return components;
}

@implementation NSDictionary (NSDictionaryTypeCheckKeyPath)

- (id)ft_objectForKeyPath:(NSString *)keyPath
{
	if(![keyPath length]) {
		return nil;
	}

	NSArray *components = keyPathComponentsWithKeyPath(keyPath);

    id tempObject = self;
	
    for(int i = 0; i < [components count]; i++) {
        NSString *component = [components objectAtIndex:i];

		tempObject = [tempObject valueForKey:component];

		if(i != [components count]-1) {
			if(![tempObject isKindOfClass:[NSDictionary class]]) {
				return nil;
			}
		}
    }
	
	return tempObject;
}

#pragma mark -

- (NSString *)ft_stringForKeyPath:(NSString *)keyPath
{
	return [self ft_stringForKeyPath:keyPath lengthRange:kNoRange];
}

- (NSString *)ft_stringForKeyPath:(NSString *)keyPath lengthRange:(NSRange)lengthRange
{
	NSString *string = [self ft_objectForKeyPath:keyPath];
	if(![string isKindOfClass:[NSString class]]) {
		return nil;
	}

	if(lengthRange.location == NSNotFound ||
	   NSLocationInRange([string length], lengthRange)) {
		return string;
	}

	return nil;
}

- (NSArray *)ft_arrayForKeyPath:(NSString *)keyPath
{
	return [self ft_arrayForKeyPath:keyPath countRange:kNoRange];
}

- (NSArray *)ft_arrayForKeyPath:(NSString *)keyPath countRange:(NSRange)countRange
{
	NSArray *array = [self ft_objectForKeyPath:keyPath];
	if(![array isKindOfClass:[NSArray class]]) {
		return nil;
	}
	
	if(countRange.location == NSNotFound ||
	   NSLocationInRange([array count], countRange)) {
		return array;
	}
	
	return nil;
}

- (NSDictionary *)ft_dictionaryForKeyPath:(NSString *)keyPath
{
	id object = [self ft_objectForKeyPath:keyPath];
	if([object isKindOfClass:[NSDictionary class]]) {
		return object;
	}

	return nil;
}

- (NSNumber *)ft_numberForKeyPath:(NSString *)keyPath
{
	return [self ft_numberForKeyPath:keyPath minimum:nil maximum:nil];
}

- (NSNumber *)ft_numberForKeyPath:(NSString *)keyPath minimum:(NSNumber *)minimum maximum:(NSNumber *)maximum
{
	NSNumber *number = [self ft_objectForKeyPath:keyPath];
	if(![number isKindOfClass:[NSNumber class]]) {
		return nil;
	}

	if(minimum) {
		if([number compare:minimum] == NSOrderedAscending) {
			return nil;
		}
	}

	if(maximum) {
		if([number compare:maximum] == NSOrderedDescending) {
			return nil;
		}
	}

	return number;
}


- (NSNumber *)ft_boolForKeyPath:(NSString *)keyPath
{
	id object = [self ft_objectForKeyPath:keyPath];
	if([object isEqual:(id)kCFBooleanTrue] || [object isEqual:(id)kCFBooleanFalse]) {
		return object;
	}

	return nil;
}

- (NSNull *)ft_nullForKeyPath:(NSString *)keyPath
{
	id object = [self ft_objectForKeyPath:keyPath];
	if([object isKindOfClass:[NSNull class]]) {
		return object;
	}

	return nil;
}

@end
