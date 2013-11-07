//
//  AdvancedTableViewCtrl.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvancedTableCtrl : NSObject
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSObject *parentCtrl;

@property BOOL removeCellsBeforeReload;
@property BOOL scrollToTopOnReload;

@property (readonly, nonatomic) AdvancedList *content;
@property (nonatomic, readonly) NSLock *itemsLoadingLock;
@property NSUInteger initialCurrentItemIndex; // set an index for autoselect

// pagination support:
@property NSUInteger itemsLimit; // if == 0 -> NO limit
@property NSUInteger preloadOffset;

@property (readonly, nonatomic) UITableView *tableView;

@property (nonatomic, copy) NSString *defaultCellIdentifier;
@property UITableViewRowAnimation defaultReloadAnimation;

@property (nonatomic, strong) SimpleBlock reloadCompletionBlock;

//=== Creation

+ (id)ctrlWithTableView:(UITableView *)tableView;

//=== Initialization

- (void)configureWithTableView:(UITableView *)tableView;
- (void)registerCellNibWithName:(NSString *)nibName;
- (void)registerCellNibWithName:(NSString *)nibName
         forCellReuseIdentifier:(NSString *)reuseIdentifier;

//=== Manage

- (void)selectCurrentRow;

- (void)reloadItems;
- (void)reloadItemsWithCompletionBlock:(SimpleBlock)completionBlock;
- (void)loadItems;

- (void)loadMoreItemsWithOffset:(NSUInteger)offset andLimit:(NSUInteger)limit;

- (void)loadingFinishedWithItems:(NSArray *)itemsToAdd; // call this method to add newly loaded items to content & notify about this

- (void)reloadTableView; // reload table view with default params, override to change default implementation, do not call directly!

- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)reConfigureCurrentCell;

- (void)selectFirstItemWhenReady;

@end
