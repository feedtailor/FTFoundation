//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

// todo: 各種デフォルト値の明示
// todo: schema の schema で schema をvalidate

#import "FTJSONSchemaValidator.h"

// #define SHOW_LOG

NSString *const FTJSONSchemaValidatorErrorDomain = @"jp.feedtailor.FTJSONSchemaValidator";
NSString *const FTJSONSchemaValidatorErrorObjectFragmentKey = @"FTJSONSchemaValidatorErrorObjectFragmentKey";
NSString *const FTJSONSchemaValidatorErrorSchemaFragmentKey = @"FTJSONSchemaValidatorErrorSchemaFragmentKey";

static NSString *const kTypeString = @"string";
static NSString *const kTypeNumber = @"number";
static NSString *const kTypeInteger = @"integer";
static NSString *const kTypeBoolean = @"boolean";
static NSString *const kTypeObject = @"object";
static NSString *const kTypeArray = @"array";
static NSString *const kTypeNull = @"null";
static NSString *const kTypeAny = @"any";

static NSString *const kDummyRootKey = @"__root__";
static NSString *const kDummyItemKey = @"__item__";

@interface FTJSONSchemaValidator ()
@end

@implementation FTJSONSchemaValidator
{
	NSDictionary *_schema;
	NSDictionary *_commandMap;
	
	NSError *_lastError;
}

- (void)setupCommandMap
{
	__weak FTJSONSchemaValidator *self_ = self;
	
	BOOL (^nop)(NSString *, NSDictionary *, NSDictionary *, id) = ^(NSString *a, NSDictionary *b, NSDictionary *c, id d) {
		return YES;
	};
	
	NSMutableDictionary *commandMap = [NSMutableDictionary dictionary];
	
	[commandMap setObject:[nop copy] forKey:@"type"];
	[commandMap setObject:[nop copy] forKey:@"description"];
	[commandMap setObject:[nop copy] forKey:@"title"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidPropertiesWithKey:key object:object schema:schema properties:parameterValue];
	} copy] forKey:@"properties"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidRequiredWithKey:key object:object schema:schema required:parameterValue];
	} copy] forKey:@"required"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidMinimumWithKey:key object:object schema:schema minimum:parameterValue];
	} copy] forKey:@"minimum"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidMaximumWithKey:key object:object schema:schema maximum:parameterValue];
	} copy] forKey:@"maximum"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidItemsWithKey:key object:object schema:schema itemSchema:parameterValue];
	} copy] forKey:@"items"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidMinItemsWithKey:key object:object schema:schema minItems:parameterValue];
	} copy] forKey:@"minItems"];
	
	[commandMap setObject:[^(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue) {
		return [self_ isValidMaxItemsWithKey:key object:object schema:schema maxItems:parameterValue];
	} copy] forKey:@"maxItems"];
	
	_commandMap = [commandMap copy];
}

+ (NSDictionary *)typeMap
{
	static NSDictionary *typeMap = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		typeMap = [NSDictionary dictionaryWithObjectsAndKeys:
				   [NSString class], kTypeString,
				   [NSNumber class], kTypeNumber,
				   [NSNumber class], kTypeInteger,
				   [NSNumber class], kTypeBoolean,
				   [NSDictionary class], kTypeObject,
				   [NSArray class], kTypeArray,
				   [NSNull class], kTypeNull,
				   nil];
	});
	
	return typeMap;
}

- (id)initWithSchemaData:(NSData *)schemaData
{
	self = [super init];
	if(self) {
		NSError *error = nil;
		_schema = [NSJSONSerialization JSONObjectWithData:schemaData options:0 error:&error];
		if(![_schema isKindOfClass:[NSDictionary class]]) {
			return nil;
		}
		
		[self setupCommandMap];
	}
	
	return self;
}


- (NSError *)validatorErrorWithCode:(FTJSONSchemaValidatorError)code
			   localizedDescription:(NSString *)localizedDescription
					underlyingError:(NSError *)underlyingError
					 objectFragment:(NSDictionary *)objectFragment
					 schemaFragment:(NSDictionary *)schemaFragment
{
	NSParameterAssert(localizedDescription);
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:localizedDescription
																	   forKey:NSLocalizedDescriptionKey];
	if(underlyingError) {
		[userInfo setObject:underlyingError forKey:NSUnderlyingErrorKey];
	}
	
	if(objectFragment) {
		[userInfo setObject:objectFragment forKey:FTJSONSchemaValidatorErrorObjectFragmentKey];
	}
	
	if(schemaFragment) {
		[userInfo setObject:schemaFragment forKey:FTJSONSchemaValidatorErrorSchemaFragmentKey];
	}
	
	NSError *error = [NSError errorWithDomain:FTJSONSchemaValidatorErrorDomain
										 code:code
									 userInfo:userInfo];
	return error;
}

- (BOOL)isValidJSONData:(NSData *)JSONdata error:(NSError **)outError
{
	NSError *error = nil;
	id rootObject = [NSJSONSerialization JSONObjectWithData:JSONdata options:0 error:&error];
	if(!rootObject) {
		if(outError) {
			*outError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidJSONError
								localizedDescription:@"JSONdata is not valid JSON."
									 underlyingError:error
									  objectFragment:nil
									  schemaFragment:nil];
		}
		return NO;
	}
	
	NSDictionary *rootDummyData = [NSDictionary dictionaryWithObject:rootObject forKey:kDummyRootKey];
	
	_lastError = nil;
	BOOL result = [self isValidWithKey:kDummyRootKey object:rootDummyData schema:_schema];
	if(outError && _lastError) {
		*outError = _lastError;
	}
	_lastError = nil;
	
	return result;
}

- (BOOL)isValidPropertiesWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
					  properties:(NSDictionary *)properties
{
	if(![properties isKindOfClass:[NSDictionary class]]) {
		return NO;
	}
	
	NSDictionary *value = [object objectForKey:key];
	if(!value) {
		return YES;
	}
	
	if(![value isKindOfClass:[NSDictionary class]]) {
		// multi typeでobjectでは無い場合の対処
		return YES;
	}
	
	__block BOOL success = YES;
	
	[properties enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, id obj, BOOL *stop) {
		id subSchema = [properties objectForKey:aKey];
		if(!subSchema) {
			_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
								 localizedDescription:[NSString stringWithFormat:@"subschema not found for key '%@'", aKey]
									  underlyingError:nil
									   objectFragment:object
									   schemaFragment:schema];			
			success = NO;
			*stop = YES;
			return;
		}
		
		success = [self isValidWithKey:aKey object:value schema:subSchema];
		if(!success) {
			*stop = YES;
			return;
		}
	}];
	
	return success;
}

- (BOOL)isValidRequiredWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
					  required:(NSNumber *)required
{
	if(![required boolValue]) {
		return YES;
	}
	
	BOOL found = ([object objectForKey:key]) ? YES : NO;
	if(!found) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
							 localizedDescription:[NSString stringWithFormat:@"required key [%@] not found.", key]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
	}
	return found;
}

- (BOOL)isValidMinimumWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
					  minimum:(NSNumber *)minimum
{
	if(![minimum isKindOfClass:[NSNumber class]]) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
							 localizedDescription:[NSString stringWithFormat:@"[%@] is not a number..", minimum]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	NSNumber *value = [object objectForKey:key];
	
	if([value compare:minimum] == NSOrderedAscending) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
							 localizedDescription:[NSString stringWithFormat:@"%@ minimum(%@) : actural(%@)", key, minimum, value]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	return YES;
}

- (BOOL)isValidMaximumWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
					  maximum:(NSNumber *)maximum
{
	if(![maximum isKindOfClass:[NSNumber class]]) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
							 localizedDescription:[NSString stringWithFormat:@"[%@] is not a number..", maximum]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	NSNumber *value = [object objectForKey:key];
	
	if([value compare:maximum] == NSOrderedDescending) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
							 localizedDescription:[NSString stringWithFormat:@"%@ maximum(%@) : actural(%@)", key, maximum, value]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	return YES;
}

- (BOOL)isValidItemsWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
				 itemSchema:(NSDictionary *)itemSchema
{
	if(![itemSchema isKindOfClass:[NSDictionary class]]) {
		// schema array の仕様もあるが未対応
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
							 localizedDescription:[NSString stringWithFormat:@"item schema for each item is invalid. %@", itemSchema]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	NSArray *objects = [object objectForKey:key];
	
	__block BOOL success = YES;
	
	[objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *itemEnrry = [NSDictionary dictionaryWithObject:obj forKey:kDummyItemKey];
		success = [self isValidWithKey:kDummyItemKey object:itemEnrry schema:itemSchema];
		if(!success) {
			*stop = YES;
			return;
		}
	}];
	
	return success;
}

- (BOOL)isValidMinItemsWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
					  minItems:(NSNumber *)minItems
{
	if(![minItems isKindOfClass:[NSNumber class]]) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
							 localizedDescription:[NSString stringWithFormat:@"[%@] is not a number..", minItems]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	NSArray *items = [object objectForKey:key];
	
	if(![items isKindOfClass:[NSArray class]]) {
		return YES;
	}
	
	if([items count] < [minItems unsignedIntegerValue]) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
							 localizedDescription:[NSString stringWithFormat:@"%@ minItems(%@) : actural(%d)", key, minItems, [items count]]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	return YES;
}

- (BOOL)isValidMaxItemsWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
					  maxItems:(NSNumber *)maxItems
{
	if(![maxItems isKindOfClass:[NSNumber class]]) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
							 localizedDescription:[NSString stringWithFormat:@"[%@] is not a number..", maxItems]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	NSArray *items = [object objectForKey:key];
	
	if(![items isKindOfClass:[NSArray class]]) {
		return YES;
	}
	
	if([maxItems unsignedIntegerValue] < [items count]) {
		_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
							 localizedDescription:[NSString stringWithFormat:@"%@ maxItems(%@) : actural(%d)", key, maxItems, [items count]]
								  underlyingError:nil
								   objectFragment:object
								   schemaFragment:schema];
		return NO;
	}
	
	return YES;
}

- (BOOL)isValidObject:(id)value type:(NSString *)type error:(NSError **)outError
{
	// todo
	// integer / number の厳密なチェック
	
	Class typeClass = [[[self class] typeMap] objectForKey:type];
	if(!typeClass) {
#if defined(SHOW_LOG)
		NSLog(@"type (%@) > treated as 'any'.", type);
#endif
		return YES;
	} else if([type isEqualToString:@"boolean"]) {
		if(!(value == (__bridge id)kCFBooleanTrue || value == (__bridge id)kCFBooleanFalse)) {
			if(outError) {
				*outError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
									localizedDescription:[NSString stringWithFormat:@"value(%@) is not boolean.", value]
										 underlyingError:nil
										  objectFragment:value
										  schemaFragment:nil];
			}
			return NO;
		}
	} else if(![value isKindOfClass:typeClass]) {
		if(outError) {
			*outError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
								localizedDescription:[NSString stringWithFormat:@"value(%@) is not kind of class (%@)", value, typeClass]
									 underlyingError:nil
									  objectFragment:value
									  schemaFragment:nil];
		}
		return NO;
	} else if(typeClass == [NSNumber class]) {
		if(value == (__bridge id)kCFBooleanTrue || value == (__bridge id)kCFBooleanFalse) {
			if(outError) {
				*outError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
									localizedDescription:[NSString stringWithFormat:@"value(%@) must be not boolean.", value]
										 underlyingError:nil
										  objectFragment:value
										  schemaFragment:nil];
			}
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)isValidWithKey:(NSString *)key object:(NSDictionary *)object schema:(NSDictionary *)schema
{
	@autoreleasepool {
		// type check
		id type = [schema objectForKey:@"type"];
		if(![type isKindOfClass:[NSString class]] && ![type isKindOfClass:[NSArray class]]) {
			_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorInvalidSchemaError
								 localizedDescription:[NSString stringWithFormat:@"wrong type spec:%@", [[type class] description]]
									  underlyingError:nil
									   objectFragment:object
									   schemaFragment:schema];
			return NO;
		}
		
		if(![object isKindOfClass:[NSDictionary class]]) {
			_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
								 localizedDescription:@"object is not dictionary."
									  underlyingError:nil
									   objectFragment:object
									   schemaFragment:schema];
			return NO;
		}
		
		id value = [object objectForKey:key];
		
		if(value) {
			if([type isKindOfClass:[NSString class]]) {
				// Simple Types
				NSError *error = nil;
				if(![self isValidObject:value type:type error:&error]) {
					_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
										 localizedDescription:[error localizedDescription]
											  underlyingError:error
											   objectFragment:object
											   schemaFragment:schema];
					return NO;
				}
			} else {
				// Union Types
				NSArray *types = (NSArray *)type;
				BOOL typeFound = NO;
				
				NSError *typeError = nil;
				for(NSString *aType in types) {
					if([self isValidObject:value type:aType error:&typeError]) {
						typeFound = YES;
						break;
					}
				}
				
				if(!typeFound) {
					_lastError = [self validatorErrorWithCode:FTJSONSchemaValidatorNotValidError
										 localizedDescription:[NSString stringWithFormat:@"value(%@) is not kind of class in (%@)", value, types]
											  underlyingError:nil
											   objectFragment:object
											   schemaFragment:schema];
					return NO;
				}
			}
		} else {
			// maybe optional
		}
		
		// type check OK
		__block BOOL success = YES;
		
		[schema enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, id obj, BOOL *stop) {
			BOOL (^commandBlock)(NSString *key, NSDictionary *object, NSDictionary *schema, id parameterValue);
			commandBlock = [_commandMap objectForKey:aKey];
			
			BOOL ret = NO;
			if(commandBlock) {
				id schemaValue = [schema objectForKey:aKey];
				ret = commandBlock(key, object, schema, schemaValue);
			} else {
#if defined(SHOW_LOG)
				NSLog(@"scheme def '%@' is not supprted. ignored.", aKey);
#endif
				ret = YES;
			}
			
			if(!ret) {
				success = NO;
				*stop = YES;
			}
		}];
		
		return success;
	}
}

@end
