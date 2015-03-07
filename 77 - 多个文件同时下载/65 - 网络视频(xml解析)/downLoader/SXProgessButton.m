//
//  SXProgessButton.m
//  75 - URLSession断点续传
//
//  Created by 董 尚先 on 15-1-19.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXProgessButton.h"

@implementation SXProgessButton

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%.01f%%",self.progress * 100];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    self.lineWidth = 3.0;
    

}

- (void)layoutSubviews
{
    self.titleLabel.frame = CGRectMake(10, 10, 70, 30);
}

- (void)drawRect:(CGRect)rect
{
    CGPoint point = CGPointMake(self.bounds.size.height * 0.5, self.bounds.size.width * 0.5);
    
    CGFloat r = MIN(self.bounds.size.height * 0.5, self.bounds.size.width * 0.5);
    
    r -= 3;
    
    CGFloat start = -M_PI_2;
    CGFloat end = self.progress * 2* M_PI +start;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:r startAngle:start endAngle:end clockwise:YES];
    path.lineWidth = self.lineWidth;
    path.lineCapStyle= kCGLineCapRound;
    
    [[UIColor redColor] setStroke];
    
    [path stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:point radius:r startAngle:end endAngle:start clockwise:YES];
    path.lineWidth = self.lineWidth;
    path.lineCapStyle= kCGLineCapRound;
    
    [[UIColor grayColor] setStroke];
    
    [path2 stroke];
    
}

@end
