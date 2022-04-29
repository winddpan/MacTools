//
//  NSString+Extension.m
//  ParseAndroidMainfest
//
//  Created by PAN on 2021/9/2.
//

#import "NSString+Extension.h"

@implementation NSString (Revers)
-(NSInteger)preSpcaing {
    NSUInteger length = [self length];
    NSInteger count = 0;
    for(long i=0; i < length; i++){
        unichar c = [self characterAtIndex:i];
        // 等于空格
        if (c == 0x20) {
            count = i;
        } else {
            break;
        }
    }
    return count;
}
@end


@implementation NSString (Regex)
-(NSString *)regexMatch:(NSString *)regex {
    NSRegularExpression *regexExp = [NSRegularExpression regularExpressionWithPattern:regex
                                                      options:0
                                                        error:nil];
    NSMutableString *str = [NSMutableString new];
    [regexExp enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
    {
        for (int i=0; i< [result numberOfRanges]; i ++) {
            NSRange range = [result rangeAtIndex:i];
            [str appendString:[self substringWithRange:range]];
        }
    }];
    return str;
}
@end
