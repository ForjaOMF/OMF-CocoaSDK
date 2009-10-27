//
//  AutoWP.h
//  Cocoa Auto WAP PUSH API
//


#import <Cocoa/Cocoa.h>


@interface AutoWP : NSObject {

}

- (NSString *) SendAutoWP: (NSString *) login password: (NSString *) pass url: (NSString *) dir text: (NSString *) message;

@end
