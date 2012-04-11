//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTNSManagedObjectContext+Save.h"

@implementation NSManagedObjectContext (FTNSManagedObjectContextSave)

- (BOOL)ft_save:(NSError **)error rollbackWhenError:(BOOL)rollbackWhenError
{
	NSError *tempError = nil;
	BOOL result = [self save:&tempError];
	if(!result) {
		NSLog(@"moc save error: %@", tempError);
		if(rollbackWhenError) {
			[self rollback];
		}
	}
	
	if(error) {
		*error = tempError;
	}
	
	return result;
}

- (void)ft_refreshRegisteredObjectsMergeChanges:(BOOL)mergeChanges
{
	NSSet *objects = [self registeredObjects];
	for(NSManagedObject *mo in objects) {
		@autoreleasepool {
			[self refreshObject:mo mergeChanges:mergeChanges];
		}
	}		
}

@end
