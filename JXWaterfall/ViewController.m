//
//  ViewController.m
//  JXWaterfall
//
//  Created by yuezuo on 16/6/13.
//  Copyright © 2016年 yuezuo. All rights reserved.
//  瀑布流

#import "ViewController.h"
#import "JXWaterflowLayout.h"
#import "XMGShop.h"
#import "XMGShopCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JXWaterflowLayoutDelegate>
/** 所有的商品数据 */
@property (nonatomic,strong) NSMutableArray * shops;
/** UICollectionView */
@property (nonatomic,weak) UICollectionView * collectionView;
@end

@implementation ViewController

static NSString * const identifier = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
    [self setupRefresh];
}

- (void)setupLayout {
    // 创建布局
    JXWaterflowLayout * layout = [[JXWaterflowLayout alloc] init];
    layout.delegate = self;
    // 创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
}

- (void)setupRefresh {
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}

- (void)loadNewShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * shops = [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
    });
}

- (void)loadMoreShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * shops = [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
    });
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMGShopCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.row];
    
    return cell;
}

#pragma mark - JXWaterflowLayoutDelegate
- (CGFloat)waterflowLayout:(JXWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth {
    XMGShop * shop = self.shops[index];
    
    return itemWidth * shop.h / shop.w;
}

- (NSInteger)ColCountInWaterflowLayout:(JXWaterflowLayout *)waterflowLayout {
    return 2;
}

#pragma mark - 懒加载
-  (NSMutableArray *)shops {
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}
@end
