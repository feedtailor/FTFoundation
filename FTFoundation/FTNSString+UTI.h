//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FTNSStringUTI)

+(NSString*) ft_UTIForFilename:(NSString*)filename;
+(NSString*) ft_UTIForPathExtension:(NSString*)extension;
+(NSString*) ft_pathExtentionForUTI:(NSString*)uti;
+(NSString*) ft_mimeTypeForFilename:(NSString*)filename;
+(NSString*) ft_mimeTypeForPathExtension:(NSString*)extension;
+(NSString*) ft_mimeTypeForUTI:(NSString*)uti;

@end
