//
//  DataController.m
//  table
//
//  Created by Vlad on 10.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//


#import "TableDataController.h"
#import "CellModel.h"
#import "ImageModel.h"
#import "TableViewCell.h"
#import "ImageDataSource.h"

@interface NSString (random)
+(NSString *)randomStringWithLength:(int)len;
@end

@implementation NSString (random)
+ (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}
@end

NSString *const entityName = @"CellModel";
NSString *const imageEntityName = @"ImageModel";
NSString *const myCellIdentifier = @"TableViewCell";

@interface TableDataController() <NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ImageDataSource *imageDataSource;
@property (nonatomic,strong) ImageDownloader *imageDownloader;

@end

@implementation TableDataController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        [fetchRequest setFetchBatchSize:20];
        NSFetchedResultsController *theFetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:self.managedObjectContext
                                              sectionNameKeyPath:nil
                                                       cacheName:@"Root"];
        self.fetchedResultsController = theFetchedResultsController;
        self.fetchedResultsController.delegate = self;
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        self.tableView = tableView;
        self.imageDownloader = [[ImageDownloader alloc] init];
        self.imageDataSource = [[ImageDataSource alloc] initWithImageDownloader:self.imageDownloader andTableDataController:self];
        self.imageData = self.imageDataSource;
    }
    return self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CellModel *cellModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = cellModel.title;
    cell.subTitleLabel.text = cellModel.subTitle;
    if (![cellModel.imageUrl isEqualToString:@""] && cellModel.imageUrl!=nil )
    {
        [self.imageDataSource downloadImageAtURL:cellModel.imageUrl forCell:cell];
    }
    cell.cellModel = cellModel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
}

#pragma mark - CoreData updating data

- (void)addImageFromData:(NSData *)imageData withURL:(NSString *)url
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    ImageModel *imageModel = [NSEntityDescription insertNewObjectForEntityForName:imageEntityName
                                                           inManagedObjectContext:managedObjectContext];
    imageModel.imageUrl = url;
    imageModel.imageData = imageData;
    [self saveContext];
}

- (NSData *)ImageDataWithURL:(NSString *)url
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:imageEntityName];
    NSArray *imageModelArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    ImageModel *imageModel;
    for (imageModel in imageModelArray)
    {
        if ([imageModel.imageUrl isEqualToString:url]) return imageModel.imageData;
    }
    return nil;
}

- (NSArray *)cellModelArray
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSArray *cellModelArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return cellModelArray;
}

- (void)addCellModelsFromArray:(NSArray *)dataArray activityIndicator:(UIActivityIndicatorView *)activityIndicator
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSDictionary *cellModelData;
    NSArray *cellModelArray = [self cellModelArray];
    CellModel *cellModel;
    for (cellModel in cellModelArray)
    {
        BOOL finded = NO;
        for (cellModelData in dataArray)
        {
            if ([[cellModelData objectForKey:@"_id"] isEqualToString: cellModel.objectId])
            {
                finded = YES;
                [cellModel updateCellWithDictionary:cellModelData];
                break;
            }
        }
        if (!finded)
        {
            [managedObjectContext deleteObject:cellModel];
        }
        
    }
    
    for (cellModelData in dataArray)
    {
        CellModel *cellModel;
        BOOL finded = NO;
        for (cellModel in cellModelArray)
        {
            if ([[cellModelData objectForKey:@"_id"] isEqualToString: cellModel.objectId])
            {
                finded = YES;
                break;
            }
        }
        if (!finded)
        {
            CellModel *addCellModel = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                    inManagedObjectContext:managedObjectContext];
            [addCellModel updateCellWithDictionary:cellModelData];
        }
    }
    [self saveContext];
    [activityIndicator stopAnimating];
}


#pragma mark - Add/Edit CellModel

- (NSDictionary *)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    CellModel *cellModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSData *imageData = [self ImageDataWithURL:cellModel.imageUrl];
    NSDictionary *cellData = @{    @"title" : cellModel.title,
                                   @"subTitle" : cellModel.subTitle,
                                   @"content" : cellModel.content,
                                   @"imageUrl" : cellModel.imageUrl};
    NSMutableDictionary *newCellData = [[NSMutableDictionary alloc] initWithDictionary:cellData];
    if (imageData)
    {
        [newCellData setObject:imageData forKey:@"imageData"];
    }
    return newCellData;
}

- (void)updateCellModelFromCellData:(NSDictionary *)cellData atIndexPath:(NSIndexPath *)indexPath
{
    CellModel *cellModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cellModel.title = [cellData valueForKey:@"title"];
    cellModel.subTitle = [cellData valueForKey:@"subTitle"];
    cellModel.content = [cellData valueForKey:@"content"];
    NSData *imageData = [cellData valueForKey:@"imageData"];
    if (imageData != nil)
    {
        cellModel.imageUrl = [NSString randomStringWithLength:15];
        cellModel.imageData = imageData;
        [self addImageFromData:imageData withURL:cellModel.imageUrl];
    //    [self.syncController addImageFromData:imageData withURL:cellModel.imageUrl];
    }
    [self.syncController updatedCellModel:cellModel];
}

- (void)addCellModelFromCellData:(NSDictionary *)cellData
{
    CellModel *cellModel = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                         inManagedObjectContext:self.managedObjectContext];
    cellModel.title = [cellData valueForKey:@"title"];
    cellModel.subTitle = [cellData valueForKey:@"subTitle"];
    cellModel.content = [cellData valueForKey:@"content"];
    cellModel.imageUrl = @"";
    [self.syncController createdCellModel:cellModel];
}

- (void)deleteCellModelAtIndexPath:(NSIndexPath *)indexPath
{
    CellModel *cellModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.syncController deletedCellModel:cellModel];
    [self.managedObjectContext deleteObject:cellModel];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cellData6.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    dispatch_async(dispatch_get_main_queue(), ^{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@", error);
        }
    }
    });
}


@end
