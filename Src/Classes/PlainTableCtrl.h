//
//  PlainTableCtrl.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//
// NOTE: "plain" menas that it consists of THE ONLY SECTION

#import <Foundation/Foundation.h>

@interface PlainTableCtrl : NSObject
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSObject *parentCtrl;

@property BOOL removeCellsBeforeReload;
@property BOOL scrollToTopOnReload;

@property (readonly, nonatomic) AdvancedList *content;
@property (readonly, nonatomic) NSLock *itemsLoadingLock;
@property NSUInteger initialCurrentItemIndex; // set an index for autoselect

// pagination support:
@property NSUInteger itemsLimit; // if == 0 -> NO limit
@property NSUInteger preloadOffset;

@property (readonly, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *defaultCellIdentifier;
@property UITableViewRowAnimation defaultReloadAnimation;

//===

- (void)registerCellNibWithName:(NSString *)nibName;
- (void)registerCellNibWithName:(NSString *)nibName
         forCellReuseIdentifier:(NSString *)reuseIdentifier;

//===

- (void)selectCurrentRow;

- (void)reloadItems;
- (void)reloadItemsWithCompletionBlock:(SimpleBlock)completionBlock;
- (void)loadItems;

- (void)loadMoreItemsWithOffset:(NSUInteger)offset andLimit:(NSUInteger)limit;

- (void)loadingFinishedWithItems:(NSArray *)itemsToAdd; // call this method to add newly loaded items to content & notify about this

- (void)reloadTableView; // reload table view with default params, override to change default implementation, do not call directly!

- (NSString *)cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(id)item;
- (void)updateVisibleCells;
- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item;
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(id)item;

- (void)reConfigureCurrentCell;
- (void)reConfigureVisibleCells;

- (void)selectFirstItemWhenReady;

@end
