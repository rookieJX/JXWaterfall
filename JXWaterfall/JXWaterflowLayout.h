//
//  JXWaterflowLayout.h
//  JXWaterfall
//
//  Created by yuezuo on 16/6/13.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXWaterflowLayout;

@protocol JXWaterflowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(JXWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional

/** 每一列之间的间距 */
- (CGFloat)ColMarginInWaterflowLayout:(JXWaterflowLayout *)waterflowLayout;
/** 每一行之间的间距 */
- (CGFloat)RowMarginInWaterflowLayout:(JXWaterflowLayout *)waterflowLayout;
/** 边缘间距 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(JXWaterflowLayout *)waterflowLayout;
/** 默认的列数 */
- (NSInteger)ColCountInWaterflowLayout:(JXWaterflowLayout *)waterflowLayout;

@end

@interface JXWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic,weak) id<JXWaterflowLayoutDelegate> delegate;
@end
