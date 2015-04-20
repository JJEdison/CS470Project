//
//  HuntTableViewController.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "HuntTableViewController.h"

@interface HuntTableViewController ()

@property (nonatomic) HuntDataSource *huntDataSource;
@property (nonatomic) StepDataSource *stepsDataSource;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) NSString *hunts;



@end

static NSString *tableCellViewID = @"Cell";

@implementation HuntTableViewController



-(id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSLog( @"in hunts view did load" );
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellViewID];
    
    NSString *huntURLString = @"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=allHunts";
    
    self.huntDataSource = [[HuntDataSource alloc] initWithHuntsURLString:huntURLString];
    [self.huntDataSource setDelegate:self];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setCenter:self.view.center];
    [self.view addSubview:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = @"Hunts";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dataSourceReadyForUse:(HuntDataSource *) dataSource
{
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {    // Return the number of sections.
    if( ! [self.huntDataSource dataReadyForUse] )
    {
        [self.activityIndicator startAnimating];
        [self.activityIndicator setHidesWhenStopped:YES];
    }
    
    return 1;
}

-(void) refreshTableView: (UIRefreshControl *) sender
{
    [self.tableView reloadData];
    [sender endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSLog(@"Number of rows in the table: %ld", (long)[self.huntDataSource numberOfHunts]);
    
    return [self.huntDataSource numberOfHunts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableCellViewID];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    //    cell.selectionStyle = UITableViewCellStyleSubtitle;
    
    
    
    
    Hunt *hunt = [self.huntDataSource huntAtIndex:[indexPath row]];
    // Configure the cell...
    
    cell.textLabel.text = [hunt title];
//    NSString *city = @"City: ";
//    NSString *cityTitle = [city stringByAppendingString:[movieTheater cityTitle]];
//    cell.detailTextLabel.text = cityTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog( @"%@", [hunt title] );
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.huntDataSource deleteHuntAtIndex:[indexPath row]];
    [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Hunt *hunt = [self.huntDataSource huntAtIndex:[indexPath row]];
    self.hunts = [hunt title];
    
    //    MovieTableViewController *mvc = [[MovieTableViewController alloc] init];
    
    //    theaterDetailedTableViewController *mvc = [[theaterDetailedTableViewController alloc] initWithTheater:self.theater];
    //    theaterDetailedViewController *tvc = [[theaterDetailedViewController alloc] initWithTheater:(theaters *)self.theater];
    //    [self.navigationController pushViewController:tvc animated:YES];
    
//    MoviesTableViewController *mvc = [[MoviesTableViewController alloc] initWithTheater:(theaters *)self.theater];
//    [self.navigationController pushViewController:mvc animated:YES];
//    HuntDetailViewController *hdvc = [[HuntDetailViewController alloc] init];
  //  [self.navigationController pushViewController:hdvc animated:YES];
    
    
//    StepViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepViewController"];
//    StepViewController *svc = [[StepViewController alloc] initWithTitle:[hunt title]];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    StepViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"StepViewController"];
//    [svc initWithTitle:[hunt title]];
    svc.huntName = [hunt title];
    [self.navigationController pushViewController:svc animated:YES];
    
    
    NSString *stepsURLString = [NSString stringWithFormat:@"cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=stepsInHunt&rHunt=%@", [hunt title]];
    self.stepsDataSource = [[StepDataSource alloc] initWithStepsURL:stepsURLString];
    [self.stepsDataSource setDelegate:self];
    

    
}



@end
