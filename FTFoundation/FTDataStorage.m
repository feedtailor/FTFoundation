//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTDataStorage.h"


static FTDataStorage* s_self = nil;

@implementation FTDataStorage

@synthesize persistentStore;
@synthesize storeURL, storeType;
@synthesize persistentStoreOptions;
@synthesize modelURL;

+(id) sharedStorage
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!s_self) {
			s_self = [[[self class] alloc] init];
		}		
	});
	return s_self;
}

-(void) dealloc
{
	[self save];
	
	s_self = nil;
}

-(NSDictionary *)defaultPersistentStoreOptions
{
	NSDictionary *options = nil;

#if defined(TARGET_OS_IPHONE) || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
	options = [NSDictionary dictionaryWithObjectsAndKeys:
			   [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
			   [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
			   nil];
#else
	options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
#endif

	return options;
}

-(BOOL) loadStore
{
	@synchronized (self) {
		if (!persistentStoreCoordinator) {
			NSURL *url = (storeURL) ? storeURL : [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"data.db"]];
			NSString* type = (storeType) ? storeType : NSSQLiteStoreType;
			
			NSError *error;
			persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
			
			NSDictionary *options;
			if(persistentStoreOptions) {
				options = persistentStoreOptions;
			} else {
				options = [self defaultPersistentStoreOptions];
			}

			if (!(persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:type configuration:nil URL:url options:options error:&error])) {
				// Handle error
				return NO;
			}
		}
	}
	return YES;
}

-(void) reset
{
	managedObjectContext = nil;
	managedObjectModel = nil;
	persistentStore = nil;
	persistentStoreCoordinator = nil;	
}

-(BOOL) save
{
	NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			return NO;
        } 
    }
	return YES;
}

-(void) beginTransaction
{
	[self.managedObjectContext lock];
}

-(void) endTransaction
{
	[self.managedObjectContext unlock];
}

-(void) commitTransaction
{
	[self save];
	[self.managedObjectContext unlock];
}

-(void) rollbackTransaction
{
	[self.managedObjectContext rollback]; 
	[self.managedObjectContext unlock];
}

-(NSArray*) execPredicate:(NSPredicate*)predicate entity:(NSString*)entity sortDescriptors:(NSArray*)sorts
{
	return [self execPredicate:predicate entity:entity sortDescriptors:sorts limit:0];
}

-(NSArray*) execPredicate:(NSPredicate*)predicate entity:(NSString*)entity sortDescriptors:(NSArray*)sorts limit:(NSUInteger)limit
{
	NSEntityDescription* ent = [NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext];
	if (!ent) {
		return nil;
	}
	
	NSFetchRequest* req = [[NSFetchRequest alloc] init];
	[req setEntity:ent];
	[req setFetchLimit:limit];
	if (predicate) {
		[req setPredicate:predicate];
	}
	if (sorts && [sorts count] > 0) {
		[req setSortDescriptors:sorts];
	}
	
	NSError* err = nil;
	NSArray* rets = [self.managedObjectContext executeFetchRequest:req error:&err];
	return rets;	
}

-(id) uniqueObjectForKey:(NSString*)key uniqueValue:(id)val entity:(NSString*)entity
{
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K=%@", key, val];
	NSArray* rets = [self execPredicate:predicate entity:entity sortDescriptors:nil];
	if (rets && [rets count] == 1) {
		return [rets objectAtIndex:0];
	}
	return nil;
}

-(NSDictionary*) metadata
{
	if (persistentStoreCoordinator && persistentStore) {
		return [persistentStoreCoordinator metadataForPersistentStore:persistentStore];
	}
	NSURL *url = (storeURL) ? storeURL : [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"data.db"]];
	NSString* type = (storeType) ? storeType : NSSQLiteStoreType;
	return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type URL:url error:nil];
}

-(void) setMetadata:(NSDictionary*)metadata
{
	if (persistentStoreCoordinator && persistentStore) {
		[persistentStoreCoordinator setMetadata:metadata forPersistentStore:persistentStore];
	} else {
		NSURL *url = (storeURL) ? storeURL : [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"data.db"]];
		NSString* type = (storeType) ? storeType : NSSQLiteStoreType;
		[NSPersistentStoreCoordinator setMetadata:metadata forPersistentStoreOfType:type URL:url error:nil];
	}
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	if(!modelURL) {
		managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	} else {
		managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	}
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
	@synchronized (self) {
		if (!persistentStoreCoordinator) {
			if (![self loadStore]) {
				return nil;
			}
		}
	}
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	if (!applicationDocumentsDirectory) {
#if TARGET_OS_IPHONE
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    applicationDocumentsDirectory = basePath;
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
		if (basePath) {
			basePath = [basePath stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
			NSFileManager* manager = [NSFileManager defaultManager];
			if (![manager fileExistsAtPath:basePath]) {
				[manager createDirectoryAtPath:basePath attributes:nil];
			}
		}
	applicationDocumentsDirectory = [basePath retain];
#endif
	}
	return applicationDocumentsDirectory;
}


@end
