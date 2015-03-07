//
//  SXDownloader.m
//  76 - 自写下载管理器
//
//  Created by 董 尚先 on 15-1-20.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXDownloader.h"

@interface SXDownloader ()<NSURLConnectionDataDelegate>

@property (nonatomic,assign) long long  expectedContentLength;
@property (nonatomic,assign) long long  currentLength;
@property(nonatomic,copy) NSString *filePath;
@property(nonatomic,strong) NSURL *downLoadUrl;
@property(nonatomic,strong) NSURLConnection *downLoadURLConnection;
@property (nonatomic,assign) CFRunLoopRef downLoadRunLoop;
@property(nonatomic,strong) NSOutputStream *fileStrem;

@property(nonatomic,copy) void (^progress)(float);
@property(nonatomic,copy) void (^completion)(NSString *);
@property(nonatomic,copy) void (^failed)(NSString *);

@end


@implementation SXDownloader

- (void)pause
{
    [self.downLoadURLConnection cancel];
}

- (void)downLoadWithURL:(NSURL *)url progress:(void (^)(float))progress completion:(void (^)(NSString *))completion failed:(void (^)(NSString *))failed
{
    self.downLoadUrl = url;
    self.progress = progress;
    self.completion = completion;
    self.failed = failed;
    
    [self checkServerFileInfo:url];
    NSLog(@"大小是%lld",self.expectedContentLength);
    
    if (![self checkLocalFile]) {
        if (self.failed) {
            self.failed(@"下载过了啊");
        }
        return;
    }
    
    NSLog(@"需要从 %lld 开始下载",self.currentLength);
    [self downLoadFile];
   
}

#pragma mark - /************************* 下载文件 ***************************/
- (void)downLoadFile
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.downLoadUrl cachePolicy:1 timeoutInterval:3.0f];
        
        NSString *rangStr = [NSString stringWithFormat:@"bytes=%lld-",self.currentLength];
        
        [request setValue:rangStr forHTTPHeaderField:@"Range"];
        
        self.downLoadURLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [self.downLoadURLConnection start];
        
        self.downLoadRunLoop = CFRunLoopGetCurrent();
        
        CFRunLoopRun();
    });
    
}

#pragma mark - /************************* NSURLConnection代理方法 ***************************/
#pragma mark 接受到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fileStrem = [[NSOutputStream alloc]initToFileAtPath:self.filePath append:YES];
    NSLog(@"temp --- %@",self.filePath);
    [self.fileStrem open];
    
}
#pragma mark 接受到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.fileStrem write:data.bytes maxLength:data.length];
    self.currentLength += data.length;
    
    float progress = (float)self.currentLength/self.expectedContentLength;
    
//    NSLog(@"=====>%.4f",progress);
    if (self.progress) {
        self.progress(progress);
    }
    
}
#pragma mark 结束下载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.fileStrem close];
    CFRunLoopStop(self.downLoadRunLoop);
    
    if (self.completion) {
       dispatch_async(dispatch_get_main_queue(), ^{
           self.completion(self.filePath);
       }) ;
    }
    
}
#pragma mark 遇到错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.fileStrem close];
    CFRunLoopStop(self.downLoadRunLoop);
    
    if (self.failed) {
        self.failed([NSString stringWithFormat:@"%@",error.localizedDescription]);
    }
}


#pragma mark - /************************* 检测服务器文件信息 ***************************/
- (void)checkServerFileInfo:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:20.0f]; // $$$$$
    
    request.HTTPMethod = @"HEAD";
    
    NSURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
//    NSLog(@"%@",response);
     self.expectedContentLength = response.expectedContentLength;
    
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
    
    return;
}

#pragma mark - /************************* 检查本地是否存在文件 ***************************/
- (BOOL)checkLocalFile
{
    long long fileSize = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        
        NSDictionary *attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:self.filePath error:NULL];
//        fileSize = [attributes[NSFileSize] longLongValue];
        fileSize = [attributes fileSize];
    }
    
    if (fileSize > self.expectedContentLength) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:NULL];
        fileSize = 0;
    }
    
    if (fileSize == self.expectedContentLength) {
        NSLog(@"文件已经存在");
        return NO ;
    }
    
    self.currentLength = fileSize;
    return YES;
    
}

@end
