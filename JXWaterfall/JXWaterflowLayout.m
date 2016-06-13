//
//  JXWaterflowLayout.m
//  JXWaterfall
//
//  Created by yuezuo on 16/6/13.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "JXWaterflowLayout.h"

@interface JXWaterflowLayout ()

/** 存放所有cell的布局属性 */
@property (nonatomic,strong) NSMutableArray * array;
@end

@implementation JXWaterflowLayout

/**
 *  初始化,只会调用一次
 */
- (void)prepareLayout {
    [super prepareLayout];
    
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
    
    // 设置布局属性的frame
    attrs.frame = CGRectMake(arc4random_uniform(300), arc4random_uniform(300), arc4random_uniform(300), arc4random_uniform(300));
    return attrs;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, 1000);
}

#pragma mark - 懒加载
- (NSMutableArray *)array {
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
