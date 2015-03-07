//
//  ViewController.m
//  65 - 网络视频(xml解析)
//
//  Created by 董 尚先 on 15-1-14.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "ViewController.h"
#import "Video.h"
#import "ViewCell.h"
#import "SXDownloaderManager.h"

@interface ViewController ()<NSXMLParserDelegate>

@property(nonatomic,strong) NSArray *arrayList;

@property(nonatomic,strong) NSMutableArray *videos;
@property(nonatomic,strong) Video *currentVideo;
@property(nonatomic,strong) NSMutableString *temMString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSLog(@"%@",path);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (NSArray *)arrayList
//{
//    if (_arrayList == nil) {
//        _arrayList = [[NSArray alloc]init];
//    }
//    return _arrayList;
//}
#pragma mark - /************************* 在set完毕后刷新表格结束菊花 ***************************/
- (void)setArrayList:(NSArray *)arrayList
{
    _arrayList = arrayList;
    
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
    
}

#pragma mark - /************************* 两个懒加载 ***************************/
- (NSMutableArray *)videos
{
    if (_videos == nil) {
        _videos = [[NSMutableArray alloc]init];
    }
    return _videos;
}

- (NSMutableString *)temMString
{
    if (_temMString == nil) {
        _temMString = [[NSMutableString alloc]init];
    }
    return _temMString;
}

#pragma mark - /************************* TabView数据源方法 ***************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Video *video = self.arrayList[indexPath.row];
    
    cell.video = video;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - /************************* 代理方法点击每行 ***************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *vv = self.videos[indexPath.row];
    
    [[SXDownloaderManager sharedDownloaderManager]downLoadWithURL:vv.fullVideoURL progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            vv.progress = progress;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    } completion:^(NSString *filePath) {
        vv.progress = 1.0;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failed:nil];
}

#pragma mark - /************************* 下载数据 ***************************/
- (IBAction)loadData{
    NSURL *url = [NSURL URLWithString:@"http://localhost/vvv.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:3.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data]; // $$$$$
        
        parser.delegate = self;
        [parser parse];
    }];
}

#pragma mark - /************************* NSXMLPaeser的代理方法 ***************************/

#pragma mark ****开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
//    NSLog(@"开始搞");
    [self.videos removeAllObjects];
}

#pragma mark ****遇到开始符号
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict // 虽然是在主队列主线程运行的，但是是异步的 不会卡着
{
//    NSLog(@"开始 ---%@ %@",elementName,attributeDict);
    if ([elementName isEqualToString:@"video"]) {
        self.currentVideo = [[Video alloc]init];
        
        self.currentVideo.videoId = @([attributeDict[@"videoId"] intValue]); // $$$$$
    }
    [self.temMString setString:@""];
}

#pragma mark ****解析干货字符串
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"%@",string);
    [self.temMString appendString:string];
}

#pragma mark ****遇到结束符号
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"结束 ---%@",elementName);
    if ([elementName isEqualToString:@"video"]) {
        [self.videos addObject:self.currentVideo];
    }else if (![elementName isEqualToString:@"videos"]){
        [self.currentVideo setValue:self.temMString forKey:elementName];
    }
}

#pragma mark ****文档解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    NSLog(@"全部搞结束");
//    NSLog(@"%@",[NSThread currentThread]);
//    NSLog(@"%@",self.videos);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.arrayList = self.videos;
    });
}

#pragma mark ****遇到错误怎么办？
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"发生了错误 %@",parseError);
}


@end
