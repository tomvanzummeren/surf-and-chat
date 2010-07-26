@class MsnContact;
@class ChatDialogController;

@protocol ChatDialogControllerDelegate <NSObject>

- (void) closeWindow:(MsnContact *) contact;

- (void) newMessageReceived:(ChatDialogController *) controller;

@end
