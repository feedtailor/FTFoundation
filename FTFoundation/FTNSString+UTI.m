//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSString+UTI.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (FTNSStringUTI)

+(NSString*) ft_UTIForFilename:(NSString*)filename
{
	return [self ft_UTIForPathExtension:[filename pathExtension]];
}

+(NSString*) ft_UTIForPathExtension:(NSString*)extension
{
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
	NSString* ret = CFBridgingRelease(uti);
	return ret;
}

+(NSString*) ft_pathExtentionForUTI:(NSString*)uti
{
	CFStringRef extension = UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)uti, kUTTagClassFilenameExtension);
	NSString* ret = CFBridgingRelease(extension);
	return ret;
}

+(NSString*) ft_mimeTypeForFilename:(NSString*)filename
{
	return [self ft_mimeTypeForPathExtension:[filename pathExtension]];
}

+(NSString*) ft_mimeTypeForPathExtension:(NSString*)extension
{
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
	NSString* mime = [self ft_mimeTypeForUTI:(__bridge NSString*)uti];
	CFRelease(uti);
	return mime;
}

+(NSString*) ft_mimeTypeForUTI:(NSString*)uti
{
	CFStringRef mime = UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)uti, kUTTagClassMIMEType);
	NSString* ret = CFBridgingRelease(mime);
	return ret;
}

@end
