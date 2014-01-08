//
//  CoreDataController.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/30/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//
//  Based on: http://stackoverflow.com/questions/14043384/core-data-locks-in-background-threads

#import "CoreDataCtrl.h"

@interface CoreDataCtrl ()
{
    NSManagedObjectModel *_model;
    NSPersistentStoreCoordinator *_coordinator;
    
    NSManagedObjectContext *_uiContext;
    NSManagedObjectContext *_writerContext;
}

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CoreDataCtrl

#pragma mark - Property accessors

- (NSString *)modelName
{
    return @"DefaultModelName"; // override in subclass!!!
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)model
{
    if (_model == nil)
    {
        NSURL *modelURL =
        [[NSBundle mainBundle] URLForResource:self.modelName
                                withExtension:@"momd"];
        
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    //===
    
    return _model;
}

- (NSString *)storageName
{
    return @"DefaultStorageName"; // override in subclass!!!
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)coordinator
{
    if (_coordinator == nil)
    {
        NSURL *storeURL =
        [[UIApplication sharedApplication].applicationDocumentsDirectory
         URLByAppendingPathComponent:self.storageName];
        
        NSError *error = nil;
        
        _coordinator =
        [[NSPersistentStoreCoordinator alloc]
         initWithManagedObjectModel:[self model]];
        
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:storeURL
                                              options:nil
                                                error:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
//#warning Remove in production!!!
//            abort();
        }
    }
    
    //===
    
    return _coordinator;
}

- (NSManagedObjectContext *)writerContext
{
    if (!_writerContext)
    {
        NSPersistentStoreCoordinator *coordinator = self.coordinator;
        
        if (coordinator != nil)
        {
            _writerContext =
            [[NSManagedObjectContext alloc]
             initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            
            [_writerContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    //===
    
    return _writerContext;
}

- (NSManagedObjectContext *)uiContext
{
    if (!_uiContext)
    {
        _uiContext =
        [[NSManagedObjectContext alloc]
         initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        _uiContext.parentContext = self.writerContext;
    }
    
    //===
    
    return _uiContext;
}

#pragma mark - Helpers

- (NSManagedObjectContext *)newBackgroundContext
{
    NSManagedObjectContext *result =
    [[NSManagedObjectContext alloc]
     initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    result.parentContext = self.writerContext;
    
    //===
    
    return result;
}

- (NSManagedObjectContext *)newLegacyContext
{
    NSManagedObjectContext *result = nil;
    
    //===
    
    NSPersistentStoreCoordinator *coordinator = self.coordinator;
    
    if (coordinator != nil)
    {
        result =
        [[NSManagedObjectContext alloc]
         initWithConcurrencyType:NSConfinementConcurrencyType];
        
        [result setPersistentStoreCoordinator:coordinator];
    }
    
    //===
    
    return result;
}

- (id)newEntityWithClass:(Class)entityClass
                             andContext:(NSManagedObjectContext *)context
{
    if (!context)
    {
        // Use default context
        context = self.writerContext;
    }
    
    //===
    
    return
    [NSEntityDescription
     insertNewObjectForEntityForName:NSStringFromClass(entityClass)
     inManagedObjectContext:context];
}

- (NSFetchRequest *)requestWithEntityName:(NSString *)entityName
                               andContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *result = nil;
    
    //===
    
    if (!context)
    {
        // Use default context
        context = self.writerContext;
    }
    
    //===
    
    NSEntityDescription *entityDescription =
    [NSEntityDescription entityForName:entityName
                inManagedObjectContext:context];
    
    if (entityDescription)
    {
        result = [NSFetchRequest new];
        [result setEntity:entityDescription];
    }
    
    //===
    
    return result;
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
                     withContext:(NSManagedObjectContext *)context
                        andError:(NSError **)error
{
    __block NSArray *result = nil;
    
    //===
    
    if (request)
    {
        if (!context)
        {
            // Use default context
            context = self.writerContext;
        }
        
        //===
        
        SimpleBlock fetchBlock = ^{
            
            result = [context executeFetchRequest:request error:error];
        };
        
        //===
        
        if (context.concurrencyType == NSConfinementConcurrencyType)
        {
            // legacy
            
            fetchBlock();
        }
        else
        {
            // NSPrivateQueueConcurrencyType - generic background context
            // NSMainQueueConcurrencyType - the only UI context
            
            [context performBlockAndWait:fetchBlock];
        }
    }
    
    //===
    
    return result;
}

- (void)executeFetchRequest:(NSFetchRequest *)request
                withContext:(NSManagedObjectContext *)context
              andCompletion:(ArrayResultBlock)completionBlock
{
    if (!context)
    {
        // Use default context
        context = self.writerContext;
    }
    
    //===
    
    __block NSArray *objects = nil;
    __block NSError *error = nil;
    
    SimpleBlock fetchBlock = ^{
        
        objects = [context executeFetchRequest:request error:&error];
        
        if (completionBlock)
        {
            completionBlock(objects, error);
        }
    };
    
    //===
    
    if (context.concurrencyType == NSConfinementConcurrencyType)
    {
        // legacy
        
        fetchBlock();
    }
    else
    {
        // NSPrivateQueueConcurrencyType - generic background context
        // NSMainQueueConcurrencyType - the only UI context
        
        [context performBlock:fetchBlock];
    }
}

- (NSError *)saveInContext:(NSManagedObjectContext *)context
{
    if (!context)
    {
        // Use default context
        context = self.writerContext;
    }
    
    //===
    
    __block NSError *result = nil;
    
    //===
    
    if ([context hasChanges])
    {
        SimpleBlock saveBlock = ^{
            
            if ([context save:&result])
            {
                if (context.parentContext)
                {
                    result = [self saveInContext:context.parentContext];
                }
            }
            else
            {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 */
                NSLog(@"Unresolved error %@, %@", result, [result userInfo]);
                
//#warning Remove in production!!!
//                abort();
            }
        };
        
        //===
        
        if (context.concurrencyType == NSConfinementConcurrencyType)
        {
            // legacy
            
            saveBlock();
        }
        else
        {
            // NSPrivateQueueConcurrencyType - generic background context
            // NSMainQueueConcurrencyType - the only UI context
            
            [context performBlockAndWait:saveBlock];
        }
    }
    
    //===
    
    return result;
}

- (void)saveInContext:(NSManagedObjectContext *)context
       withCompletion:(OperationCompletionBlock)completionBlock
{
    if (!context)
    {
        // Use default context
        context = self.writerContext;
    }
    
    //===
    
    if ([context hasChanges])
    {
        __block NSError *error = nil;
        
        //===
        
        SimpleBlock saveBlock = ^{
            
            if ([context save:&error])
            {
                if (context.parentContext)
                {
                    [self saveInContext:context.parentContext
                                 withCompletion:completionBlock];
                }
                else // parentContext == nil, i.e. it is the writer context
                {
                    if (completionBlock)
                    {
                        completionBlock(error);
                    }
                }
            }
            else
            {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                
                if (completionBlock)
                {
                    completionBlock(error);
                }
                
//#warning Remove in production!!!
//                abort();
            }
        };
        
        //===
        
        if (context.concurrencyType == NSConfinementConcurrencyType)
        {
            // legacy
            
            saveBlock();
        }
        else
        {
            // NSPrivateQueueConcurrencyType - generic background context
            // NSMainQueueConcurrencyType - the only UI context
            
            [context performBlock:saveBlock];
        }
    }
}

@end
