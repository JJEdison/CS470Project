//
//  HuntTableViewController.h
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HuntDataSource.h"
#import "StepDataSource.h"
#import "Hunt.h"
#import "HuntDetailViewController.h"
#import "StepViewController.h"

@interface HuntTableViewController : UITableViewController<DataSourceReadyForUseDelegate, UITableViewDelegate, UITableViewDataSource>

@end
