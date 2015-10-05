//
//  SSOPhotoDetailCommentsViewController.m
//  uSnap
//
//  Created by Yanick Lavoie on 2015-09-29.
//  Copyright © 2015 Samsao. All rights reserved.
//

#import "SSOPhotoDetailCommentsViewController.h"
#import "SSOFeedConnect.h"
#import "SSOThemeHelper.h"
#import "SSCellViewItem.h"
#import "SSSessionManager.h"
#import "SSOFeedConnect.h"
#import "SDiPhoneVersion.h"

@interface SSOPhotoDetailCommentsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *extraActionsButton;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (assign) BOOL keyboardShown;
@property (assign) CGFloat keyboardOverlap;
@property (weak, nonatomic) IBOutlet UIView *commentBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentBarBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *fakeNavBar;
@property (nonatomic) UIKeyboardType currentKBType;
@end

@implementation SSOPhotoDetailCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendCommentButton.layer.cornerRadius = 6.0f;
    self.sendCommentButton.clipsToBounds = YES;
    self.sendCommentButton.titleLabel.font = [SSOThemeHelper avenirLightFontWithSize:18];
     
    self.sendCommentButton.tintColor = [SSOThemeHelper firstColor];
    
    self.addCommentTextField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1.0f)];
    self.addCommentTextField.autocorrectionType = UITextAutocorrectionTypeNo;

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    

}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.addCommentTextField becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


//    [self adjustDisplayForKeyboardShownForHeight:-1];
    
    self.loveButton.selected = self.loved;
    self.commentButton.selected = self.items.count>0?YES:NO;
    
    if (self.items.count>0)
        [self.commentsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) adjustDisplayForKeyboardShownForHeight:(CGFloat)keyboardHeight {
    CGRect f = self.view.frame;
    CGFloat adjustedTableViewH = 0;
    CGFloat statusBarHeight = 20.0f;
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat navBarHeight = self.fakeNavBar.frame.size.height;
    CGFloat commentBarHeight = self.commentBar.frame.size.height;
    CGFloat adjustedBottomConstraint = screenHeight-statusBarHeight-navBarHeight-commentBarHeight-keyboardHeight;
    
    switch ([SDiPhoneVersion deviceSize]) {
        case iPhone35inch:
            adjustedTableViewH = 290;
//            adjustedBottomConstraint = 160;
            break;
        case iPhone4inch:
            adjustedTableViewH = 378;
//            adjustedBottomConstraint = 248;
            break;
        case iPhone47inch:
            adjustedTableViewH = 487;
//            adjustedBottomConstraint = 347;
            break;
        case iPhone55inch:
            adjustedTableViewH = 527;
//            adjustedBottomConstraint = 406;
            break;
            
        default:
            break;
    }
    
    f.size.height = adjustedTableViewH;
    self.view.frame = f;
    self.commentsTableHeightConstraint.constant =  adjustedBottomConstraint;
    
}


#pragma mark - actions

- (IBAction)touchedBackButton:(id)sender {
    [self.addCommentTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)sendCommentAction:(UIButton*)sender {
    if(self.addCommentTextField.text.length>0 && [SSSessionManager sharedInstance].username.length>0 && [self.addCommentTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length>0 ) {
        NSString *user = [[SSSessionManager sharedInstance] username];
        if (!user) {
            user = @"Not Logged In";
        }

        [SSOFeedConnect socialActionWithMediaID:self.snap.id
                                     actionType:@"comment"
                                        content:self.addCommentTextField.text
                                       userName:user
                                         apiKey:@""
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            [self.items addObject:@{@"content":self.addCommentTextField.text, @"username":[SSSessionManager sharedInstance].username}];
                                            
                                            self.addCommentTextField.text = @"";
                                            [self.commentsTableView reloadData];
                                            self.commentButton.selected = self.items.count>0?YES:NO;
                                            [self.commentsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                 message:[NSString stringWithFormat:@"%ld", (long)error.code]
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:@"Ok"
                                                                                       otherButtonTitles:nil, nil];
                                            [errorAlert show];
                                        }];
    }
}
- (IBAction)loveAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    
    //TODO: send the call to the backend
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"Not Logged In";
    }
    
    [SSOFeedConnect socialActionWithMediaID:self.snap.id
                                 actionType:@"love"
                                    content:@""
                                   userName:user
                                     apiKey:@""
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                             message:[NSString stringWithFormat:@"%ld", (long)error.code]
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"Ok"
                                                                                   otherButtonTitles:nil, nil];
                                        [errorAlert show];
                                    }];

}

- (IBAction)commentAction:(UIButton*)sender {
    
}

- (IBAction)extraActionsAction:(UIButton*)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Confirm"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                              [self confirmReportImageAction:nil];
                                                              
                                                          }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"cancel");
                                                           }];
    
    
    [alert addAction:firstAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (IBAction)confirmReportImageAction:(UIButton *)sender {
    NSString *user = [[SSSessionManager sharedInstance] username];
    if (!user) {
        user = @"Not Logged In";
    }
    
    [SSOFeedConnect reportImageWithImageID:self.snap.url
                                  userName:user
                                    apiKey:@""
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:[NSString stringWithFormat:@"%ld", (long)error.code]
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"Ok"
                                                                                  otherButtonTitles:nil, nil];
                                       [errorAlert show];
                                   }];
}

#pragma mark - TableView delegate & dataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat textSize = 0;
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.items[indexPath.row][@"content"]
                                    attributes:@{NSFontAttributeName: [SSOThemeHelper avenirLightFontWithSize:16]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){[UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    textSize = rect.size.height + 40.0f;
    
    return textSize > 60.0f ? textSize : 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1.0f)];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [SSOThemeHelper avenirLightFontWithSize:16];
    cell.detailTextLabel.font = [SSOThemeHelper avenirHeavyFontWithSize:14];
    cell.textLabel.text = self.items[indexPath.row][@"content"];
    cell.detailTextLabel.text = self.items[indexPath.row][@"username"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentKBType = textField.keyboardType;
    NSLog(@"%ld", (long)self.currentKBType);
    if (textField.keyboardType == 4 || textField.keyboardType == 5) {
    } else {
    }

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    self.currentKBType = textField.keyboardType;
    NSLog(@"%ld", (long)self.currentKBType);
    if (textField.keyboardType == 4 || textField.keyboardType == 5) {
    } else {
    }
    
    return YES;
 
}


# pragma mark - keyboard management

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self adjustDisplayForKeyboardShownForHeight:kbSize.height];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

}

@end
