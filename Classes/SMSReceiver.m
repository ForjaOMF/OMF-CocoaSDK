//
//  SMS Receiver API
//  SMSReceiver.m
// 

#import "SMSReceiver.h"

@implementation SMS_Message

@synthesize phone,text;

- (id)copyWithZone:(NSZone *)zone
{
    SMS_Message *copy = [[self class] allocWithZone: zone];
	copy.phone =[self phone];
	copy.text = [self text];
	return copy;
}

@end

@implementation SMSReceiver

#define USE_SSL      NO
#define MECHANISM    @"none"  // use "none" for normal POP3 authentication

- (void) setup: (NSString*) pop3server port: (int) pop3port user: (NSString*) pop3user password: (NSString*) pop3password {
	_pop3 = [[CWPOP3Store alloc] initWithName: pop3server port: pop3port];
	user_account = pop3user;
	password_account = pop3password;
	[_pop3 setDelegate: self];
}

- (void) start {
	[_pop3 connectInBackgroundAndNotify];
}


- (void) authenticationCompleted: (NSNotification *) theNotification
{
	[[_pop3 defaultFolder] prefetch];
}

- (void) authenticationFailed: (NSNotification *) theNotification
{
	[_pop3 close];
}

- (void) connectionEstablished: (NSNotification *) theNotification
{
	
	if (USE_SSL)
    {
		[(CWTCPConnection *)[_pop3 connection] startSSL];
    }
}

- (void) connectionTerminated: (NSNotification *) theNotification
{
	RELEASE(_pop3);
}


- (void) folderPrefetchCompleted: (NSNotification *) theNotification
{
	CWPOP3Folder *folder = [_pop3 defaultFolder];
	[folder setShowRead:YES];
	count = [folder numberOfUnreadMessages];
	count = count - 1;
	emails = count;
	SMS_list = [NSMutableArray new];
	while (count > 0)
    {
		[[[[_pop3 defaultFolder] allMessages] objectAtIndex:count] setInitialized: YES];
		count = count - 1;
    }
}


- (void) messagePrefetchCompleted: (NSNotification *) theNotification
{
	NSString *mobile, *text_message;
	CWMessage *aMessage;
	aMessage = [[theNotification userInfo] objectForKey: @"Message"];
	NSString *subject;
	subject = [aMessage subject];
	if ([subject compare:@"OPEN SMS"] == NSOrderedSame) {
		NSString *message = [NSString stringWithCString:[[aMessage rawSource] cString]];
		NSRange range;
		NSString *temp;
		temp = @"Movil:";
		range = [message rangeOfString:temp];
		if (range.length != 0) {
			//Get mobile number
			mobile = [message substringFromIndex:range.location+6];
			temp = @"Texto";
			range = [mobile rangeOfString:temp];
			mobile = [mobile substringToIndex:range.location];
			//Get text
			range = [message rangeOfString:temp];
			text_message = [message substringFromIndex:range.location+6];
			//Add SMS Message to the list
			SMS_Message *SMS = [[SMS_Message alloc] init];
			SMS.text = text_message;
			SMS.phone = mobile;
			[SMS_list addObject:SMS]; 
		}
	}
	emails = emails - 1;
	if (emails == 0) {
		[_delegate receptionFinished:SMS_list];
		[_pop3 close];
	}
}

- (void) serviceInitialized: (NSNotification *) theNotification
{
	if (USE_SSL)
    {
		NSLog(@"SSL handshaking completed.");
    }
	
	NSLog(@"Available authentication mechanisms: %@", [_pop3 supportedMechanisms]);
	[_pop3 authenticate: user_account password: password_account  mechanism: @"none"];
}

- (void) setDelegate: (id) theDelegate {
	_delegate = theDelegate;
}

@end
