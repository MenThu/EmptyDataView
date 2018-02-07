//
//  UITableView+PlaceHoldView.m
//  TablePlaceHoldView
//
//  Created by MenThu on 2018/2/5.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "UITableView+PlaceHoldView.h"
#import <objc/runtime.h>

@implementation UITableView (PlaceHoldView)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL reloadSelector = @selector(reloadData);
        SEL swizzledreloadSelector = @selector(mtReloadData);

        Method originalMethod = class_getInstanceMethod(class, reloadSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledreloadSelector);

        BOOL success = class_addMethod(class, reloadSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledreloadSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        SEL layoutSelector = @selector(layoutSubviews);
        SEL swizzledlayoutSelector = @selector(mtlayoutSubviews);
        
        Method originalLayoutMethod = class_getInstanceMethod(class, layoutSelector);
        Method swizzledLayoutMethod = class_getInstanceMethod(class, swizzledlayoutSelector);
        
        success = class_addMethod(class, layoutSelector, method_getImplementation(swizzledLayoutMethod), method_getTypeEncoding(swizzledLayoutMethod));
        if (success) {
            class_replaceMethod(class, swizzledlayoutSelector, method_getImplementation(originalLayoutMethod), method_getTypeEncoding(originalLayoutMethod));
        } else {
            method_exchangeImplementations(originalLayoutMethod, swizzledLayoutMethod);
        }
        
    });
}

- (void)mtReloadData{
    [self mtReloadData];
    [self getDataCount];
}

- (void)mtlayoutSubviews{
    [self mtlayoutSubviews];
    [self getDataCount];
}

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

- (NSInteger)totalDataCount{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

- (void)setPlaceHoldView:(PlaceHoldView *)placeHoldView{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[placeHoldView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    [self addSubview:placeHoldView];
    objc_setAssociatedObject(self, @selector(placeHoldView), placeHoldView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PlaceHoldView *)placeHoldView{
    return objc_getAssociatedObject(self, _cmd);
}

@end
