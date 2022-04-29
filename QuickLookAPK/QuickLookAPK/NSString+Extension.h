//
//  NSString+Extension.h
//  ParseAndroidMainfest
//
//  Created by PAN on 2021/9/2.
//

#import <Foundation/Foundation.h>

@interface NSString (Spacing)
-(NSInteger)preSpcaing;
@end

@interface NSString (Regex)
-(NSString *)regexMatch:(NSString *)regex;
@end
