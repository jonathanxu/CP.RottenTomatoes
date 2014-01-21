//
//  CPMoviesViewController.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/20/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPMoviesViewController.h"
#import "Foundation/Foundation.h"

@interface CPMoviesViewController ()

@end

@implementation CPMoviesViewController

// use viewDidLoad instead of init for fetching rotten tomatoes data
- (void)viewDidLoad
{
    NSLog(@"CPMoviesViewController: viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadMovies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMovies
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apiKey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               id json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
                               NSLog(@"%@", json);
                           }];
}

@end
