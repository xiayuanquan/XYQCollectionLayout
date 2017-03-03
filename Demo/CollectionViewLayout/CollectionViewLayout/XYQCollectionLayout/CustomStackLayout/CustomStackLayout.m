//
//  CustomStackLayout.m
//  集合视图纯自定义布局
//
//  Created by ma c on 15/11/20.
//  Copyright (c) 2015年 夏远全. All rights reserved.
//

#import "CustomStackLayout.h"

#define RANDOM_0_1  arc4random_uniform(100)/100.0

/*
 由于CustomStackLayout是直接继承自UICollectionViewLayout的,父类没有帮它完成任何的布局，因此，
 需要用户自己完全重新对每一个item进行布局，也即设置它们的布局属性UICollectionViewLayoutAttributes
*/

@implementation CustomStackLayout

//重写shouldInvalidateLayoutForBoundsChange,每次重写布局内部都会自动调用
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{

    return YES;
}

//重写collectionViewContentSize,可以让collectionView滚动
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(400, 400);
}

//重写layoutAttributesForItemAtIndexPath,返回每一个item的布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建布局实例
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //设置布局属性
    attrs.size = CGSizeMake(100, 100);
    attrs.center = CGPointMake(self.collectionView.frame.size.width*0.5, self.collectionView.frame.size.height*0.5);
    
    //设置旋转方向
    //int direction = (i % 2 ==0)? 1: -1;
    
    NSArray *directions = @[@0.0,@1.0,@(0.05),@(-1.0),@(-0.05)];
    
    //只显示5张
    if (indexPath.item >= 5)
    {
        attrs.hidden = YES;
    }
    else
    {
        //开始旋转
        attrs.transform = CGAffineTransformMakeRotation([directions[indexPath.item]floatValue]);
        
        //zIndex值越大,图片越在上面
        attrs.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;
    }

    return attrs;
}


//重写layoutAttributesForElementsInRect,设置所有cell的布局属性（包括item、header、footer）
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *arrayM = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    //给每一个item创建并设置布局属性
    for (int i = 0; i < count; i++)
    {
        //创建item的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
         [arrayM addObject:attrs];
    }
    return arrayM;
}

@end
