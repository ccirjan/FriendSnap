//
//  EditFriendsViewController.m
//  FriendSnap
//
//  Created by cristian cirjan on 1/1/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import "EditFriendsViewController.h"
#import "FriendsViewController.h"



@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // this function generates a list of users asyncronously
    // block stores all users into the objects array, which is set to property 'allUsers'
    PFQuery *query =[PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        if (error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            self.allUsers=objects;
            //NSLog(@"%@", self.allUsers);
            // alerts tableview of new data
            [self.tableView reloadData];
        }
    }];
    
    self.currentUser = [PFUser currentUser];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this function adds users into a row in the editfriends tableview
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user =[self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType= UITableViewCellAccessoryNone;
        
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselects users (dehighlights row)immidiately after click
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // this fuction adds users, using a reference to the tableview cell
    // add/delete selected users from our list of friends
    // indicate when a user has been selected
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user =[self.allUsers objectAtIndex:indexPath.row];
    
    PFRelation * friendsRelation= [self.currentUser relationForKey:@"friendsRelation"];
    
    if ([self isFriend: user ]){
        //1. remove checkmark, 2. romove from array of friends 3. remove from backend
        cell.accessoryType= UITableViewCellAccessoryNone;
        for(PFUser *friend in self.friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
      
        [friendsRelation removeObject:user];
      
    }
    
    else{
        // add friends and save in background
        cell.accessoryType= UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        [friendsRelation addObject:user];
        
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error){
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];

    
    

}

#pragma mark - Helper methods


- (BOOL)isFriend:(PFUser *)user {
    for(PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    
    return NO;
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

@end
