//
//  GroupsViewController.h
//  FriendSnap
//
//  Created by cristian cirjan on 1/1/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;


@end
