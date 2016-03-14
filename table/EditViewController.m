//
//  EditViewController.m
//  table
//
//  Created by Vlad on 19.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *subTitleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property BOOL changedImage;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *cellData = [self.tableDataController cellDataAtIndexPath:self.indexPath];
    
    self.titleText.text = [cellData valueForKey:@"title"];
    self.subTitleText.text = [cellData valueForKey:@"subTitle"];
    self.contentText.text = [cellData valueForKey:@"content"];
    if ([cellData valueForKey:@"imageData"] != nil)
    {
        self.imageView.image = [UIImage imageWithData:[cellData valueForKey:@"imageData"]];
    }
}

- (IBAction)cancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveClick:(id)sender {
    NSData *dataImage;
    
    NSDictionary *cellData = @{   @"title" : self.titleText.text,
                               @"subTitle" : self.subTitleText.text,
                                @"content" : self.contentText.text};
    NSMutableDictionary *newCellData = [[NSMutableDictionary alloc] initWithDictionary:cellData];
    if (self.changedImage)
    {
        dataImage = UIImageJPEGRepresentation(self.imageView.image, 0.8);
        [newCellData setObject:dataImage forKey:@"imageData"];
    }
    
    [self.tableDataController updateCellModelFromCellData:newCellData atIndexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteClick:(id)sender {
    [self.tableDataController deleteCellModelAtIndexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeImage:(id)sender {
    UIAlertController* chooseAction = [UIAlertController alertControllerWithTitle:@"Сменить фото"
                                                                          message:@""
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Выбрать из галереи" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    [chooseAction addAction:gallery];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Сделать снимок" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"В вашем устройстве нет камеры" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [errorAlert addAction:ok];
            [self presentViewController:errorAlert animated:YES completion:nil];
            
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }];
    [chooseAction addAction:takePhoto];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Отменить" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {}];
    [chooseAction addAction:cancel];
    
    [self presentViewController:chooseAction animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.changedImage = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
