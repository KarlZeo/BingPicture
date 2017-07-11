//
//  KZBingImageApiRequest.m
//  BingPicture
//
//  Created by Zeo on 11/07/2017.
//  Copyright © 2017 Zeo. All rights reserved.
//

#import "KZBingImageApiRequest.h"

@implementation KZBingImageApiRequest{
    NSString *_idx;
    NSString *_n;
}

-(instancetype)initWithIDX:(NSString *)idx n:(NSString *)n{
    self = [super init];
    if (self) {
        _idx = idx;
        _n = n;
    }
    return self;
}

-(NSString *)requestUrl{
    //    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",@"",@"/HPImageArchive.aspx"];
    return @"/HPImageArchive.aspx";
}

-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

-(id)requestArgument {
    return @{
             @"format":@"js",
             @"idx":_idx,
             @"n":_n
             };
}

@end
