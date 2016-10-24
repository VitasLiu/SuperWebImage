//
//  UIImageView+web.h
//  SuperWebImage
//
//  Created by Vitas on 2016/10/24.
//  Copyright © 2016年 Vitas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (web)

/* 上次图片地址 */
@property (copy, nonatomic) NSString *lastURLStr;


/**
 分类实现图片下载,取消,缓存的主方法

 @param URLStr 接收图片下载地址
 */
- (void)Super_setImageWithURLStr:(NSString *)URLStr;

@end
