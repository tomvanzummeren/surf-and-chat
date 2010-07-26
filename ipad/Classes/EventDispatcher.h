#import "MessengerService.h"
#import "TargetActionPair.h"

@interface EventDispatcher : NSObject {

@private
	MessengerService *messengerService;
	
	BOOL dispatching;
	
	NSMutableDictionary *eventTargetActionPairs;
}

+ (EventDispatcher *) sharedInstance;

- (void) startDispatching;

- (void) stopDispatching;

- (void) registerTarget:(id) target action:(SEL) action forEvent:(Class) eventType;

- (void) unregisterAllEventsForTarget:(id) target;

@end
