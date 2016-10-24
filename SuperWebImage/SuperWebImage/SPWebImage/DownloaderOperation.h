//
//  DownloaderOperation.h
//  SuperWebImage
//
//  Created by Vitas on 2016/10/23.
//  Copyright © 2016年 Vitas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+path.h"

@interface DownloaderOperation : NSOperation

+ (instancetype)downloadWithURLStr:(NSString *)URLStr successBlock:(void(^)(UIImage *image))successBlock;

@end
