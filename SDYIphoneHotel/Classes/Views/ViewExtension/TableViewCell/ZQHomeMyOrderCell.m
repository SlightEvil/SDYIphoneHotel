//
//  ZQHomeMyOrderCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQHomeMyOrderCell.h"

@implementation ZQHomeMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapCommit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectIndex:)];
    UITapGestureRecognizer *tapReceive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectIndex:)];
    UITapGestureRecognizer *tapComplete = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectIndex:)];
    UITapGestureRecognizer *tapAllOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectIndex:)];
    
    self.commitImageView.userInteractionEnabled = YES;
    self.receiveImageView.userInteractionEnabled = YES;
    self.completeImageView.userInteractionEnabled = YES;
    self.allOrderImageView.userInteractionEnabled = YES;
    
    [self.commitImageView addGestureRecognizer:tapCommit];
    [self.receiveImageView addGestureRecognizer:tapReceive];
    [self.completeImageView addGestureRecognizer:tapComplete];
    [self.allOrderImageView addGestureRecognizer:tapAllOrder];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)cellSelectIndex:(UITapGestureRecognizer *)recognizer
{
    /* 获取点击view的tag  在xib 设置过了 分别为 1，2，3，4 */
    NSInteger index = [recognizer view].tag;
    
    if (self.CellSelectIndex) {
        self.CellSelectIndex(index);
    }
}


@end
