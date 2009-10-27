//
//  SMSSender.h
//  Cocoa SMSSender API
//



#import <Cocoa/Cocoa.h>


@interface SMSSender : NSObject {

	@private
	CFReadStreamRef streamSMS;

}

- (NSString *) SendMessage: (NSString *) user password: (NSString *) pass destination: (NSString *) number message: (NSString *) text;

@end
