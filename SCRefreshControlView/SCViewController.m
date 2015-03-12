//
//  SCViewController.m
//  SCRefreshControl
//
//  Created by Singro on 12/29/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCViewController.h"

#import "SCRefreshControlView.h"

static CGFloat const kTableViewBeginLoadingOffset = 80.0f;

@interface SCViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SCRefreshControlView *refreshControlView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SCViewController
//testred
- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.refreshControlView = [[SCRefreshControlView alloc] init];
    [self.view addSubview:self.refreshControlView];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    
    self.refreshControlView.frame = (CGRect){190, 120, 0, 0};
    
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffset = -scrollView.contentOffset.y;
    
    self.refreshControlView.timeOffset = (yOffset / kTableViewBeginLoadingOffset);
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat yOffset = -scrollView.contentOffset.y;
    
    if (yOffset > kTableViewBeginLoadingOffset) {
        [self.refreshControlView beginRefreshing];
        
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:3.0f];
    }
    
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    static NSInteger index = 0;
    index ++;
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell %d", index];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)endRefreshing {
    
    [self.refreshControlView endRefreshing];
    
}

@end
