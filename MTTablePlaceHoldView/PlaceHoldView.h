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

+ (instancetype)placeHoldWithImg:(NSString *)imgName
                       placeHold:(NSString *)placeHoldText
                         tapView:(MTTapTableEmptyView)tapBlock;

@end
