//
//  SMS Receiver API
//  SMSReceiver.h
// 

#import <Cocoa/Cocoa.h>
#import <Pantomime/Pantomime.h>

@interface SMS_Message : NSObject <NSCopying>
{
	NSString *phone, *text;
}

@property(readwrite,copy) NSString *phone;
@property(readwrite,copy) NSString *text;

@end

@interface SMSReceiver : NSObject {
	@private
	NSString *user_account, *password_account;
	CWPOP3Store *_pop3;
	int count;
	int emails;
	NSMutableArray *SMS_list;
	id _delegate;

}

- (void) setup: (NSString*) pop3server port: (int) pop3port user: (NSString*) pop3user password: (NSString*) pop3password;
- (void) start;
- (void) receptionFinished: (NSMutableArray*) messages_list;
- (void) setDelegate: (id) theDelegate;


@end
