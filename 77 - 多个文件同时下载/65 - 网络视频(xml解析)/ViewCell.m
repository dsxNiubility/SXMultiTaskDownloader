//
//  ViewCell.m
//  65 - 网络视频(xml解析)
//
//  Created by 董 尚先 on 15-1-14.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "ViewCell.h"
#import "UIImageView+WebCache.h"
#import "SXProgessButton.h"

@interface ViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *teacherLable;

@property (weak, nonatomic) IBOutlet SXProgessButton *btnDownloadView;


@end
@implementation ViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideo:(Video *)video
{
    _video = video;
    
    self.nameLable.text = video.name;
    self.teacherLable.text = video.teacher;
    self.timeLable.text = video.time;
    self.btnDownloadView.progress = video.progress;
    
//    NSLog(@"%@",video.fullImageURL);
    [self.img sd_setImageWithURL:video.fullImageURL placeholderImage:[UIImage imageNamed:@"user_default"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

@end
