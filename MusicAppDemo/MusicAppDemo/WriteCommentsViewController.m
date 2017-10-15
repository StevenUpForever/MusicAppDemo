//
//  WriteCommentsViewController.m
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/18.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import "WriteCommentsViewController.h"
#import "CoreDataProcess.h"

@interface WriteCommentsViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textInput;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (nonatomic) UIAlertController *alertController;
@property (nonatomic) UIImagePickerController *imagePicker;

@end

@implementation WriteCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self AlertViewLoad];
    [self utilityLoad];
}

- (void)AlertViewLoad
{
    self.alertController = [UIAlertController alertControllerWithTitle:@"Choose Photos" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"From Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"From Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.alertController addAction:action1];
    [self.alertController addAction:action2];
    [self.alertController addAction:action3];
}

- (void)utilityLoad
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    
    self.textInput.layer.borderWidth = 1.0;
    self.textInput.layer.cornerRadius = 2.0;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
    
    if (self.detailEntity)
    {
        [self.imageButton setImage:[UIImage imageWithData:self.detailEntity.imageData] forState:UIControlStateNormal];
        self.textInput.text = self.detailEntity.comments;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)submitButton {
    if (self.detailEntity != nil)
    {
        [self updateData];
    }
    else{
        [self insertData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imageProcess {
    [self presentViewController:self.alertController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - coreData process

- (void)insertData
{
    //The key point for insert real time
    CoreDataProcess *core = [CoreDataProcess defaultStack];
    DetailEntity *insertEntity = [NSEntityDescription insertNewObjectForEntityForName:@"DetailEntity" inManagedObjectContext:core.managedObjectContext];
    insertEntity.comments = self.textInput.text;
    insertEntity.imageData = UIImageJPEGRepresentation(self.imageButton.imageView.image, 0.75);
    insertEntity.date = [[NSDate date]timeIntervalSince1970];
    [core saveContext];
}

- (void)updateData
{
    self.detailEntity.comments = self.textInput.text;
    self.detailEntity.imageData = UIImageJPEGRepresentation(self.imageButton.imageView.image, 0.75);
    CoreDataProcess *core = [CoreDataProcess defaultStack];
    [core saveContext];
}


@end
