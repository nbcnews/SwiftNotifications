# SwiftNotifications

SwiftNotifications is a Swift framework providing a strong typed wrapper around the functionality of NotificationCenter.


## Installation
#### Carthage

To install SwiftNotifications using Carthage, add `github "nbcnews/SwiftNotifications"` to your Cartfile, then follow [these steps](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

## Defining notifications

Before notification can be sent or received, it needs to be defined. Notifications are defined by creating struct (or class) conforming to either`CodableNotification`, `PostableNotification` or `ObservableNotification` protocols.

### Definig notification using `CodableNotification`

Conforming to `CodableNotification` is the simplest way to define notification:
```swift
struct MyNotification: CodableNotification {
  let intValue: Int
  let stringValue: String
  let structValue: MyStruct
  let classValue: MyClass
}
```
Notification can be empty if no additional information needs to be provided:
```swift
struct MyEmptyNotification: CodableNotification {
}
```

### Defining notification using `PostableNotification` or `ObservableNotification`
One limitation of `CodableNotification` is that all stored properties must support the `Codable` protocol. In some situations 
that is not possible. In this case, you can implement `PostableNotification` protocol for notifications that can be posted, or 
`ObservableNotification` for notification that can be observed but not posted.

`ObservableNotification` must implement `init?(notification:)`
```swift
struct MyNotification: ObservableNotification {
  let value: NonCodableType
  
  init?(notification: Notification) {
    guard userInfo = notification.userInfo else {
      return nil
    }
    guard let value = userInfo["valueKey"] as? NonCodableType else {
      return nil
    }
    self.value = value
  }
}
```
`PostableNotification` in addition to `init` sould also implement `var userInfo: [AnyHashable: Any]?`:
```swift
struct MyNotification: PostableNotification {
  let value: NonCodableType
  
  var userInfo: [AnyHashable: Any]? {
    return ["valueKey": value]
  }
  
  init?(notification: Notification) {
    guard userInfo = notification.userInfo else {
      return nil
    }
    guard let value = userInfo["valueKey"] as? NonCodableType else {
      return nil
    }
    self.value = value
  }
}
```

### Custom names
By default, notification name is the name of the struct combined with the module name. For example, notification `struct MyNotification` located in a module named `MyModule` will have the name `MyModule.MyNotification`. But sometimes it is
necessary to define the notification name to be different from struct's name. It can be done by defining the static property 
`name` in you notification
```swift
struct MyNotification: ObservableNotification {
  static let name = "MySpecialNotificationName"
}
```

## Sending notifications
Sending a notification is as simple as calling `post()` method on a notification object
```swift
Mynotification().post()
```
You can send notification to custom `NotificationCenter`
```swift
Mynotification().post(notificationCenter)
```
Send notification with information about sender
```swift
Mynotification().post(from: object)
```

## Receiving notifications
```swift
class Listener {
    let observer = NotificationObserver<MyNotification>()
    
    init() {
        observer.observe(self, Listener.handleNotification)
    }
    
    func handleNotification(notification: MyNotification) {
        ...
    }
}
```
## Stopping notifications
In most cases, no special action is needed to stop receving notifications because notifications will stop automaticaly when `NotificationObserver` is released. In cases that more precise control is required, notifications can be stoped by calling `remove()` method of `NotificationObserver`
```swift
observer.remove()
```
