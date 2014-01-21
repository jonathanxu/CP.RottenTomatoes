//
//  CPMovieSummaryModel.h
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/20/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMovieSummaryModel : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *casts;
@property (strong, nonatomic) NSString *boxArtURL;

// default initializer
- (instancetype)init:(NSString *)title
            synopsis:(NSString *)synopsis
               casts:(NSString *)casts
           boxArtURL:(NSString *)boxArtURL;

@end
