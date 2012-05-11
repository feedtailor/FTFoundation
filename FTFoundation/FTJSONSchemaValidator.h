//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// SPEC
// http://tools.ietf.org/html/draft-zyp-json-schema-03

@interface FTJSONSchemaValidator : NSObject

- (id)initWithSchemaData:(NSData *)schemaData;
- (BOOL)isValidJSONData:(NSData *)JSONdata error:(NSError **)outError;

@end

extern NSString *const FTJSONSchemaValidatorErrorDomain;
extern NSString *const FTJSONSchemaValidatorErrorObjectFragmentKey;	// エラー時に注目していたオブジェクト片
extern NSString *const FTJSONSchemaValidatorErrorSchemaFragmentKey;	// エラー時に処理していたスキーマ片

enum {
	FTJSONSchemaValidatorInvalidSchemaError	= 1,
	FTJSONSchemaValidatorInvalidJSONError	= 2,
	FTJSONSchemaValidatorNotValidError		= 3,
};

typedef NSInteger FTJSONSchemaValidatorError;
