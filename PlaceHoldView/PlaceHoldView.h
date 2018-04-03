//
//  PlaceHoldView.h
//  TablePlaceHoldView
//
//  Created by MenThu on 2018/2/5.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MTTapTableEmptyView)(void);

@interface PlaceHoldView : UIView

/**
 *  imgName 占位图
 *  placeHoldText 提示文字
 *  offset 提示图的偏移量
 *  点击占位图的回调
 */
+ (instancetype)placeHoldWithImg:(NSString *)imgName
                       placeHold:(NSString *)placeHoldText
                 placeHoldOffset:(CGPoint)placeHoldOffset
                         tapView:(MTTapTableEmptyView)tapBlock;

@end
