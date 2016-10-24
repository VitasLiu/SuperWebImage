//
//  DownloaderOperationManager.h
//  SuperWebImage
//
//  Created by Vitas on 2016/10/23.
//  Copyright © 2016年 Vitas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownloaderOperation.h"

@interface DownloaderOperationManager : NSObject


/**
 单例全局访问点

 @return 返回单例对象
 */
+ (instancetype)sharedManager;


/**
 单例下载的方法

 @param URLStr       图片地址
 @param successBlock 下载完成回调
 */
- (void)downloadWithURLStr:(NSString *)URLStr successBlock:(void (^)(UIImage *image))successBlock;

/**
 单例取消上次正在执行的方法
 
 @param lastURLStr 接收上次下载的图片地址
 */
- (void)cancelDownloadingOperationWithLastURLStr:(NSString *)lastURLStr;


@end
