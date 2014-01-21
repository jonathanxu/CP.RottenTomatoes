//
//  CPMoviesViewController.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/20/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPMoviesViewController.h"
#import "Foundation/Foundation.h"
#import "Models/CPMovieSummaryModel.h"

@interface CPMoviesViewController ()
@property (strong, nonatomic) NSArray *movies;
@end

@implementation CPMoviesViewController

@synthesize movies = _movies;

- (void)setMovies:(NSArray *)movies
{
    NSLog(@"CPMoviesViewController: setMovies");
    _movies = movies;
    // TODO: refresh view
}

// use viewDidLoad instead of init for fetching rotten tomatoes data
- (void)viewDidLoad
{
    NSLog(@"CPMoviesViewController: viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadMovies];
}


- (void)loadMovies
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apiKey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        id json = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:nil];
        NSArray *movies_json = [json objectForKey:@"movies"];
        
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        
        for (NSDictionary *movie_json in movies_json) {
            NSString *title = [movie_json objectForKey:@"title"];
            NSString *synopsis = [movie_json objectForKey:@"synopsis"];
            NSString *casts = @"TODO";
            NSString *boxArtURL = @"TODO";
            
            CPMovieSummaryModel *movie = [[CPMovieSummaryModel alloc] init:title
                                                                  synopsis:synopsis
                                                                     casts:casts
                                                                 boxArtURL:boxArtURL];
            [movies addObject:movie];
        }
        
        self.movies = movies;
    }];
}

@end
