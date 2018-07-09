//
//  ViewController.m
//  TaskManagerUsingSQLite
//
//  Created by Наташа on 06.07.18.
//  Copyright © 2018 Наташа. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong,nonatomic) DBManager* dbManager;
@property(strong,nonatomic) NSArray *arrTaskInfo;
@property(nonatomic) int recordIDToEdit;

-(void)loadData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableTasks.delegate = self;
    self.tableTasks.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithFileName:@"taskManager.sql"];
    
    
    
    [self loadData];
}

-(IBAction) addNewRecord:(id)sender{
    self.recordIDToEdit = -1;
    
    [self performSegueWithIdentifier:@"idSequeEditInfo" sender:self];
}
-(void)loadData{
    NSString *query = @"select * from taskInfo";
    
    if(self.arrTaskInfo != nil){
        self.arrTaskInfo = nil;
    }
    self.arrTaskInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    [self.tableTasks reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrTaskInfo.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger taskNameIndex = [self.dbManager.arrColumnNames indexOfObject:@"taskName"];
    NSInteger taskDescriptionIndex = [self.dbManager.arrColumnNames indexOfObject:@"taskDescription"];
    NSInteger deadlineIndex = [self.dbManager.arrColumnNames indexOfObject:@"deadline"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:taskNameIndex],[[self.arrTaskInfo objectAtIndex:indexPath.row]objectAtIndex:taskDescriptionIndex] ];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Deadline: %@ days", [[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:deadlineIndex]];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.recordIDToEdit = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"idSequeEditInfo" sender:self];
}
-(void)editingInfoWasFinished{
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditViewController *editVC = [segue destinationViewController];
    editVC.delegate = self;
    
    editVC.recordIDToEdit = self.recordIDToEdit;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        int recordIDToDelete = [[[self.arrTaskInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        NSString *query = [NSString stringWithFormat:@"delete from taskInfo where taskInfoID=%d", recordIDToDelete];
        [self.dbManager executeQuery:query];
        [self loadData];
    }
}

@end
