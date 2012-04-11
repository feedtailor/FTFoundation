//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (FTNSDataBase64)

-(NSString*) ft_base64EncodedString;
-(NSString*) ft_base64EncodedStringWithSeparateLine:(BOOL)separateLine;

@end


@interface NSString (FTNSStringBase64)

-(NSData*) ft_base64DecodedData;

@end
