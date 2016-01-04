//
//  ImageViewController.h
//  FriendSnap
//
//  Created by cristian cirjan on 1/3/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
