//
//  ViewController.h
//  TaskManagerUsingSQLite
//
//  Created by Наташа on 06.07.18.
//  Copyright © 2018 Наташа. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "EditViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditViewControllerDelegate,UISearchBarDelegate>
@property(weak,nonatomic) IBOutlet UITableView *tableTasks;

-(IBAction)addNewRecord:(id)sender;


@end

