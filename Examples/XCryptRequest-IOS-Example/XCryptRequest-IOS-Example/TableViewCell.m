//
//  TableViewCell.m
//  XCryptRequest-IOS-Example
//
//  Created by wjg on 16/11/2017.
//  Copyright © 2017 wujungao. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progressView.progress=0.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
