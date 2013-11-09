//
//  PlainTableCtrl.m
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "PlainTableCtrl.h"

#define currentItemIndexPath [NSIndexPath indexPathForRow:self.content.currentItemIndex inSection:0]

@interface PlainTableCtrl ()

@property BOOL shouldReloadTableView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation PlainTableCtrl

#pragma mark - Creation

+ (id)ctrlWithTableView:(UITableView *)tableView
{
    PlainTableCtrl *result = nil;
    
    //===
    
    result = [[self class] new];
    
    [result configureWithTableView:tableView];
    
    [result reloadItems];
    
    //===
    
    return result;
}

#pragma mark - Clean Up

-(void)dealloc
{
    [self.itemsLoadingLock unlock];
}

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        
        _itemsLoadingLock = [NSLock new];
        
        _itemsLimit = 0;
        _preloadOffset = 10;
        
        _defaultCellIdentifier = @"Cell";
        _defaultReloadAnimation = UITableViewRowAnimationNone; // default for UITableView
        _shouldReloadTableView = YES;
        
        _initialCurrentItemIndex = NSNotFound; // do not autoselect by default
        
        _removeCellsBeforeReload = YES;
        _scrollToTopOnReload = YES;
        
        //===
        
        _content = [AdvancedList new];
        
        weakSelfMacro;
        _content.onDidChangeCurrentItem = ^(AdvancedList *list){
            
            [weakSelf selectCurrentRow];
            
            //===
            
            if (weakSelf.parentCtrl)
            {
                [weakSelf.parentCtrl applyItem:list.currentItem];
            }
        };
    }
    return self;
}

- (void)configureWithTableView:(UITableView *)tableView
{
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
}

- (void)registerCellNibWithName:(NSString *)nibName
{
    [self.tableView
     registerNibWithName:nibName
     forCellReuseIdentifier:self.defaultCellIdentifier];
}

- (void)registerCellNibWithName:(NSString *)nibName
         forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    [self.tableView
     registerNibWithName:nibName
     forCellReuseIdentifier:reuseIdentifier];
}

#pragma mark - Helpers

- (void)selectCurrentRow
{
    if (self.content.currentItem)
    {
        [self.tableView selectRowAtIndexPath:currentItemIndexPath
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone]; // !!!
    }
    else
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow
                                      animated:NO];
    }
}

- (void)reloadItems
{
    [self.content.items removeAllObjects];
    
    //===
    
    if (self.removeCellsBeforeReload)
    {
        [self.tableView reloadData];
    }
    
    //===
    
    [self loadItems];
}

- (void)reloadItemsWithCompletionBlock:(SimpleBlock)completionBlock
{
    self.reloadCompletionBlock = completionBlock;
    [self reloadItems];
}

- (void)loadItems
{
    if ([self.itemsLoadingLock tryLock])
    {
        self.shouldReloadTableView = (self.content.items.count == 0);
        [self loadMoreItemsWithOffset:self.content.items.count andLimit:self.itemsLimit];
    }
}

- (void)loadMoreItemsWithOffset:(NSUInteger)offset andLimit:(NSUInteger)limit
{
    //#warning Override in subclass - load items of content!
    
    //[self loadingFinishedWithItems:loadedObjects]; // DO NOT FORGET!!!
}

- (void)loadingFinishedWithItems:(NSArray *)itemsToAdd
{
    [self.content.items addObjectsFromArray:itemsToAdd];
    
    //===
    
    [self.itemsLoadingLock unlock];
    
    //===
    
    if (!self.tableView)
    {
        NSLog(@"Warning: reloading AdvancedTableCtrl with empty tableView outlet!");
    }
    
    //===
    
    if (self.shouldReloadTableView)
    {
        if (self.reloadCompletionBlock)
        {
            self.reloadCompletionBlock();
            self.reloadCompletionBlock = nil;
        }
        
        //===
        
        // reload all rows:
        [self reloadTableView];
        
        //===
        
        if (self.initialCurrentItemIndex != NSNotFound)
        {
            [self.content setItemCurrentByIndex:self.initialCurrentItemIndex];
        }
    }
    else
    {
        // just update rowCount and row params: // TODO: test it
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (void)reloadTableView
{
    // reload all rows by default:
    
    NSIndexSet *sectionIndexSet =
    [NSIndexSet indexSetWithIndexesInRange:
     NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView])];
    
    if (self.scrollToTopOnReload)
    {
        [self.tableView
         setContentOffset:CGPointMake(0.0, 0.0)
         animated:YES];
    }
    
    [self.tableView
     reloadSections:sectionIndexSet
     withRowAnimation:self.defaultReloadAnimation];
}

- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.defaultCellIdentifier;
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell withItem:(id)item
{
    // or configure cell here
}

- (void)reConfigureCurrentCell
{
    if (self.content.currentItem)
    {
        UITableViewCell *currentCell =
        [self.tableView cellForRowAtIndexPath:currentItemIndexPath];
        
        [currentCell reConfigure];
    }
}

- (void)selectFirstItemWhenReady
{
    if (!self.content.currentItem)
    {
        if (self.content.items.count)
        {
            [self.content setItemCurrentByIndex:0];
        }
        else
        {
            self.initialCurrentItemIndex = 0;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.content.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =
    [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    
    //===
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //===
    
    // set up default cell frame:
    
    CGRect frame = cell.frame;
    
    frame.size.width = self.tableView.frame.size.width;
    frame.size.height = self.tableView.rowHeight;
    
    cell.frame = frame;
    
    //===
    
    id item = [self.content.items safeObjectAtIndex:indexPath.row];
    
    if (item)
    {
        [self tableView:tableView configureCell:cell withItem:item];
    }
    
    //===
    
    if (self.itemsLimit &&
        ((self.content.items.count - indexPath.row) < self.preloadOffset))
    {
        [self loadItems];
    }
    
    //===
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.content setItemCurrentByIndex:indexPath.row];
}

@end
