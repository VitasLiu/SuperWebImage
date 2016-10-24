//
//  DownloaderOperationManager.m
//  SuperWebImage
//
//  Created by Vitas on 2016/10/23.
//  Copyright © 2016年 Vitas. All rights reserved.
//

#import "DownloaderOperationManager.h"
#import "DownloaderOperation.h"

@interface DownloaderOperationManager ()

/* 队列 */
@property (strong, nonatomic) NSOperationQueue *queue;

/* 操作缓存池 */
@property (strong, nonatomic) NSMutableDictionary *OPCache;

/* 图片缓存池 */
@property (strong, nonatomic) NSMutableDictionary *imagesCache;

@end

@implementation DownloaderOperationManager

+ (instancetype)sharedManager
{
    static id instance;
    
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if(self == [super init])
    {
        self.queue = [[NSOperationQueue alloc] init];
        self.OPCache = [[NSMutableDictionary alloc] init];
        self.imagesCache = [[NSMutableDictionary alloc] init];
        
         // 当第一次使用单例时,就注册内存警告的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMemCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    
    return self;
}

// 处理内存警告
- (void)cleanMemCache
{
    [self.imagesCache removeAllObjects];
    [self.OPCache removeAllObjects];
    [self.queue cancelAllOperations];
}

// 单例的生命周期和APP一样长,只有APP退出了.dealloc才执行;所以,单例里面注册通知没有必要移除
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 单例下载的主方法 : 单例封装DownloaderOperation的下载代码
- (void)downloadWithURLStr:(NSString *)URLStr successBlock:(void (^)(UIImage *))successBlock
{
    // 下载图片之前, 先判断是否有缓存
    if([self checkCachesWithURLStr:URLStr])
    {
        if(successBlock)
        {
            UIImage *memImage = [self.imagesCache objectForKey:URLStr];
            successBlock(memImage);
            return;
        }
    }
    
    // 判断要建立的下载操作是否存在,如果存在,就不再建立新的下载操作
    if([self.OPCache objectForKey:URLStr])
    {
        return;
    }
    
    // 单例定义代码块,传递给自定义操作
    void (^managerBlock)() = ^(UIImage *image){
        
        // 实现内存缓存
        if(image != nil)
        {
            [self.imagesCache setObject:image forKey:URLStr];
        }
        
        if(successBlock != nil)
        {
            successBlock(image);
        }

        // 图片下载完成之后,移除操作
        [self.OPCache removeObjectForKey:URLStr];
    };
    
    
    // 创建自定义操作
    DownloaderOperation *op = [DownloaderOperation downloadWithURLStr:URLStr successBlock: managerBlock];
    
    // 把创建的操作添加到操作缓存池
    [self.OPCache setObject:op forKey:URLStr];
    
    // 把自定义操作添加到队列
    [self.queue addOperation:op];
}


// 单例取消操作的主方法
- (void)cancelDownloadingOperationWithLastURLStr:(NSString *)lastURLStr
{
    // 取消上次正在执行的操作
    [[self.OPCache objectForKey:lastURLStr] cancel];
    
    // 把取消的操作从操作缓存池移除
    [self.OPCache removeObjectForKey:lastURLStr];
}

// 检查是否有缓存
- (BOOL)checkCachesWithURLStr:(NSString *)URLStr
{
    // 图片下载之前,先判断是否有内存缓存
    if([self.imagesCache objectForKey:URLStr])
    {
        NSLog(@"从内存中加载...");
        return YES;
    }
    
    // 图片下载之前,先判断是否有沙盒缓存
    UIImage *cacheImage = [UIImage imageWithContentsOfFile:[URLStr appendCaches]];
    if(cacheImage)
    {
        NSLog(@"从沙盒中加载...");
        // 需要在内存中保存一份
        [self.imagesCache setObject:cacheImage forKey:URLStr];
        return YES;
    }
    
    return NO;
}





@end
