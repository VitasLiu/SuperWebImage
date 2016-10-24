//
//  DownloaderOperation.m
//  SuperWebImage
//
//  Created by Vitas on 2016/10/23.
//  Copyright © 2016年 Vitas. All rights reserved.
//

#import "DownloaderOperation.h"

@interface DownloaderOperation ()

/* 图片地址 */
@property (copy, nonatomic) NSString *URLStr;

/* 代码块 */
@property (copy, nonatomic) void (^successBlock)(UIImage *image);

@end

@implementation DownloaderOperation

+ (instancetype)downloadWithURLStr:(NSString *)URLStr successBlock:(void (^)(UIImage *))successBlock
{
    DownloaderOperation *op = [[self alloc] init];
    op.URLStr = URLStr;
    op.successBlock = successBlock;
    
    return op;
    
}

- (void)main
{
    [NSThread sleepForTimeInterval:1.0];
    
    // 图片下载
    NSURL *url = [NSURL URLWithString:self.URLStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    // 实现沙盒缓存
    if(image)
    {
        [data writeToFile:[self.URLStr appendCaches] atomically:YES];
    }
    
    // 判断当前的操作是否被取消,如果被取消就直接return,否则往下执行
    if(self.isCancelled == YES)
    {
        NSLog(@"取消 %@",self.URLStr);
        return;
    }
    
    NSAssert(self.successBlock != nil, @"下载完成的回调,不能为空");
    
//    if(self.successBlock != nil)
//    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"完成 %@",self.URLStr);
            self.successBlock(image);
        }];
//    }
}


@end
