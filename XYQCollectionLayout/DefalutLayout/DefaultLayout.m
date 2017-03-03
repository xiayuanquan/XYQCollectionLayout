//
//  DefaultLayout.m
//  CollectionViewLayout
//
//  Created by 夏远全 on 2017/3/3.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "DefaultLayout.h"

@implementation DefaultLayout

//每一次重新布局前,都会准备布局（苹果官方推荐使用该方法进行一些初始化）
-(void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(100, 100);
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
}

@end
