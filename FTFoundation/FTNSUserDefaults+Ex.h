//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (FTNSUserDefaults)

// filename=nil : @"defaults.plist"
// synchronizeまでおこなう
-(void) ft_setupDefaultsWithPlist:(NSString*)filename;

-(void) ft_removeAllObjects;

@end
