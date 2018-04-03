//
//  ViewController.m
//  EmptyDataView
//
//  Created by MenThu on 2018/4/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+PlaceHoldView.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *> *tableSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableSource = @[].mutableCopy;
//    for (NSInteger index = 0; index < 10; index ++) {
//        [self.tableSource addObject:[NSString stringWithFormat:@"第[%ld]个cell", (long)(index +1)]];
//    }
    CGFloat contentInsetTop = 0;
    __weak typeof(self) weakSelf = self;
    self.tableView.placeHoldView = [PlaceHoldView placeHoldWithImg:nil placeHold:@"一个很长很长的测试一个很长很长的测试一个很长很长的测试一个很长很长的测试一个很长很长的测试一个很长很长的测试一个很长很长的测试一个很长很长的测试一个很长很长的测试" placeHoldOffset:CGPointMake(0, -contentInsetTop) tapView:^{
        NSMutableArray <NSString *> *tempArray = @[].mutableCopy;
        for (NSInteger index = 0; index < 10; index ++) {
            [tempArray addObject:[NSString stringWithFormat:@"第[%ld]个cell", (long)(index +1)]];
        }
        weakSelf.tableSource = tempArray;
        [weakSelf.tableView reloadData];
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)deleteOrInsert:(UIButton *)sender {
    if (sender.tag == 1) {//删除
        if (self.tableSource.count > 0) {
            [self.tableSource removeLastObject];
            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:self.tableSource.count inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else{
        NSInteger count = self.tableSource.count;
        [self.tableSource addObject:[NSString stringWithFormat:@"第[%ld]个cell", (long)(count+1)]];
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:count inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.tableSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数据源的数据,self.cellData是你自己的数据
        [self.tableSource removeObjectAtIndex:indexPath.row];
        // 删除列表中数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


@end
