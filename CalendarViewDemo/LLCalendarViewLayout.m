//
//  LLCalendarViewLayout.m
//  CalendarViewDemo
//
//  Created by Jeremy Lubin on 9/12/13.
//  Copyright (c) 2013 Lubin Labs. All rights reserved.
//

#import "LLCalendarViewLayout.h"

#define kScreenWidth             320
#define kKeyboardHeight          216
#define kNumberOfDaysInWeek      7
#define kNumberOfWeeksInMonth    6

static NSString * const LLCalendarLayoutDayCellKind = @"DayCell";

@interface LLCalendarViewLayout()
@property (nonatomic, strong) NSDictionary *layoutInfo;
@end

@implementation LLCalendarViewLayout

- (id)init
{
    if (self = [super init])
    {
        _itemInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _itemSize = CGSizeMake(kScreenWidth / kNumberOfDaysInWeek, kKeyboardHeight / kNumberOfWeeksInMonth);
        _interItemSpacingY = 0.0;
        _numberOfColumns = kNumberOfDaysInWeek;
        _numberOfRows = kNumberOfWeeksInMonth;
    }
    return self;
}

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForCalendarDayCellAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[LLCalendarLayoutDayCellKind] = cellLayoutInfo;
    _layoutInfo = newLayoutInfo;
}

- (CGRect)frameForCalendarDayCellAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculate the cell's origin-x
    // by adding the cumulative width of all previous sections
    // to the cumulative width of all previous cells in this section
    // that fall within the same row
    NSInteger column = indexPath.item < _numberOfColumns ? indexPath.item : indexPath.item % _numberOfColumns;
    CGFloat originX = _itemSize.width * (indexPath.section * _numberOfColumns + column);
    
    // Calculate the cell's origin-y
    // by adding the cumulative width of the previous cells in this section
    // that fall within the same column
    NSInteger row = indexPath.item / _numberOfColumns;
    CGFloat originY = _itemSize.height * row;
    
    return CGRectMake(originX, originY, _itemSize.width, _itemSize.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [_layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _layoutInfo[LLCalendarLayoutDayCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    // Return a size struct with the content view's height and the width of all of it's sections
    NSInteger width = [self.collectionView numberOfSections] * _numberOfColumns * _itemSize.width;
    return CGSizeMake(width, self.collectionView.bounds.size.height);
}

@end
