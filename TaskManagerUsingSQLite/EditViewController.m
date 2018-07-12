//
//  EditViewController.m
//  TaskManagerUsingSQLite
//
//  Created by Наташа on 08.07.18.
//  Copyright © 2018 Наташа. All rights reserved.
//

#import "EditViewController.h"
#import "DBManager.h"

@interface EditViewController ()
@property(nonatomic,strong) DBManager *dbManager;
@property(nonatomic,strong) NSArray *pickerdata;

-(void)loadInfoToEdit;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    self.pickerdata = @[@"High",@"Medium",@"Low"];
    self.priorityPicker.delegate = self;
    self.priorityPicker.dataSource = self;
    
    self.priorityLabel.text = @"";
    
    self.taskName.delegate = self;
    self.taskDescription.delegate = self;
    self.deadline.delegate = self;
    self.priorityLabel.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithFileName:@"DBTaskManager.sql"];
    
    if(self.recordIDToEdit != -1){
        [self loadInfoToEdit];
    }
}

- (IBAction)saveInfo:(id)sender {
    NSString *query;
    if(self.recordIDToEdit == -1){
        query = [NSString stringWithFormat:@"insert into taskInfo values(null,'%@','%@',%d, '%@')",self.taskName.text,self.taskDescription.text,[self.deadline.text intValue],self.priorityLabel.text ];
    } else {
        query = [NSString stringWithFormat:@"update taskInfo set taskName = '%@', taskDescription = '%@', deadline = %d, prioriry = '%@' where taskInfoID = %d", self.taskName.text,self.taskDescription.text,self.deadline.text.intValue, self.priorityLabel.text, self.recordIDToEdit];
    }
    [self.dbManager executeQuery:query];
    if(self.dbManager.affectedRows !=0){
        NSLog(@"Query executed successfully. Affected rows = %d",self.dbManager.affectedRows);
        [self.delegate editingInfoWasFinished];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Problems with executing the query");
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)loadInfoToEdit{
    NSString *query = [NSString stringWithFormat:@"select * from taskInfo where taskInfoID = %d", self.recordIDToEdit];
    
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    self.taskName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"taskName"]];
    self.taskDescription.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"taskDescription"]];
    self.deadline.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"deadline"]];
    self.priorityLabel.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"prioriry"]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerdata.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickerdata[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //NSLog(@"User have chosen %@",self.pickerdata[row]);
    self.priorityLabel.text = [NSString stringWithFormat:@"%@",self.pickerdata[row]];
}



@end
