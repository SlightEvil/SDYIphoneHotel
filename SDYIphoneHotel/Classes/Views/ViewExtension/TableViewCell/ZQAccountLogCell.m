//
//  ZQAccountLogCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQAccountLogCell.h"
#import "ZQAccountLogModel.h"

@implementation ZQAccountLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.logTitleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    self.logTradeNoLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
    self.logCreateLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
    self.logFundLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellFont];
    self.logBalanceLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellFont];
    
    self.logFundLabel.textColor = kZQTabbarTintColor;
    self.logTradeNoLabel.textColor = kZQDetailViewTextColor;
    self.logCreateLabel.textColor = kZQDetailViewTextColor;
}

- (void)setAccountLogModel:(ZQAccountLogModel *)accountLogModel
{
    _accountLogModel = accountLogModel;
    self.logTitleLabel.text = _accountLogModel.log_title;
    self.logTradeNoLabel.text = _accountLogModel.trade_no;
    self.logCreateLabel.text = _accountLogModel.created_at;
    self.logFundLabel.text = _accountLogModel.fund;
    self.logBalanceLabel.text = _accountLogModel.post_balance;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
