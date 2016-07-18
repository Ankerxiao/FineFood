//
//  TwoCollectionCell.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/18.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "TwoCollectionCell.h"
#import <UIImageView+WebCache.h>

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface TwoCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *priceAndLikeL;

@end

@implementation TwoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateData:(TwoModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    self.titleL.text = model.name;
//    [self.titleL setFont:[UIFont systemFontOfSize:0.0353*SCREENW]];
    self.priceAndLikeL.text = [NSString stringWithFormat:@"￥%@           ❤️%@",model.price,model.favorites_count];
//    [self.priceAndLikeL setFont:[UIFont systemFontOfSize:0.0353*SCREENW]];
}

@end
