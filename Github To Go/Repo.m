//
//  Repo.m
//  Github To Go
//
//  Created by Zuri Biringer on 2/11/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "Repo.h"


@implementation Repo

@dynamic html_url;
@dynamic name;
@dynamic html_string;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJSONDictionary:(NSDictionary *)json
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        [self parseJSONDictionary:json];
    }
    
    return self;
}

-(void)parseJSONDictionary:(NSDictionary *)json
{
    self.name = [json objectForKey:@"name"];
    self.html_url = [json objectForKey:@"html_url"];
    [self.managedObjectContext save:nil];
}

@end
