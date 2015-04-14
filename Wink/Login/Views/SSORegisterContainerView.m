//
//  SSORegisterContainerView.m
//  Wink
//
//  Created by Nicolas Vincensini on 2015-04-10.
//  Copyright (c) 2015 Samsao. All rights reserved.
//

#import "SSORegisterContainerView.h"

@interface SSORegisterContainerView ()

@property(strong, nonatomic) NSDictionary *infoDic;
@property(strong, nonatomic) NSDictionary *metaDic;

@end

@implementation SSORegisterContainerView

- (void)awakeFromNib {
    //  [self setupViewForAnimation];
}

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self == [super initWithCoder:aDecoder]) {
    }

    return self;
}
/**
 *  Set UI to display animations when the view appears
 */
- (void)setupViewForAnimation {

    // Setup textfields and button for animation
    self.textFieldEmail.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.textFieldEmail.alpha = 0.0f;
    self.textFieldPassword.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    self.textFieldPassword.alpha = 0.0f;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      CGFloat duration = 0.5f;
      CGFloat delay = 0.2f;

      CGFloat damping = 0.55f;
      CGFloat velocity = 0.75f;

      [UIView animateWithDuration:duration
                            delay:(delay * 0.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         self.textFieldEmail.transform = CGAffineTransformIdentity;
                         self.textFieldEmail.alpha = 1.0f;
                       }
                       completion:nil];

      [UIView animateWithDuration:duration
                            delay:(delay * 1.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{
                         self.textFieldPassword.transform = CGAffineTransformIdentity;
                         self.textFieldPassword.alpha = 1.0f;
                       }
                       completion:nil];

      [UIView animateWithDuration:duration
                            delay:(delay * 2.0f)
           usingSpringWithDamping:damping
            initialSpringVelocity:velocity
                          options:UIViewAnimationOptionCurveLinear
                       animations:^{

                       }
                       completion:nil];

    });
}

- (NSDictionary *)infoDic {

    if (!_infoDic) {
        _infoDic = [[NSDictionary alloc] init];

        _infoDic = @{ @"email" : self.textFieldEmail.text, @"password" : self.textFieldPassword.text };
    }

    return _infoDic;
}
- (NSDictionary *)metaDic {

    if (!_metaDic) {
        _metaDic = [[NSDictionary alloc] init];

        _metaDic = @{
            @"birthday" : self.textFieldBirthday.text,
            @"lastName" : self.textFieldLastName.text,
            @"firstName" : self.textFieldFirstName.text,
            @"username" : self.textFieldUsername.text
        };
    }

    return _metaDic;
}

- (BOOL)areTextFieldsValid {
    for (UIView *textFieldView in self.subviews) {
        if ([textFieldView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)textFieldView;
            if (textField.text.length == 0) {
                [UIAlertView showWithTitle:@"Missing fields" message:@"Check the fields" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:nil];
                return NO;
            }
        }
    }
    return YES;
}

- (IBAction)registerButtonPushed:(id)sender {
    if ([self areTextFieldsValid]) {
        [self.delegate didRegisterWithInfo:self.infoDic andMeta:self.metaDic];
    }
}

@end
