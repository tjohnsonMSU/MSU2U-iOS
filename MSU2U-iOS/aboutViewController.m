//
//  aboutViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/21/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()

@end

@implementation aboutViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [tempImg setImage:[UIImage imageNamed:@"mainBG.png"]];
    [self.tableView setBackgroundView:tempImg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        //User pressed the Contact Development Team cell!
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1];
    //cell.backgroundView.backgroundColor = [UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1];
    cell.backgroundView.alpha = 0.7;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
    cell.detailTextLabel.backgroundColor = cell.contentView.backgroundColor;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    
    switch (section) {
        case 1:
            label.text = @"Meet the Developers";
            break;
        case 2:
            label.text = @"Provide Feedback";
        default:
            break;
    }

    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.backgroundColor = [UIColor clearColor];
    
    
    [headerView addSubview:label];
    
    return headerView;
}

@end
