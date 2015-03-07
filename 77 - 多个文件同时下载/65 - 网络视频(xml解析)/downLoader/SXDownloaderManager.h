//
//  SXDownloaderManager.h
//  76 - 自写下载管理器
//
//  Created by 董 尚先 on 15-1-20.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXDownloaderManager : NSObject

+ (instancetype)sharedDownloaderManager;

- (void)downLoadWithURL:(NSURL *)url progress:(void (^)(float progress))progress completion:(void (^)(NSString *filePath))completion failed:(void(^)(NSString *failed))failed;// $$$$$

- (void)pauseWithURL:(NSURL *)url;

@end
