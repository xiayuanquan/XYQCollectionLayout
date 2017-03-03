//
//  CollectionViewController.m
//  CollectionViewLayout
//
//  Created by 夏远全 on 2017/3/3.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "CollectionViewController.h"
#import "WaterFlowLayout.h"
#import "CustomLineLayout.h"
#import <UIImageView+WebCache.h>

@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WaterFlowLayoutDelegate>
@property (strong,nonatomic)UICollectionView *collectionView;
@end

@implementation CollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化collectionView
    CGRect frame = self.view.bounds;
    if ([self.layout isKindOfClass:[CustomLineLayout class]]) {
        frame = CGRectMake(0, 250, self.view.bounds.size.width, 200);
    }
    if ([self.layout isKindOfClass:[WaterFlowLayout class]]) {
        WaterFlowLayout *waterLayout = (WaterFlowLayout *)self.layout;
        waterLayout.delegate = self;
    }
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
    
    //设置数据源
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuseCell"];
    
    //添加到父视图中
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCell" forIndexPath:indexPath];
    
    //瀑布流内容
    if ([self.layout isKindOfClass:[WaterFlowLayout class]]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self waterFlowImages][indexPath.row]]];
        [cell.contentView addSubview:imageView];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个item",indexPath.row);
}

#pragma mark - WaterFlowLayoutDelegate
-(CGFloat)waterFlowLayout:(WaterFlowLayout *)WaterFlowLayout heightForWidth:(CGFloat)width andIndexPath:(NSIndexPath *)indexPath{
    return 100/[[self rateForWidthDividedHeight][indexPath.row]floatValue];
}


//瀑布流图片
- (NSArray *)waterFlowImages{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@".plist"];
    NSArray *images = [NSArray arrayWithContentsOfFile:path];
    __block NSMutableArray *imageURLs = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(NSDictionary *imageDic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlStr = imageDic[@"img"];
        [imageURLs addObject:urlStr];
    }];
    return imageURLs;
}

//瀑布流图片真实宽高比
- (NSArray *)rateForWidthDividedHeight{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@".plist"];
    NSArray *images = [NSArray arrayWithContentsOfFile:path];
    __block NSMutableArray *rates = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(NSDictionary *imageDic, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [imageDic[@"w"] floatValue];
        CGFloat h = [imageDic[@"h"] floatValue];
        [rates addObject:@(w/h)];
    }];
    return rates;
}

@end
