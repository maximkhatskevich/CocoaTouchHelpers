//
//  CTHElasticFlowLayout.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/08/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHElasticFlowLayout.h"

//===

@interface CTHElasticFlowLayout ()

@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

//===

@implementation CTHElasticFlowLayout

#pragma mark - Overrided methods

- (void)prepareLayout
{
    [super prepareLayout];
    
    //===
    
    CGSize contentSize = self.collectionViewContentSize;
    
    if (contentSize.height && !self.animator)
    {
        self.animator = [[UIDynamicAnimator alloc]
                         initWithCollectionViewLayout:self];
        
        NSArray *items =
        [super layoutAttributesForElementsInRect:
         CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for (UICollectionViewLayoutAttributes *item in items)
        {
            UIAttachmentBehavior *spring =
            [[UIAttachmentBehavior alloc]
             initWithItem:item
             attachedToAnchor:item.center];
            
            spring.length = 0;
            spring.damping = 0.9;
            spring.frequency = 0.8;
            
            [self.animator addBehavior:spring];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *result =
    [self.animator layoutAttributesForCellAtIndexPath:indexPath];
    
    return result;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    CGPoint touchLocation = [scrollView.panGestureRecognizer
                             locationInView:scrollView];
    
    //===
    
    // do shifting...
    
    for (UIAttachmentBehavior *spring in self.animator.behaviors)
    {
        CGPoint anchorPoint = spring.anchorPoint;
        CGFloat distanceFromTouch = fabsf(touchLocation.y - anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / 500;
        
        //===
        
        UICollectionViewLayoutAttributes *item = spring.items.firstObject;
        CGPoint center = item.center;
        CGFloat centerOffsetY = (delta > 0 ?
                                 MIN(delta, delta * scrollResistance) :
                                 MAX(delta, delta * scrollResistance));
        
        center.y += centerOffsetY;
        item.center = center;
        
        //===
        
        // notify UIDynamicAnimator...
        
        [self.animator updateItemUsingCurrentState:item];
    }
    
    //===
    
    return NO;
}

@end
