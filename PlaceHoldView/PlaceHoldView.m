//
//  PlaceHoldView.m
//  TablePlaceHoldView
//
//  Created by MenThu on 2018/2/5.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PlaceHoldView.h"
#import "NSString+Exten.h"
#import "UIColor+HexString.h"

static CGFloat const PlaceImageViewBottom2LabelTop = 10.f;

@interface PlaceHoldView ()

@property (nonatomic, weak) UIImageView *placeHoldImagView;
@property (nonatomic, weak) UILabel *placeHoldLabel;
@property (nonatomic, copy) MTTapTableEmptyView tapEmpeyBlock;
@property (nonatomic, assign) CGPoint placeHoldOffset;


@end

@implementation PlaceHoldView
#pragma mark - LifeCircle
+ (instancetype)placeHoldWithImg:(NSString *)imgName
                       placeHold:(NSString *)placeHoldText
                 placeHoldOffset:(CGPoint)placeHoldOffset
                         tapView:(MTTapTableEmptyView)tapBlock{
    PlaceHoldView *placeHoldView = [[PlaceHoldView alloc] init];
    if ([imgName isExist]) {
        placeHoldView.placeHoldImagView.image = [UIImage imageNamed:imgName];
    }
    if ([placeHoldText isExist]) {
        placeHoldView.placeHoldLabel.text = placeHoldText;
    }
    placeHoldView.placeHoldOffset = placeHoldOffset;
    if (tapBlock) {
        placeHoldView.tapEmpeyBlock = tapBlock;
    }
    return placeHoldView;
}

- (instancetype)init{
    if (self = [super init]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self changeSubviewsFrame];
}

#pragma mark - Private
- (void)tapView:(UITapGestureRecognizer *)gesture{
    if (self.tapEmpeyBlock) {
        self.hidden = YES;
        self.tapEmpeyBlock();
    }
}

- (void)changeSubviewsFrame{
    if (CGRectEqualToRect(self.superview.bounds, CGRectZero)) {
        return;
    }
    CGFloat superViewWidth = self.superview.bounds.size.width;
    CGFloat superViewHeight = self.superview.bounds.size.height;
    
    
    CGFloat placeImgScale = 0;
    CGFloat placeHoldImageWidth = superViewWidth/2;
    CGFloat placeHoldImageHeight = 0;
    if (_placeHoldImagView) {
        placeImgScale = _placeHoldImagView.image.size.width / _placeHoldImagView.image.size.height;
        placeHoldImageHeight = placeHoldImageWidth/placeImgScale;
    }
    
    CGSize labelSize = CGSizeZero;
    if (_placeHoldLabel) {
        CGSize labelMaxSize = CGSizeMake(placeHoldImageWidth, MAXFLOAT);
        labelSize = [_placeHoldLabel sizeThatFits:labelMaxSize];
    }
    
    CGFloat placeHoldViewWidth = placeHoldImageWidth;
    CGFloat placeHoldViewHeight = placeHoldImageHeight + PlaceImageViewBottom2LabelTop + labelSize.height;
    if (_placeHoldLabel == nil || _placeHoldImagView == nil) {
        placeHoldViewHeight -= PlaceImageViewBottom2LabelTop;
    }
    
    /**
     *  确定自身的Frame
     *  默认的，是将placeHoldView放在tableView可见范围的正中间
     *  但是考虑到contentInset.top的问题，这里需要调整
     **/
    CGFloat placeHoldX = (superViewWidth-placeHoldViewWidth)/2 + self.placeHoldOffset.x;
    CGFloat placeHoldY = (superViewHeight-placeHoldViewHeight)/2 + self.placeHoldOffset.y;
//    CGFloat contentInsetTop = superView.contentInset.top;//+PlaceHoldViewTop2ContentInsetTop
//    if (contentInsetTop > 0) {
//        placeHoldY = MAX(placeHoldY - contentInsetTop, PlaceHoldViewTop2ContentInsetTop);
//    }else if (contentInsetTop < 0){
//        placeHoldY -= contentInsetTop;
//    }
    self.frame = CGRectMake(placeHoldX, placeHoldY, placeHoldViewWidth, placeHoldViewHeight);
    
    /**
     *  确定placeHoldImagView与placeHoldLabel的frame
     */
    CGFloat x = 0;
    CGFloat y = 0;
    if (_placeHoldImagView) {
        x = 0;
        y = 0;
        _placeHoldImagView.frame = CGRectMake(x, y, placeHoldImageWidth, placeHoldImageHeight);
        y = placeHoldImageHeight + PlaceImageViewBottom2LabelTop;
    }
    if (_placeHoldLabel) {
        x = (placeHoldViewWidth - labelSize.width)/2;
        _placeHoldLabel.frame = CGRectMake(x, y, labelSize.width, labelSize.height);
    }
}

#pragma mark - Getter
- (UIImageView *)placeHoldImagView{
    if (_placeHoldImagView == nil) {
        UIImageView *placeHoldImagView = [[UIImageView alloc] init];
        placeHoldImagView.backgroundColor = [UIColor cyanColor];
        placeHoldImagView.clipsToBounds = YES;
        placeHoldImagView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:(_placeHoldImagView = placeHoldImagView)];
    }
    return _placeHoldImagView;
}

- (UILabel *)placeHoldLabel{
    if (_placeHoldLabel == nil) {
        UILabel *placeHoldLabel = [UILabel new];
        placeHoldLabel.backgroundColor = [UIColor orangeColor];
        placeHoldLabel.textColor = [UIColor colorWithHexString:@"999999"];
        placeHoldLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        placeHoldLabel.numberOfLines = 0;
        placeHoldLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:(_placeHoldLabel = placeHoldLabel)];
    }
    return _placeHoldLabel;
}

@end
