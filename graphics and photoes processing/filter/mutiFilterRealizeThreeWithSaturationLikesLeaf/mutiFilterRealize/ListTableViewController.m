//
//  ListTableViewController.m
//  mutiFilterRealize
//
//  Created by Gguomingyue on 2018/1/18.
//  Copyright © 2018年 Gguomingyue. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kStandTableViewCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"单个shader效果";
    }else {
        cell.textLabel.text = @"多个shader效果";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"gotoVC1" sender:nil];
    }else {
        [self performSegueWithIdentifier:@"gotoVC2" sender:nil];
    }
}

@end
