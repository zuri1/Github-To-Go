//
//  Repo.h
//  Github To Go
//
//  Created by Zuri Biringer on 2/11/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Repo : NSManagedObject

@property (nonatomic, retain) NSString * html_url;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * html_string;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
 withJSONDictionary:(NSDictionary *)json;

@end
