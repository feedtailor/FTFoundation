//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSString (FTNSStringHMAC)

-(NSString*) ft_hmacDigestStringWithKey:(NSString*)key algorithm:(CCHmacAlgorithm)algorithm;
-(NSData*) ft_hmacDigestDataWithKey:(NSString*)key algorithm:(CCHmacAlgorithm)algorithm;

@end
