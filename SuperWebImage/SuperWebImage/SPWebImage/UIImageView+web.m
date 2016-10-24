//
//  UIImageView+web.m
//  SuperWebImage
//
//  Created by Vitas on 2016/10/24.
//  Copyright © 2016年 Vitas. All rights reserved.
//

#import "UIImageView+web.h"
#import "DownloaderOperationManager.h"
#import <objc/runtime.h>

@implementation UIImageView (web)

- (void)setLastURLStr:(NSString *)lastURLStr
{
    objc_setAssociatedObject(self, "KEY", lastURLStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lastURLStr
{
    return objc_getAssociatedObject(self, "KEY");
}


- (void)Super_setImageWithURLStr:(NSString *)URLStr
{
    // 判断当前图片地址与上次图片地址是否一样,如果不一样就取消上次正在执行的下载操作
    if(![URLStr isEqualToString:self.lastURLStr] && self.lastURLStr != nil)
    {
        // 单例接管取消操作
        [[DownloaderOperationManager sharedManager] cancelDownloadingOperationWithLastURLStr:self.lastURLStr];
    }
    
    // 记录本次图片地址
    self.lastURLStr = URLStr;
    
    // 单例接管下载
    [[DownloaderOperationManager sharedManager] downloadWithURLStr:URLStr successBlock:^(UIImage *image) {
        self.image = image;
    }];
}



@end
