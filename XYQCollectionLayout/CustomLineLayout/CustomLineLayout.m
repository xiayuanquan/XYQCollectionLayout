//
//  CustomLineLayout.m
//  集合视图自定义布局
//
//  Created by ma c on 15/11/19.
//  Copyright (c) 2015年 夏远全. All rights reserved.
//

#import "CustomLineLayout.h"

//设置item的固定的宽和高
static const CGFloat itemWH = 100;

//设置缩放时的有效距离
static const CGFloat activeDistance = 150;

//设置缩放因数,值越大,缩放效果越明显
static const CGFloat scaleFactor = 0.6;

@implementation CustomLineLayout


//UICollectionViewLayoutAttributes:很重要,布局属性设置
//每一个cell(item)都有自己的UICollectionViewLayoutAttributes
//每一个indexPath都有自己的UICollectionViewLayoutAttributes

-(instancetype)init{
    if (self = [super init]){
        
    }
    return self;
}

//每一次重新布局前,都会准备布局（苹果官方推荐使用该方法进行一些初始化）
-(void)prepareLayout
{
    [super prepareLayout];
    
    //初始化,设置默认的item属性
    self.itemSize = CGSizeMake(itemWH, itemWH);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = itemWH * scaleFactor;
    
    //将第一个和最后一个item始终显示在中间,即分别将它们设置到组头和组尾的距离
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    CGFloat inset = (width - itemWH) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, (height-itemWH)/2, inset);
}

//是否要重新刷新布局(只要显示的item边界发生改变就重新布局)
//只要每一次重新布局内部就会调用下面的layoutAttributesForElementsInRect:获取所有cell(item)的属性
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


//用来设置colectionView停止滚动时的那一刻位置,内部会自动调用
#pragma targetContentOffset : 原本colectionView停止滚动时的那一刻位置
#pragma velocity : 滚动的速率,根据正负可以判断滚动方向是向左还是向右

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    //1.计算colectionView最终停留的位置
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有item的属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    
    //3.计算最终屏幕的中心x
    CGFloat centerX = proposedContentOffset.x+ self.collectionView.frame.size.width/2;
    
    
    //4.遍历所有的属性,通过计算item与最终屏幕中心的最小距离,然后将item移动屏幕的中心位置
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attris in array)
    {
        if (ABS(attris.center.x - centerX) < ABS(adjustOffsetX)) {
            
            adjustOffsetX = attris.center.x - centerX;
        }
    }
 
    //5.返回要移动到中心的item的位置
    return CGPointMake(proposedContentOffset.x + adjustOffsetX , proposedContentOffset.y);
}

//返回需要重新布局的所有item属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //0.计算可见的矩形框属性
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    
    //1.取出默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    
    //计算屏幕最中心的x(滚出去的所有的item的偏移 + collectionView宽度的一半)
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    
    
    //2.遍历所有的布局属性
    for(UICollectionViewLayoutAttributes *attrs in array)
    {
        //如果遍历的item和可见的矩形框的frame不相交,即不e是可见的,就直接跳过,只对可见的item进行放缩
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        //每一个item的中心x
        CGFloat itemCenterX =  attrs.center.x;
        
        
        //差距越大，缩放比例越小
        //计算每一个item的中心x和屏幕最中心x的绝对值距离，然后可以计算出缩放比例,即
        
        // <1>计算间距/屏幕一半时的比例,得出的数一定<1
        //CGFloat ratio = ABS(itemCenterX - centerX) / (self.collectionView.frame.size.width/2);
        //CGFloat ratio = ABS(itemCenterX - centerX) / 150;
        // <2>实现放大
        //CGFloat scale = 1 +  (1 - ratio);
        //attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
        //attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        
        //当item的中心x距离屏幕的中心x距离在有效距离150以内时,item才开始放大
        if (ABS(itemCenterX - centerX) <= activeDistance)
        {
            //CGFloat ratio = ABS(itemCenterX - centerX) / (self.collectionView.frame.size.width/2);
            CGFloat ratio = ABS(itemCenterX - centerX) / activeDistance;
            
            // <2>实现放大
            CGFloat scale = 1 +  scaleFactor*(1 - ratio);
            attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
            //attrs.transform = CGAffineTransformMakeScale(scale, scale);
        }
        else
        {
            attrs.transform = CGAffineTransformMakeScale(1, 1);
        }
    }
    return array;
}
@end
