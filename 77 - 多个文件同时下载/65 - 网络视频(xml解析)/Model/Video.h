#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Video : NSObject

// strong 在设置数值时只是引用计数＋1
// copy 属性，在设置数值的时候，会做一个copy操作
// 提示：为了避免不必要的麻烦，网络模型在设置属性时，可以都使用 copy
@property (nonatomic, copy) NSNumber *videoId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *length;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *teacher;

@property (nonatomic, readonly) NSString *time;

@property(nonatomic,strong) NSURL *fullVideoURL;

@property (nonatomic,assign) CGFloat progress;


/**
 完成的图像路径
 */
@property (nonatomic, strong) NSURL *fullImageURL;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end
