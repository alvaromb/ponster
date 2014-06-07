//
//  NSManagedObject+Utils.m
//  Ponster
//
//  Created by Álvaro on 07/06/14.
//  Copyright (c) 2014 alvaromb. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSManagedObject (Utils)

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

@end