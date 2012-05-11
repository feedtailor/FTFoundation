//
//  FTOAuth10.m
//  FTFoundation
//
//  Created by Ito Kei on 12/05/02.
//  Copyright (c) 2012年 feedtailor inc. All rights reserved.
//

#import "FTOAuth10.h"
#import "FTNSString+UUID.h"
#import "FTNSString+Encode.h"
#import "FTHMAC.h"
#import "FTBase64.h"

@implementation FTOAuth10

+(NSDictionary*) oauthQueriesWithURL:(NSURL*)url httpMethod:(NSString*)method postParams:(NSDictionary*)postParams consumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret
{
	unsigned int timestamp = time(NULL);	
	NSString* nonce = [NSString ft_UUIDString];
	NSString* link = [NSString stringWithFormat:@"%@://%@%@", [url scheme], [url host], [url path]];
	NSString* query = [url query];
	NSString* defaultQuery = [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_nonce=%@&oauth_signature_method=HMAC-SHA1&oauth_timestamp=%lu&oauth_version=1.0", consumerKey, nonce, timestamp];
	
	NSMutableArray* queryArr = [NSMutableArray arrayWithArray:[defaultQuery componentsSeparatedByString:@"&"]];
	if ([query length] > 0) {
		[queryArr addObjectsFromArray:[query componentsSeparatedByString:@"&"]];
	}
	if (token) {
		[queryArr addObject:[NSString stringWithFormat:@"oauth_token=%@", token]];
	}
	NSMutableArray* postKeys = [NSMutableArray array];
	if (postParams && [postParams count] > 0) {
		for (NSString* key in [postParams allKeys]) {
			id value = [postParams objectForKey:key];
			if (value) {
				[postKeys addObject:key];
				if ([value isKindOfClass:[NSString class]]) {
					[queryArr addObject:[NSString stringWithFormat:@"%@=%@", [key ft_stringByURLEncode], [value ft_stringByURLEncode]]];
				} else {
					/// XXX:
					NSLog(@"Warning : not string POST parameter");
				}
			}
		}
	}
	[queryArr sortUsingSelector:@selector(compare:)];
	query = [queryArr componentsJoinedByString:@"&"];
	
	// signature base
	NSString* base = [NSString stringWithFormat:@"%@&%@&%@", method, [link ft_stringByURLEncode], [query ft_stringByURLEncode]];
	//	NSLog(@"%@", base);
	
	// hmac key
	NSString* key = [NSString stringWithFormat:@"%@&%@", [consumerSecret ft_stringByURLEncode], (tokenSecret) ? [tokenSecret ft_stringByURLEncode] : @""];
	NSData* digest = [base ft_hmacDigestDataWithKey:key algorithm:kCCHmacAlgSHA1];
	NSString* signature = [digest ft_base64EncodedString];
	signature = [signature ft_stringByURLEncode];
	
	NSMutableDictionary* queries = [NSMutableDictionary dictionary];
	for (NSString* keyval in queryArr) {
		NSArray* comp = [keyval componentsSeparatedByString:@"="];
		if ([comp count] == 2) {
			if ([postKeys containsObject:[comp objectAtIndex:0]]) {
				// post用のデータは含めない
				continue;
			}
			[queries setObject:[comp objectAtIndex:1] forKey:[comp objectAtIndex:0]];
		}
	}
	[queries setObject:signature forKey:@"oauth_signature"];
	return queries;
}

+(NSString*) queryStringWithOAuthQueries:(NSDictionary*)queries
{
	NSMutableString* ret = [NSMutableString string];
	for (NSString* key in [queries allKeys]) {
		if ([ret length] > 0) {
			[ret appendString:@"&"];
		}
		[ret appendFormat:@"%@=%@", key, [queries objectForKey:key]];
	}
	return ret;
}

+(NSString*) headerStringWithOAuthQueries:(NSDictionary*)queries
{
	NSMutableString* ret = [NSMutableString string];
	for (NSString* key in [queries allKeys]) {
		if ([ret length] > 0) {
			[ret appendString:@", "];
		} else {
			[ret appendString:@"OAuth "];
		}
		[ret appendFormat:@"%@=\"%@\"", key, [queries objectForKey:key]];
	}
	return ret;
}


@end
