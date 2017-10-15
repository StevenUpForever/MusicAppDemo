//
//  ViewController.m
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/16.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import "MainViewController.h"
#import "PlayListTableViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *mainButtons;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"playList"])
    {
        PlayListTableViewController *detailTableView = segue.destinationViewController;
        detailTableView.index = [self.mainButtons indexOfObject:sender];
    }
}

- (IBAction)showDetailList:(id)sender
{
    [self performSegueWithIdentifier:@"playList" sender:sender];
}

@end
