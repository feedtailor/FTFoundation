//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (FTNSManagedObjectContext)

- (BOOL)ft_save:(NSError **)error rollbackWhenError:(BOOL)rollbackWhenError;
- (void)ft_refreshRegisteredObjectsMergeChanges:(BOOL)mergeChanges;

@end
