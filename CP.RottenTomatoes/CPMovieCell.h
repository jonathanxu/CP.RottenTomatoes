//
//  CPMovieCell.h
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/21/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models/CPMovieSummaryModel.h"

@interface CPMovieCell : UITableViewCell

- (void)setModel:(CPMovieSummaryModel *) model;

@end
