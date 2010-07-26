#import "EventDispatcher.h"

@implementation EventDispatcher

static EventDispatcher *sharedInstance = nil;

- (id) init {
	if (self = [super init]) {
		messengerService = [[MessengerService alloc] init];
		eventTargetActionPairs = [NSMutableDictionary dictionary];
		[eventTargetActionPairs retain];
	}
	return self;
}

- (void) startDispatching {
	if (dispatching) {
		return;
	}
	dispatching = YES;
	[self performSelectorInBackground:@selector(processIncomingEvents) withObject:nil];
	NSLog(@"Started receiving and dispatching events");
}

- (void) stopDispatching {
	dispatching = NO;
	NSLog(@"Stopped receiving and dispatching events");
}

- (void) registerTarget:(id) target action:(SEL) action forEvent:(Class) eventType {
	NSMutableArray *targetActionPairs = [eventTargetActionPairs objectForKey:eventType];
	if (!targetActionPairs) {
		targetActionPairs = [NSMutableArray array];
		[eventTargetActionPairs setObject:targetActionPairs forKey:eventType];
	}
	TargetActionPair *targetActionPair = [[TargetActionPair alloc] init];
	[targetActionPair setTarget:target];
	[targetActionPair setAction:action];
	[targetActionPairs addObject:targetActionPair];
}

- (void) unregisterAllEventsForTarget:(id) target {
	NSEnumerator *enumerator = [eventTargetActionPairs keyEnumerator];
	for (Class eventType in [enumerator allObjects]) {
		NSMutableArray *targetActionPairs = [eventTargetActionPairs objectForKey:eventType];
		for (TargetActionPair *pair in targetActionPairs) {
			if ([[pair target] isEqual:target]) {
				[targetActionPairs removeObject:target];
			}
		}
	}
}

#pragma mark -
#pragma mark Singleton

- (void) processIncomingEvents {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	while (dispatching) {
		NSArray *receivedEvents = [messengerService receiveEvents];
		if (!receivedEvents) {
			dispatching = NO;
		}
		for (id event in receivedEvents) {
			NSArray *targetActionPairs = [eventTargetActionPairs objectForKey:[event class]];
			NSArray *targetActionPairsCopy = [NSArray arrayWithArray:targetActionPairs];
			for (TargetActionPair *pair in targetActionPairsCopy) {
				[pair executeForEvent:event];
			}
		}
	}
	[pool release];
}

+ (EventDispatcher *) sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil;  // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    // do nothing
}

- (id)autorelease {
    return self;
}

@end
