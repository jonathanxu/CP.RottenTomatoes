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
           boxArtURL:(NSString *)boxArtURL
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.synopsis = synopsis;
        self.casts = casts;
        self.boxArtURL = boxArtURL;
    }
    
    return self;
}

@end
