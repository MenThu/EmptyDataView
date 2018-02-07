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
static CGFloat const PlaceHoldViewTop2ContentInsetTop = 20.f;

@interface PlaceHoldView ()

@property (nonatomic, weak) UIImageView *placeHoldImagView;
@property (nonatomic, weak) UILabel *placeHoldLabel;
@property (nonatomic, copy) MTTapTableEmptyView tapEmpeyBlock;


@end

@implementation PlaceHoldView
#pragma mark - LifeCircle
+ (instancetype)placeHoldWithImg:(NSString *)imgName
                       placeHold:(NSString *)placeHoldText
                         tapView:(MTTapTableEmptyView)tapBlock{
    PlaceHoldView *placeHoldView = [[PlaceHoldView alloc] init];
    if ([imgName isExist]) {
        placeHoldView.placeHoldImagView.image = [UIImage imageNamed:imgName];
    }
    if ([placeHoldText isExist]) {
        placeHoldView.placeHoldLabel.text = placeHoldText;
    }
    placeHoldView.tapEmpeyBlock = tapBlock;
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
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self changeSubviewsFrame];
    }else{
        self.placeHoldImagView.hidden = self.placeHoldLabel.hidden = YES;
        self.tapEmpeyBlock = nil;
    }
}

#pragma mark - Private
- (void)tapView:(UITapGestureRecognizer *)gesture{
    if (self.tapEmpeyBlock) {
        self.tapEmpeyBlock();
    }
}

- (void)changeSubviewsFrame{
    if (CGRectEqualToRect(self.superview.bounds, CGRectZero)) {
        return;
    }
    UIScrollView *superView = (UIScrollView *)self.superview;
    CGFloat superViewWidth = self.superview.bounds.size.width;
    CGFloat superViewHeight = self.superview.bounds.size.height;
    CGFloat contentInsetTop = superView.contentInset.top;//+PlaceHoldViewTop2ContentInsetTop
    
    CGFloat placeImgScale = 0;
    CGFloat placeHoldImageWidth = superViewWidth/2;
    CGFloat placeHoldImageHeight = 0;
    if (self.placeHoldImagView.image != nil) {
        placeImgScale = self.placeHoldImagView.image.size.width / self.placeHoldImagView.image.size.height;
        placeHoldImageHeight = placeHoldImageWidth/placeImgScale;
        self.placeHoldImagView.hidden = NO;
    }else{
        self.placeHoldImagView.hidden = YES;
    }
    
    CGSize labelSize = CGSizeZero;
    if ([self.placeHoldLabel.text isExist]) {
        CGSize labelMaxSize = CGSizeMake(placeHoldImageWidth, MAXFLOAT);
        labelSize = [self.placeHoldLabel sizeThatFits:labelMaxSize];
        self.placeHoldLabel.hidden = NO;
    }else{
        self.placeHoldLabel.hidden = YES;
    }
    
    
    CGFloat placeHoldViewWidth = MAX(labelSize.width, placeHoldImageWidth);
    CGFloat placeHoldViewHeight = placeHoldImageHeight + PlaceImageViewBottom2LabelTop + labelSize.height;
    if (self.placeHoldLabel.hidden || self.placeHoldImagView.hidden) {
        placeHoldViewHeight -= PlaceImageViewBottom2LabelTop;
    }
    
    /**
     *  确定自身的Frame
     *  默认的，是将placeHoldView放在tableView可见范围的正中间
     *  但是考虑到contentInset.top的问题，这里需要调整
     **/
    CGFloat placeHoldX = (superViewWidth-placeHoldViewWidth)/2;
    CGFloat placeHoldY = (superViewHeight-placeHoldViewHeight)/2;
    if (contentInsetTop > 0) {
        placeHoldY = MAX(placeHoldY - contentInsetTop, PlaceHoldViewTop2ContentInsetTop);
    }else if (contentInsetTop < 0){
        placeHoldY -= contentInsetTop;
    }
    self.frame = CGRectMake(placeHoldX, placeHoldY, placeHoldViewWidth, placeHoldViewHeight);
    
    //确定placeHoldImagView与placeHoldLabel的frame
    CGFloat x = 0;
    CGFloat y = 0;
    if (self.placeHoldImagView.hidden == NO) {
        x = (placeHoldViewWidth - placeHoldImageWidth)/2;
        y = 0;
        self.placeHoldImagView.frame = CGRectMake(x, y, placeHoldImageWidth, placeHoldImageHeight);
        y = CGRectGetMaxY(self.placeHoldImagView.frame) + PlaceImageViewBottom2LabelTop;
    }else{
        y = 0;
    }
    if (self.placeHoldLabel.hidden == NO) {
        x = (placeHoldViewWidth - labelSize.width)/2;
        self.placeHoldLabel.frame = CGRectMake(x, y, labelSize.width, labelSize.height);
    }
}

#pragma mark - Getter
- (UIImageView *)placeHoldImagView{
    if (_placeHoldImagView == nil) {
        UIImageView *placeHoldImagView = [[UIImageView alloc] init];
        placeHoldImagView.clipsToBounds = YES;
        placeHoldImagView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:(_placeHoldImagView = placeHoldImagView)];
    }
    return _placeHoldImagView;
}

- (UILabel *)placeHoldLabel{
    if (_placeHoldLabel == nil) {
        UILabel *placeHoldLabel = [UILabel new];
        placeHoldLabel.textColor = [UIColor colorWithHexString:@"999999"];
        placeHoldLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        placeHoldLabel.numberOfLines = 0;
        [self addSubview:(_placeHoldLabel = placeHoldLabel)];
    }
    return _placeHoldLabel;
}

@end
