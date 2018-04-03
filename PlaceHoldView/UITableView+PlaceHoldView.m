//
//  UITableView+PlaceHoldView.m
//  TablePlaceHoldView
//
//  Created by MenThu on 2018/2/5.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "UITableView+PlaceHoldView.h"
#import <objc/runtime.h>

@implementation NSObject (PlaceHoldView)

/** 替换方法 */
+ (void)exchangeMethod:(SEL)oldMethod withMethod:(SEL)newMethod {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, oldMethod);
    Method swizzledMethod = class_getInstanceMethod(class, newMethod);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end

@implementation UITableView (PlaceHoldView)

/** 替换方法入口 */
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //替换reloadData方法
        [self exchangeMethod:@selector(reloadData) withMethod:@selector(mtReloadData)];
        
        //row
        [self exchangeMethod:@selector(deleteRowsAtIndexPaths:withRowAnimation:) withMethod:@selector(mtDeleteRowsAtIndexPaths:withRowAnimation:)];
        [self exchangeMethod:@selector(insertRowsAtIndexPaths:withRowAnimation:) withMethod:@selector(mtInsertRowsAtIndexPaths:withRowAnimation:)];
    });
}

/** 新reloadData方法 */
- (void)mtReloadData{
    [self mtReloadData];
    [self getDataCount];
}

- (void)mtDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self mtDeleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataCount];
}

- (void)mtInsertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self mtInsertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataCount];
}

/** 查看tableView的一些信息 */
- (void)getDataCount{
    if (self.placeHoldView == nil) {
        return;
    }else if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)){
        return;
    }
    if ([self totalDataCount] > 0) {
        self.placeHoldView.hidden = YES;
    }else{
        [self.placeHoldView setNeedsLayout];
        [self.placeHoldView layoutIfNeeded];
        [self bringSubviewToFront:self.placeHoldView];
        self.placeHoldView.hidden = NO;
    }
}

/** 查看tableView中是否由数据 */
- (NSInteger)totalDataCount{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            NSInteger rowsInSection = [tableView numberOfRowsInSection:section];
            totalCount += rowsInSection;
        }
    }
    return totalCount;
}

#pragma mark - Getter
- (PlaceHoldView *)placeHoldView{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - Setter
- (void)setPlaceHoldView:(PlaceHoldView *)placeHoldView{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[placeHoldView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    placeHoldView.hidden = YES;
    [self addSubview:placeHoldView];
    objc_setAssociatedObject(self, @selector(placeHoldView), placeHoldView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
