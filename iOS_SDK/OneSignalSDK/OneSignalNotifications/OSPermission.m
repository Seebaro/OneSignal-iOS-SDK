/**
 * Modified MIT License
 *
 * Copyright 2017 OneSignal
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * 1. The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * 2. All copies of substantial portions of the Software may only be used in connection
 * with services provided by OneSignal.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "OSPermission.h"
#import <OneSignalCore/OneSignalCore.h>
#import "OSNotificationsManager.h"

@implementation OSPermissionStateInternal

- (ObservablePermissionStateType*)observable {
    if (!_observable)
        _observable = [OSObservable new];
    return _observable;
}

- (instancetype)initAsTo {
    [OSNotificationsManager.osNotificationSettings getNotificationPermissionState];
    
    return self;
}

- (instancetype)initAsFrom {
    let standardUserDefaults = OneSignalUserDefaults.initStandard;
    _hasPrompted = [standardUserDefaults getSavedBoolForKey:OSUD_WAS_PROMPTED_FOR_NOTIFICATIONS_FROM defaultValue:false];
    _answeredPrompt = [standardUserDefaults getSavedBoolForKey:OSUD_WAS_NOTIFICATION_PROMPT_ANSWERED_FROM defaultValue:false];
    _accepted  = [standardUserDefaults getSavedBoolForKey:OSUD_PERMISSION_ACCEPTED_FROM defaultValue:false];
    _ephemeral = [standardUserDefaults getSavedBoolForKey:OSUD_PERMISSION_EPHEMERAL_FROM defaultValue:false];
    _provisional = [standardUserDefaults getSavedBoolForKey:OSUD_PROVISIONAL_PUSH_AUTHORIZATION_FROM defaultValue:false];
    _providesAppNotificationSettings = [standardUserDefaults getSavedBoolForKey:OSUD_APP_PROVIDES_NOTIFICATION_SETTINGS defaultValue:false];
    
    return self;
}

- (void)persistAsFrom {
    let standardUserDefaults = OneSignalUserDefaults.initStandard;
    [standardUserDefaults saveBoolForKey:OSUD_WAS_PROMPTED_FOR_NOTIFICATIONS_FROM withValue:_hasPrompted];
    [standardUserDefaults saveBoolForKey:OSUD_WAS_NOTIFICATION_PROMPT_ANSWERED_FROM withValue:_answeredPrompt];
    [standardUserDefaults saveBoolForKey:OSUD_PERMISSION_ACCEPTED_FROM withValue:_accepted];
    [standardUserDefaults saveBoolForKey:OSUD_PERMISSION_EPHEMERAL_FROM withValue:_ephemeral];
    [standardUserDefaults saveBoolForKey:OSUD_PROVISIONAL_PUSH_AUTHORIZATION_FROM withValue:_provisional];
    [standardUserDefaults saveBoolForKey:OSUD_APP_PROVIDES_NOTIFICATION_SETTINGS withValue:_providesAppNotificationSettings];
}


- (instancetype)copyWithZone:(NSZone*)zone {
    OSPermissionStateInternal* copy = [[self class] new];
    
    if (copy) {
        copy->_hasPrompted = _hasPrompted;
        copy->_answeredPrompt = _answeredPrompt;
        copy->_accepted = _accepted;
        copy->_ephemeral = _ephemeral;
        copy->_provisional = _provisional;
        copy->_providesAppNotificationSettings = _providesAppNotificationSettings;
    }
    
    return copy;
}

- (void)setHasPrompted:(BOOL)inHasPrompted {
    BOOL last = self.hasPrompted;
    _hasPrompted = inHasPrompted;
    if (last != self.hasPrompted)
        [self.observable notifyChange:(OSPermissionState*)self];
}

- (BOOL)hasPrompted {
    // If we know they answered turned notificaitons on then were prompted at some point.
    if (self.answeredPrompt) // self. triggers getter
        return true;
    return _hasPrompted;
}

- (BOOL)reachable {
    return self.provisional || self.accepted || self.ephemeral;
}

- (void)setProvisional:(BOOL)provisional {
    BOOL previous = _provisional;
    _provisional = provisional;
    
    if (previous != _provisional)
        [self.observable notifyChange:(OSPermissionState*)self];
}

- (BOOL)isProvisional {
    return _provisional;
}

- (void)setAnsweredPrompt:(BOOL)inansweredPrompt {
    BOOL last = self.answeredPrompt;
    _answeredPrompt = inansweredPrompt;
    if (last != self.answeredPrompt)
        [self.observable notifyChange:(OSPermissionState*)self];
}

- (BOOL)answeredPrompt {
    // If we got an accepted permission then they answered the prompt.
    if (_accepted)
        return true;
    return _answeredPrompt;
}

- (void)setAccepted:(BOOL)accepted {
    BOOL changed = _accepted != accepted;
    _accepted = accepted;
    if (changed)
        [self.observable notifyChange:(OSPermissionState*)self];
}

- (void)setEphemeral:(BOOL)ephemeral {
    BOOL changed = _ephemeral != ephemeral;
    _ephemeral = ephemeral;
    if (changed)
        [self.observable notifyChange:(OSPermissionState*)self];
}

- (void)setProvidesAppNotificationSettings:(BOOL)providesAppNotificationSettings {
    _providesAppNotificationSettings = providesAppNotificationSettings;
}

- (OSNotificationPermission)status {
    if (self.ephemeral)
        return OSNotificationPermissionEphemeral;
    
    if (_accepted)
        return OSNotificationPermissionAuthorized;
    
    if (self.answeredPrompt)
        return OSNotificationPermissionDenied;
    
    if (self.provisional)
        return OSNotificationPermissionProvisional;
    
    return OSNotificationPermissionNotDetermined;
}

- (OSPermissionState *)getExternalState {
    return [[OSPermissionState alloc] initWithPermission:self.reachable];
}

- (NSString*)description {
    static NSString* format = @"<OSPermissionStateInternal: hasPrompted: %d, status: %@, provisional: %d>";
    return [NSString stringWithFormat:format, self.hasPrompted, self.status, self.provisional];
}



@end

@implementation OSPermissionState
    
- (instancetype)initWithPermission:(BOOL)permission {
    _permission = permission;
    return self;
}

- (NSString*)description {
    static NSString* format = @"<OSPermissionState: permission: %d>";
    return [NSString stringWithFormat:format, self.permission];
}

- (NSDictionary*)jsonRepresentation {
    return @{@"permission": @(self.permission)};
}

@end
@implementation OSPermissionChangedInternalObserver

- (void)onChanged:(OSPermissionStateInternal*)state {
    [OSPermissionChangedInternalObserver fireChangesObserver:state];
}

+ (void)fireChangesObserver:(OSPermissionStateInternal*)state  {
    OSPermissionState *externalToState = [state getExternalState];
    OSPermissionState *externalFromState = [OSNotificationsManager.lastPermissionState getExternalState];
    
    if (externalToState.permission == externalFromState.permission) {
        return;
    }
    
    BOOL hasReceiver = [OSNotificationsManager.permissionStateChangesObserver notifyChange:externalToState];
    if (hasReceiver) {
        OSNotificationsManager.lastPermissionState = [state copy];
        [OSNotificationsManager.lastPermissionState persistAsFrom];
    }
    // Update the push subscription's _accepted property
    // TODO: This can be called before the User Manager has set itself as the delegate
    if (OSNotificationsManager.delegate && [OSNotificationsManager.delegate respondsToSelector:@selector(setAccepted:)]) {
        [OSNotificationsManager.delegate setAccepted:state.reachable];
    }
}

@end
