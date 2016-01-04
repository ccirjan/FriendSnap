//
//  ChatViewController.m
//  FriendSnap
//
//  Created by cristian cirjan on 12/30/15.
//  Copyright © 2015 cristian cirjan. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ImageViewController.h"


@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        NSLog(@"Current user: %@", currentUser.username);
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        // show the signup or login screen
    
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // with the query we retrieve our messages from the parse database, making sure to only recieve messages of which I am a recipient
    PFQuery *query=[PFQuery queryWithClassName:@"Messages"];
    // prevents error when running for first time in a while
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    }
    else{
    [query whereKey:@"recipientsIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *  error) {
        if (error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            // we found messages!
            self.messages= objects;
            [self.tableView reloadData];
            NSLog(@"Retrieved %lu messages", (unsigned long)[self.messages count]);
        }
    
    }];
}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this function adds users into a row in the editfriends tableview
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    NSString *fileType= [message objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"]){
        cell.imageView.image=[UIImage imageNamed:@"Xlarge Icons-50"];
    }
    else{
        cell.imageView.image=[UIImage imageNamed:@"Movie-50"];

    }
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedMessage=[self.messages objectAtIndex:indexPath.row];
    NSString *fileType= [self.selectedMessage objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"]){
        // if the selected message is an image, we segue into the imageview controller
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else{
        
    }


}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logout:(id)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    //PFUser *currentUser = [PFUser currentUser]; // this will now be nil
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showLogin"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        LoginViewController *lvc = segue.destinationViewController;
        [lvc setHidesBottomBarWhenPushed:YES];
        lvc.navigationItem.hidesBackButton = YES;
    }
    else if ([segue.identifier isEqualToString:@"showImage"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController=(ImageViewController *)segue.destinationViewController;
        imageViewController.message =self.selectedMessage;
        
    }
        
    
}
@end
