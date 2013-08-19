//
//  feeder.h
//  CarChecker
//
//  Created by Saif Khan on 2013-08-17.
//  Copyright (c) 2013 Saif Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feeder : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *ishaTable;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) NSMutableData *responseData;
@end
