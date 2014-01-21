//
//  CPMovieSummaryModel.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/20/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPMovieSummaryModel.h"

@implementation CPMovieSummaryModel

- (instancetype)init:(NSString *)title
            synopsis:(NSString *)synopsis
               casts:(NSString *)casts
  thumbnailPosterURL:(NSString *)thumbnailPosterURL
   originalPosterURL:(NSString *)originalPosterURL
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.synopsis = synopsis;
        self.casts = casts;
        self.thumbnailPosterURL = thumbnailPosterURL;
        self.originalPosterURL = originalPosterURL;
    }
    
    return self;
}

@end
