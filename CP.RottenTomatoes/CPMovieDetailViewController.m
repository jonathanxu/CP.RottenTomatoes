//
//  CPMovieDetailViewController.m
//  CP.RottenTomatoes
//
//  Created by Jonathan Xu on 1/21/14.
//  Copyright (c) 2014 Jonathan Xu. All rights reserved.
//

#import "CPMovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CPMovieDetailViewController ()
@property (strong, nonatomic) CPMovieSummaryModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *castsLabel;
@end

@implementation CPMovieDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)setMovieModelForSegue:(CPMovieSummaryModel *) movieModel
{
    self.model = movieModel;
}

- (void)updateUI
{
    self.title = self.model.title;
    self.posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.posterImageView.clipsToBounds = YES;
    [self.posterImageView setImageWithURL:[NSURL URLWithString:self.model.originalPosterURL]];
    self.summaryLabel.text = self.model.synopsis;
    self.castsLabel.text = self.model.casts;
}

- (IBAction)closeBarButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
