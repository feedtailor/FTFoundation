//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

@interface NSString (FTNSStringEncode)

// RFC3986
-(NSString*) ft_stringByURLEncode;
-(NSString*) ft_stringByURLEncodeWithEscapeCharacters:(NSString*)toBeEscaped;

-(NSString*) ft_stringByURLDecode;
-(NSString*) ft_stringByURLDecodeWithEscapeCharacters:(NSString*)toBeEscaped;

@end
