//
//  DetailTableViewController.m
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/17.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import "PlayListTableViewController.h"
#import "mainTableViewCell.h"
#import "DetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PlayListTableViewController ()
@property(nonatomic) MBProgressHUD *progressHUD;

@end

@implementation PlayListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.webdata.titleArray objectAtIndex:self.index];
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.view];
    self.progressHUD.labelText = @"Loading";
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];
    self.webdata = [[FetchWebData alloc]init];
    [self.webdata fetchMainData:self.index];
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableViewBackground"]];
    self.tableView.backgroundView = background;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mainTableViewReload) name:@"mainTableViewReload" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = [self.webdata.titleArray objectAtIndex:self.index];
}

- (void)mainTableViewReload
{
   
    [self.tableView reloadData];
        [self.progressHUD hide:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"mainTableViewReload" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.webdata.imageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    mainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[mainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    cell.titleLabel.text = [self.webdata.dataArray objectAtIndex:indexPath.row];
    cell.playListImage.image = [self.webdata.imageArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
        return cell;
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"audio"]) {
        DetailViewController *detail = segue.destinationViewController;
        detail.detailIndex = [self.webdata.dataArray indexOfObject:[sender titleLabel].text];
        detail.dataIndex = self.index;
    }
}
@end
