//
//  JXWaterflowLayout.m
//  JXWaterfall
//
//  Created by yuezuo on 16/6/13.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "JXWaterflowLayout.h"
/** 默认的列数 */
static const NSInteger JXDefaultColCount = 3;
/** 每一列之间的间距 */
static const CGFloat JXDefaultColMargin = 10;
/** 每一行之间的间距 */
static const CGFloat JXDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets JXDefaultUIEdgeInsets = {10,10,10,10};


@interface JXWaterflowLayout ()

/** 存放所有cell的布局属性 */
@property (nonatomic,strong) NSMutableArray * array;
/** 用来存放所有列的最大Y值 */
@property (nonatomic,strong) NSMutableArray * maxYs;

/** 列之间距离 */
- (CGFloat)colMargin;
/** 行之间距离 */
- (CGFloat)rowMargin;
/** 列数 */
- (NSInteger)colCount;
/** 边缘距离 */
- (UIEdgeInsets)edgeInsets;

@end

@implementation JXWaterflowLayout

- (CGFloat)colMargin {
    if ([self.delegate respondsToSelector:@selector(ColMarginInWaterflowLayout:)]) {
        return [self.delegate ColMarginInWaterflowLayout:self];
    } else {
        return JXDefaultColMargin;
    }
}

- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(RowMarginInWaterflowLayout:)]) {
        return [self.delegate RowMarginInWaterflowLayout:self];
    } else {
        return JXDefaultRowMargin;
    }
}

- (NSInteger)colCount {
    if ([self.delegate respondsToSelector:@selector(ColCountInWaterflowLayout:)]) {
        return [self.delegate ColCountInWaterflowLayout:self];
    } else {
        return JXDefaultColCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return JXDefaultUIEdgeInsets;
    }
}



/**
 *  初始化,只会调用一次,刷新之后还会继续调用
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    // 先清除以前计算的所有高度
    [self.maxYs removeAllObjects];
    
    // 循环添加默认值
    for (NSInteger i = 0; i < self.colCount; i++) {
        
        [self.maxYs addObject:@(self.edgeInsets.top)];
    }
    
    
    // 清楚之前的所有的布局属性(当有刷新的时候数组会越来越大)
    [self.array removeAllObjects];
    
    // 开始创建每一个cell的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath * index = [NSIndexPath indexPathForItem:i inSection:0];

        // 获取index对应位置cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:index];
        [self.array addObject:attrs];
    }
    
}

/**
 *  决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    
    return self.array;
}


/**
 *  返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // collectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    
    // 设置布局属性的frame（主要是找到最短的一列就可以）
    
    // 设置宽度
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.colCount - 1) * self.colMargin ) / self.colCount;
    
    // 设置高度
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 找出y值最小的一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.maxYs[0] doubleValue];
    for (NSInteger i = 1; i < self.colCount; i++) {
        // 取出第i列的高度
        CGFloat columHeight = [self.maxYs[i] doubleValue];
        
        // 如果比最小的还要小，就记录
        if (minColumnHeight > columHeight) {
            minColumnHeight = columHeight;
            destColumn = i;
        }
    }
    // 设置x值(根据找到的最小的y值来计算)
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.rowMargin);
    // 设置y值
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) { // 如果不是第一行
        y += self.edgeInsets.top;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短一列的高度
    self.maxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

- (CGSize)collectionViewContentSize {
    // 计算contentsize
    CGFloat maxColumnHeight = [self.maxYs[0] doubleValue];
    for (NSInteger i = 1; i < self.colCount; i++) {
        // 取出第i列的高度
        CGFloat columnHeight = [self.maxYs[i] doubleValue];
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
            
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}

#pragma mark - 懒加载
- (NSMutableArray *)array {
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)maxYs {
    if (_maxYs == nil) {
        _maxYs = [NSMutableArray array];
    }
    return _maxYs;
}

@end
