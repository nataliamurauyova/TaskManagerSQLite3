//
//  EditViewController.h
//  TaskManagerUsingSQLite
//
//  Created by Наташа on 08.07.18.
//  Copyright © 2018 Наташа. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewControllerDelegate

-(void)editingInfoWasFinished;
@end

@interface EditViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextField *taskDescription;
@property (weak, nonatomic) IBOutlet UITextField *deadline;
@property(strong,nonatomic) id<EditViewControllerDelegate> delegate;
@property(nonatomic) int recordIDToEdit;
@property (strong, nonatomic) IBOutlet UITextField *priorityLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *priorityPicker;

- (IBAction)saveInfo:(id)sender;

@end


