//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTOAuth10 : NSObject

+(NSDictionary*) oauthQueriesWithURL:(NSURL*)url httpMethod:(NSString*)method postParams:(NSDictionary*)postParams consumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret;
+(NSString*) queryStringWithOAuthQueries:(NSDictionary*)queries;
+(NSString*) headerStringWithOAuthQueries:(NSDictionary*)queries;

@end
