//
//  ZQHomeMyOrderCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQHomeMyOrderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *commitImageView;

@property (weak, nonatomic) IBOutlet UIImageView *receiveImageView;

@property (weak, nonatomic) IBOutlet UIImageView *completeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *allOrderImageView;

/** cell 选择imageView with tag(可当index) */
@property (nonatomic, copy) void(^CellSelectIndex)(NSUInteger index);



@end
