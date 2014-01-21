//
//  CPMoviesViewController.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/20/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "Reachability.h"
#import "CPMoviesViewController.h"
#import "CPMovieDetailViewController.h"
#import "CPMovieCell.h"
#import "Models/CPMovieSummaryModel.h"
#import "SVProgressHUD.h"

@interface CPMoviesViewController ()
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) Reachability *reach;

- (void)doRefresh;
- (void)parseMovies:(NSArray *)movies_json;

@end

@implementation CPMoviesViewController

@synthesize movies = _movies;

- (void)setMovies:(NSArray *)movies
{
    NSLog(@"CPMoviesViewController: setMovies");
    _movies = movies;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
}

// use viewDidLoad instead of init for fetching rotten tomatoes data
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD show];
    
    [self doRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"CPMoviesViewController: viewWillAppear");
    [super viewWillAppear:animated];
    [self reachabilityStart];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"CPMoviesViewController: viewWillDisappear");
    [super viewWillDisappear:animated];
    [self reachabilityStop];
}

- (void)reachabilityStart
{
    self.reach = [Reachability reachabilityWithHostname:@"api.rottentomatoes.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reach startNotifier];
}

- (void)reachabilityStop
{
    if (self.reach) {
        [self.reach stopNotifier];
        self.reach = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

- (BOOL)reachabilityChanged:(NSNotification*) note
{
    BOOL status = YES;
    NSLog(@"reachabilityChanged");
    
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //notificationLabel.text = @"Notification Says Reachable"
        status = YES;
        NSLog(@"NetWork is Available");
    }
    else
    {
        status = NO;
        NSLog(@"NetWork is Not Available");
    }
    return status;
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
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSIndexPath *path = [self.tableView indexPathForCell:selectedCell];
        NSLog(@"CPMoviesViewController: prepareForSegue, row %ld", (long)path.row);
        CPMovieDetailViewController *dvc = (CPMovieDetailViewController *)segue.destinationViewController;
        [dvc setMovieModelForSegue:self.movies[path.row]];
    }
}

#pragma mark - Fetch Data

- (void)parseMovies:(NSArray *)movies_json
{
    NSLog(@"CPMoviesViewController: parseMovies");

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
    
    self.movies = movies;

    NSLog(@"CPMoviesViewController: parseMovies done");
}

- (void)loadMovies
{
    NSLog(@"CPMoviesViewController: loadMovies");
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apiKey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"CPMoviesViewController: before async network request");
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        NSLog(@"CPMoviesViewController: inside completion handler");

        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!error && (responseCode == 200)) {
            NSLog(@"CPMoviesViewController: inside completion handler, no error");
            id json = [NSJSONSerialization JSONObjectWithData:data
                                                      options:0
                                                        error:nil];
            NSArray *movies_json = [json objectForKey:@"movies"];
            [self parseMovies:movies_json];
        } else {
            NSLog(@"CPMoviesViewController: inside completion handler, error %@, code %d", error, responseCode);
        }

        NSLog(@"CPMoviesViewController: done with completion handler");
    }];
}

@end
