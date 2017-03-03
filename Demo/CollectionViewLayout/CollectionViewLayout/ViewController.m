//
//  ViewController.m
//  CollectionViewLayout
//
//  Created by 夏远全 on 2017/3/3.
//  Copyright © 2017年 夏远全. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"
#import "DefaultLayout.h"
#import "CustomCircleLayout.h"
#import "CustomLineLayout.h"
#import "CustomStackLayout.h"
#import "WaterFlowLayout.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSArray *titles;
@property (strong,nonatomic)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CollectionView布局";
    self.titles = @[@"默认布局",@"圆式布局",@"线式布局",@"堆叠式布局",@"瀑布流布局"];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuserIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    collectionVC.layout = [self setupLayout:indexPath.row];
    [self.navigationController pushViewController:collectionVC animated:YES];
}


//设置布局
- (UICollectionViewLayout *)setupLayout:(NSInteger)index{
    
    switch (index) {
        case 0:
            return [[DefaultLayout alloc] init];      //默认布局
            break;
        case 1:
            return [[CustomCircleLayout alloc] init]; //圆式布局
            break;
        case 2:
            return [[CustomLineLayout alloc] init];   //线式布局
            break;
        case 3:
            return [[CustomStackLayout alloc] init];  //堆叠式布局
            break;
        case 4:
            return [[WaterFlowLayout alloc] init];    //瀑布流布局
            break;
    }
    return nil;
}


@end
