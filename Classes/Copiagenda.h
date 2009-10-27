//
//  Copiagenda.h
//  Copiagenda Cocoa API
//

#import <Cocoa/Cocoa.h>


@interface Copiagenda : NSObject {

	@private
	CFReadStreamRef streamSMS;
	NSString * Cookie;
	NSString * Location;
	NSString * newPass;
	NSString * reauth;
	NSString * dataresponse;
	NSMutableArray *array;
	NSMutableDictionary *dictionary;
}
- (NSDictionary *) RetrieveContacts: (NSString *) login password: (NSString *) pass;
- (NSArray *) SearchByName: (NSString *) name contacts: (NSDictionary*) addressbook;
@end
