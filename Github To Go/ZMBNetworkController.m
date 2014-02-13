//
//  ZMBNetworkController.m
//  Github To Go
//
//  Created by Zuri Biringer on 1/27/14.
//  Copyright (c) 2014 Zuri Biringer. All rights reserved.
//

#import "ZMBNetworkController.h"

@implementation ZMBNetworkController

#define GITHUB_OAUTH_URL @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
#define GITHUB_CLIENT_ID @"4c9e6d2614bf5bc56bb2"
#define GITHUB_CLIENT_SECRET @"4654a91ca5268d39a7959add7cb33c0fcb2e9f56"
#define GITHUB_REDIRECT @"githubtogo://git_callback"
#define GITHUB_OAUTH_POST_URL @"https://github.com/login/oauth/access_token"

+(ZMBNetworkController *)sharedController {
    static dispatch_once_t pred;
    static ZMBNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[ZMBNetworkController alloc] init];
    });
    return shared;
}

-(NSMutableArray *)reposForSearchString:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https:api.github.com/search/repositories?q=%@", searchString];
    
    NSError *error;
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    return searchDictionary[@"items"];
}

-(void)beginOAuthAccess
{
    NSString *myURL = [NSString stringWithFormat:GITHUB_OAUTH_URL, GITHUB_CLIENT_ID, GITHUB_REDIRECT, @"user,repo"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
}

-(void)handleCallBackURL:(NSURL *)url
{
    NSString *code = [self convertURLToCode:url];
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&redirect+uri=%@", GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, code, GITHUB_REDIRECT];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:GITHUB_OAUTH_POST_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    self.accessToken = [self convertResponseIntoToken:responseData];
    
    [self fetchUsersRepos];
}

-(void)fetchUsersRepos
{
    NSString *stringURL = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", self.accessToken];
    
    NSURL *myURL = [NSURL URLWithString:stringURL];
    NSData *responseData = [NSData dataWithContentsOfURL:myURL];
    
    NSError *error;

    NSMutableDictionary *repoDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    self.repoArray = [NSMutableArray new];
  
    for (NSDictionary *dictionary in repoDictionary) {
        [self.repoArray addObject:[dictionary valueForKey:@"name"]];
    }
    

}

-(NSString *)convertURLToCode:(NSURL *)url
{
    NSString *query = [url query];
    NSArray *components = [query componentsSeparatedByString:@"="];
//    NSLog(@"%@", components);
    NSString *code = [components lastObject];
    return code;
}

-(NSString *)convertResponseIntoToken:(NSData *)data
{
    NSString *tokenResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSArray *components = [tokenResponse componentsSeparatedByString:@"&"];
    NSString *access_token = [components firstObject];
    NSArray *components2 = [access_token componentsSeparatedByString:@"="];
    
    return [components2 lastObject];
    
    return tokenResponse;
}

-(void)createNewRepo:(NSString *)repoName {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *stringURL = [NSString stringWithFormat:@"https://api.github.com/user/repos?access_token=%@", self.accessToken];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    
                                    repoName, @"name", nil];
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                        
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    [theRequest setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:theRequest
                                      
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           
                                                           if(error == nil)
                                                               
                                                           {
                                                               
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               
                                                               NSLog(@"Data = %@",text);
                                                               
                                                           }
                                                           
                                                       }];
    
    [dataTask resume];
    
}

@end
