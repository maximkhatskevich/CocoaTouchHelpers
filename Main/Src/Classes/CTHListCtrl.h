//
//  CTHListCtrl.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/07/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalBase.h"

@interface CTHListCtrl : NSObject
//<UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) NSObject *primaryObserver;
//
//@property BOOL shouldAnimateSelection;
//
//@property BOOL removeCellsBeforeReload;
//@property BOOL scrollToTopOnReload;
//
//@property BOOL autoConfigureCell;
//
//@property NSIndexPath *initialItemIndex; // set an index for autoselect
//
//// pagination support:
//@property NSUInteger itemsLimit; // if == 0 -> NO limit
//@property NSUInteger preloadOffset;
//
//@property (readonly, weak, nonatomic) UITableView *tableView;
//
//@property (copy, nonatomic) NSString *defaultCellIdentifier;
//@property UITableViewRowAnimation defaultReloadAnimation;
//
////===
//
//- (void)registerCellNibWithName:(NSString *)nibName;
//- (void)registerCellNibWithName:(NSString *)nibName
//         forCellReuseIdentifier:(NSString *)reuseIdentifier;
//
////===
//
//- (void)displaySelection;
//
//- (void)reloadItems;
//- (void)reloadItemsWithCompletionBlock:(SimpleBlock)completionBlock;
//- (void)loadItems;
//
//- (void)loadMoreItemsWithOffset:(NSUInteger)offset andLimit:(NSUInteger)limit;
//
//- (void)loadingFinishedWithItems:(NSArray *)itemsToAdd; // call this method to add newly loaded items to content & notify about this
//
//- (void)reloadTableView; // reload table view with default params, override to change default implementation, do not call directly!
//
//- (NSString *)cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath;
//
//// prior iOS 6.0 compatibility
//- (Class)cellClassForCellIdentifier:(NSString *)cellIdentifier;
//
//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(id)item;
//- (void)updateVisibleCells;
//- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item;
//- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withItem:(id)item;
//
//- (void)reConfigureCurrentCell;
//- (void)reConfigureVisibleCells;
//
//- (void)selectFirstItemWhenReady;

@end
