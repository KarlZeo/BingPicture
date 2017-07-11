//
//  KZBingImageApiRequest.h
//  BingPicture
//
//  Created by Zeo on 11/07/2017.
//  Copyright © 2017 Zeo. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface KZBingImageApiRequest : YTKRequest

- (instancetype)initWithIDX:(NSString *)idx n:(NSString *)n;

@end
