//
//  SignupViewController.m
//  FriendSnap
//
//  Created by cristian cirjan on 12/30/15.
//  Copyright © 2015 cristian cirjan. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signup:(id)sender {
    NSString *username= [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password= [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email= [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] ==0 || [password length]==0 || [email length]== 0) {
        
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Make sure to enter username!" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
//        UIAlertControllerStyleAlert *alertController = UIAlertController(title: @"Default Style", message: @"A standard alert.", preferredStyle: .Alert)
//        
//        cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
//            // ...
//        }
//        alertController.addAction(cancelAction)
//        
//        OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//            // ...
//        }
//        alertController.addAction(OKAction)
//        
//        self.presentViewController(alertController, animated: true) {
//            // ...
//        }
////        UIAlertController * alertView= [UIAlertController alloc] initwith;
//        UIAlertControllerStyleAlert *alertView= [UIAlertControllerStyleAlert alloc
//     // UIAlertView *alertview [[[UIAlertView alloc] initwithTitle:@"Oops!" message:@"Make sure you enter username!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}
                              
                              
@end
