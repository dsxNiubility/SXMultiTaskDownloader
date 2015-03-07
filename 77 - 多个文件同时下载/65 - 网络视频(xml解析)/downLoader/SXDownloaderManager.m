//
//  SXDownloaderManager.m
//  76 - 自写下载管理器
//
//  Created by 董 尚先 on 15-1-20.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXDownloaderManager.h"
#import "SXDownloader.h"

@interface SXDownloaderManager ()

@property(nonatomic,strong) NSMutableDictionary *downLoadCache;

@property(nonatomic,copy) void (^failed)(NSString *failed);


@end

@implementation SXDownloaderManager

+ (instancetype)sharedDownloaderManager
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc]init];
    });
    return obj;
}

- (NSMutableDictionary *)downLoadCache
{
    if (_downLoadCache == nil) {
        _downLoadCache = [[NSMutableDictionary alloc]init];
    }
    return _downLoadCache;
}

- (void)downLoadWithURL:(NSURL *)url progress:(void (^)(float))progress completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed
{
    self.failed = failed;
    
    SXDownloader *download = self.downLoadCache[url.path];
    
    if (download != nil) {
        if (failed) {
            failed(@"已经在下载队列了 请勿重复点击");
        }
        return;
    }
    
    download = [[SXDownloader alloc]init];
    
    [self.downLoadCache setObject:download forKey:url.path];
    
    NSLog(@"下载后往哪放 %@",url.path);
    
    [download downLoadWithURL:url progress:progress completion:^(NSString *filePath) {
        [self.downLoadCache removeObjectForKey:url.path];
        if (completion) {
            completion(filePath);
        }
    } failed:failed];
    
}

- (void)pauseWithURL:(NSURL *)url
{
    SXDownloader *download = self.downLoadCache[url.path];
    
    if (download == nil) {
        if (self.failed) {
            self.failed(@"无效操作");
        }
        return;
    }
    
    [download pause];
    [self.downLoadCache removeObjectForKey:url.path];
}

@end
