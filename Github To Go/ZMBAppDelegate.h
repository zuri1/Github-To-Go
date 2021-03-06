//
//  ZMBAppDelegate.h
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMBNetworkController.h"

@protocol LoginDelegate <NSObject>

-(void)confirmLogin;

@end

@interface ZMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ZMBNetworkController *networkController;
@property BOOL authenticated;
@property (weak, nonatomic) id<LoginDelegate> delegate;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;

@end
