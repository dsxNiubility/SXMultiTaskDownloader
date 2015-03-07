#import "Video.h"

@implementation Video

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)videoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

#define kBaseURL   @"http://localhost/"
- (NSURL *)fullImageURL {
    if (_fullImageURL == nil) {
//        NSString *urlString = [kBaseURL stringByAppendingPathComponent:self.imageURL];
        NSString *urlstring = self.imageURL;
        
        _fullImageURL = [NSURL URLWithString:urlstring];
    }
    return _fullImageURL;
}

- (NSURL *)fullVideoURL
{
    if (_fullVideoURL == nil) {
//        NSString *urlstring = [kBaseURL stringByAppendingPathComponent:self.videoURL];
        NSString *urlstring = self.videoURL;
        urlstring =[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        _fullVideoURL = [NSURL URLWithString:urlstring];
    }
    return _fullVideoURL;
}

- (NSString *)time {
    int len = self.length.intValue;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", len / 3600, (len % 3600) / 60, (len % 60)];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> { videoId : %@, name : %@ %p, length : %@ %p, videoURL : %@ %p, imageURL : %@, desc : %@, teacher : %@}", [self class], self, self.videoId, self.name, self.name, self.length, self.length, self.videoURL, self.videoURL, self.imageURL, self.desc, self.teacher];
}

@end
