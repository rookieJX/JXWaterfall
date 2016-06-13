//
//  ViewController.m
//  JXWaterfall
//
//  Created by yuezuo on 16/6/13.
//  Copyright © 2016年 yuezuo. All rights reserved.
//  瀑布流

#import "ViewController.h"
#import "JXWaterflowLayout.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ViewController

static NSString * const identifier = @"layout";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建布局
    JXWaterflowLayout * layout = [[JXWaterflowLayout alloc] init];
    
    // 创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    
    NSInteger tag = 10;
    UILabel * label = (UILabel *)[cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"这是测试数据%zd",indexPath.item];
    [label sizeToFit];
    return cell;
}

@end
