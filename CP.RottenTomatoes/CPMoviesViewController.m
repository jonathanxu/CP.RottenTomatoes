//
//  CPMoviesViewController.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/20/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "CPMoviesViewController.h"
#import "CPMovieDetailViewController.h"
#import "CPMovieCell.h"
#import "Models/CPMovieSummaryModel.h"

@interface CPMoviesViewController ()
@property (strong, nonatomic) NSArray *movies;

- (void)doRefresh;

@end

@implementation CPMoviesViewController

@synthesize movies = _movies;

- (void)setMovies:(NSArray *)movies
{
    NSLog(@"CPMoviesViewController: setMovies");
    _movies = movies;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

// use viewDidLoad instead of init for fetching rotten tomatoes data
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self doRefresh];
}

#pragma mark - Table View Methods
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"CPMoviesViewController: tableView:numberOfRowsInSection");
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMovieCell *cell = (CPMovieCell *)[tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    [cell setModel:self.movies[indexPath.row]];
    return cell;
}

- (void)doRefresh
{
    [self.refreshControl beginRefreshing];
    [self loadMovies];
}

- (IBAction)refresh
{
    [self doRefresh];
}

#pragma mark - Segue into Detail View

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"CPMoviesViewController: prepareForSegue");
    if ([segue.identifier isEqualToString:@"ViewMovieDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSLog(@"CPMoviesViewController: prepareForSegue, row %ld", (long)path.row);
        CPMovieDetailViewController *dvc = (CPMovieDetailViewController *)segue.destinationViewController;
        [dvc setMovieModelForSegue:self.movies[path.row]];
    }
}

#pragma mark - Fetch Data

- (void)loadMovies
{
    NSLog(@"CPMoviesViewController: loadMovies");
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apiKey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"CPMoviesViewController: before async network request");
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        NSLog(@"CPMoviesViewController: inside completion handler");
        id json = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:nil];
        NSArray *movies_json = [json objectForKey:@"movies"];
        
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        
        for (NSDictionary *movie_json in movies_json) {
            NSString *title = [movie_json objectForKey:@"title"];
            NSString *synopsis = [movie_json objectForKey:@"synopsis"];
            
            // deal with casts, which is in an array of dictionaries
            NSArray *casts_json = [movie_json objectForKey:@"abridged_cast"];
            NSMutableArray *castsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *cast_json in casts_json) {
                NSString *currCast = [cast_json objectForKey:@"name"];
                if (currCast) {
                    [castsArray addObject:currCast];
                }
            }
            NSString *casts = [castsArray componentsJoinedByString:@", "];
            
            NSDictionary *poster = [movie_json objectForKey:@"posters"];
            NSString *thumbnailPosterURL = [poster objectForKey:@"thumbnail"];
            NSString *originalPosterURL = [poster objectForKey:@"original"];
            
            CPMovieSummaryModel *movie = [[CPMovieSummaryModel alloc] init:title
                                                                  synopsis:synopsis
                                                                     casts:casts
                                                        thumbnailPosterURL:thumbnailPosterURL
                                                         originalPosterURL:originalPosterURL];
            [movies addObject:movie];
        }
        
        NSLog(@"CPMoviesViewController: parsed movies");

        self.movies = movies;

        NSLog(@"CPMoviesViewController: done with completion handler");
    }];
}

@end
