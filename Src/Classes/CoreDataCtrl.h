//
//  CoreDataController.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/30/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <CoreData/CoreData.h>

//===

typedef void (^FetchCompletionBlock)(NSArray *objects, NSError *error);

//===

@interface CoreDataCtrl : NSObject

@property (readonly, nonatomic) NSString *modelName;
@property (readonly, nonatomic) NSManagedObjectModel *model;
@property (readonly, nonatomic) NSString *storageName;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *coordinator;

@property (readonly, nonatomic) NSManagedObjectContext *writerContext;
@property (readonly, nonatomic) NSManagedObjectContext *uiContext;

- (NSManagedObjectContext *)newBackgroundContext;
- (NSManagedObjectContext *)newLegacyContext;

- (id)newEntityWithClass:(Class)entityClass
              andContext:(NSManagedObjectContext *)context;

- (NSFetchRequest *)requestWithEntityName:(NSString *)entityName
                               andContext:(NSManagedObjectContext *)context;

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                     withContext:(NSManagedObjectContext *)context
                        andError:(NSError **)error;
- (void)executeFetchRequest:(NSFetchRequest *)request
                withContext:(NSManagedObjectContext *)context
              andCompletion:(FetchCompletionBlock)completionBlock;

- (NSError *)saveInContext:(NSManagedObjectContext *)context;
- (void)saveInContext:(NSManagedObjectContext *)context
       withCompletion:(OperationCompletionBlock)completionBlock;

@end