//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FTDataStorage : NSObject 
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;		
    NSPersistentStore *persistentStore;		

	NSString* applicationDocumentsDirectory;
	NSURL* storeURL;
	NSString* storeType;
	NSDictionary *persistentStoreOptions;
	NSURL* modelURL;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSPersistentStore *persistentStore;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) NSURL* storeURL;
@property (nonatomic, retain) NSString* storeType;
@property (nonatomic, retain) NSDictionary *persistentStoreOptions;
@property (nonatomic, retain) NSURL* modelURL;

+(id) sharedStorage;

-(NSDictionary *)defaultPersistentStoreOptions;

-(BOOL) loadStore;
-(void) reset;

-(BOOL) save;
-(void) beginTransaction;
-(void) endTransaction;
-(void) commitTransaction;
-(void) rollbackTransaction;

-(NSArray*) execPredicate:(NSPredicate*)predicate entity:(NSString*)entity sortDescriptors:(NSArray*)sorts;
-(NSArray*) execPredicate:(NSPredicate*)predicate entity:(NSString*)entity sortDescriptors:(NSArray*)sorts limit:(NSUInteger)limit;
-(id) uniqueObjectForKey:(NSString*)key uniqueValue:(id)val entity:(NSString*)entity;

-(NSDictionary*) metadata;
-(void) setMetadata:(NSDictionary*)metadata;

@end
