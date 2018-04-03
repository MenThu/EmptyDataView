//
//  NSString+Exten.h
//  Bubbling
//
//  Created by 张艺龙 on 2017/11/8.
//  Copyright © 2017年 张艺龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Exten)
/**
 远程视频url
 */
@property (strong, nonatomic) NSString *videoUrl;
/** 根据指定宽度. 字体计算文本尺寸 */
- (CGSize)adapterSizeWithMaxWidth:(CGFloat)width WithFont:(UIFont *)font;
/** 根据指定宽度. 字体计算自定义行间距的文本尺寸 */
- (CGSize)adapterSizeWithMaxWidth:(CGFloat)width WithFont:(UIFont *)font WithLineSpacing:(CGFloat)lineSpacing;
/** 判断是否为纯数字 */
- (BOOL)validateNumber;
/** 对字符串进行md5加密 */
- (NSString *)md5String;
/** 对字符串md5加盐 */
- (NSString *)md5Salt;
/** HAS256加密 */
- (NSString *)SHA256;
/** 对字符串进行编码 */
- (NSString*)encodeString;
- (NSString *)decodeString;
/** 判断是不是手机号码 */
- (BOOL)isPhoneNumer;
/** 判断是不是合法的用户名，支持数字、汉字、字母,不支 持特殊符号和 emoji 表情 */
- (BOOL)isLegitimateNickName;
/** 判断是不是合法的密码，支持数字、英文输入,英文字母支持大小写，支持特殊字符 */
- (BOOL)isLegitimatePassword;
/** 判断是不是合法的URL */
- (BOOL)isLegitimateURL;
/** 判断是不是合法的Email */
- (BOOL)isLegitimateEmail;
/** 获取字符串中汉字的个数 */
- (NSUInteger)getChineseNumCount;
/** NSString转NSDate */
- (NSDate *)toDateWithFormat:(NSString *)format;
/** 检查是否是有效字符串 */
- (BOOL)isExist;


/**
 生成uuid
 @param str 追加字符串
 */
+ (instancetype)generateUUIDStringByAppendingStr:(NSString *)str;

/** 获取urlStr的参数部分 */
- (NSDictionary *)getParameters;
/** 获取首字母 */
- (char)mtkFirstLetterChar;

/**
 按照中文两个字符，英文数字一个字符计算字符数
 */
- (NSUInteger)unicodeLengthOfString;

/**
 转换成最大长度字符的字符串

 @param count 最大字符数
 @return 转换之后的值
 */
- (instancetype)mp_coverToMaxCount:(NSInteger)count;


- (BOOL)canAddString:(NSString *)string withRange:(NSRange)range maxCount:(NSUInteger)count;
@end
