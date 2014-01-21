//
//  CPMovieCell.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/21/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPMovieCell.h"
#import "UIImageView+AFNetworking.h"

@interface CPMovieCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *castsLabel;
@end

@implementation CPMovieCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CPMovieSummaryModel *) model
{
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:model.thumbnailPosterURL]];
    self.titleLabel.text = model.title;
    self.synopsisLabel.text = model.synopsis;
    self.castsLabel.text = model.casts;
}

@end
