![image](https://github.com/ZhangHexiao/RambleApp/blob/master/images/RambleIcon.png)


# Ramble

> Ramble will develop the leading experience discovery platform, allowing anyone to easily partake in activities they love, created by passionate people.

> Creators upload one-of-a-kind experiences to the Ramble Creator App

> Users can instantly select from a wide array of unique experiences

**My responsibility**

- Working as the only iOS developer in the team, responsible for translating concept design into user interface compatible with various generations of iPhone, and designed application screen flows -- using UITableView, UICollectionVIew, UITapGestureRecognizer
- Managed the full development and distribution life cycle of two enterprise iOS apps -- Ramble and Ramble Creator
- Designed SQL database -- using Parse user registration or Facebook API to log in
- Configured Server on back-end -- using Parse Server and cloud functions to manage payment, updating available tickets, sending remote notification
- Real-time Chatting system -- using Parse Live-Query, MessageKit
- Payment system -- Users transact with the Ramble, which enable Creators claim transferred funds after the events; configured Stripe pod on front-end and Stripe API on server-side; set up QR Code sending for tickets verification; set up verification code for securely claiming fund using Twilio
- Rating system -- push review reminder to user after experience
- Notification system -- seting up UNUserNotificationCenter and server to push local and remote notification
- Configured various third-party API to customize the service for users -- MapBox and Google Place Service for discovering event, smart input TextField, and so on. 


[![INSERT YOUR GRAPHIC HERE](https://github.com/ZhangHexiao/RambleApp/blob/master/images/contribution.jpeg)]()

[![Build Status](http://img.shields.io/travis/badges/badgerbadgerbadger.svg?style=flat-square)](https://travis-ci.org/badges/badgerbadgerbadger) [![Dependency Status](http://img.shields.io/gemnasium/badges/badgerbadgerbadger.svg?style=flat-square)](https://gemnasium.com/badges/badgerbadgerbadger) [![Coverage Status](http://img.shields.io/coveralls/badges/badgerbadgerbadger.svg?style=flat-square)](https://coveralls.io/r/badges/badgerbadgerbadger)[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

---
## Applied Development Paradigms

- Asynchronous programming to deal with order and fund transfer
- Multi-threading to update tableView and collectionView and work with thrid-party API
- Cocoa design patterns, such as MVC, Singleton, Delegate, Observer and Notification 
- UI transitions, such as Present, Navigation, Child Controller
- Image processing, using AWS service and S3 Adapter
- Network & socket programming for chatting system
- Integrating third-party libraries (e.g. Stripe Facebook, etc.) on server-side using Node.js according to documents
---
## New Added Features

***Version 3 Upate***
- Update design in Main page / Experience Detail page / Payment page / Date selection page

[![INSERT YOUR GRAPHIC HERE](https://github.com/ZhangHexiao/RambleApp/blob/master/images/version3.png)]()



**Home Page, Detail Page, Payment page**

![Recordit GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/version3Homepage.gif)
![Recordit GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/version3PaymentPaypage.gif)
![Recordit GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/mapFeature.gif)

> Detail
- Embeded Collection View in Custom Table View Cell to display discovered experience
- Added animation hiding the navbar when scroll down
- Displayed experiences sorted by categories
- Added slide-up menu to select date

---

***Version 2 Upate***
- Added search experience locally and remotely
- Built in-app Chatting system
- Built payment system
- Built rating system after attending experience

**Search local and remote Experience(Events)**

![Search GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/SearchAndLocation.gif)

> Enabled Users to search local and remote Experience(Events) by changing city or searching places
- Worked on Google Places, iPhone Privacy and Location Service
- Allowed User to search expericence from database sorting based on distance and date

**Real-time Chatting System**

![Chatting GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/chatting.gif)

> Real-time chatting system
- Used MessageKit on front-end
- Used Parse Live-query
- Set up UNUserNotificationCenter and server to push local and remote notification

**Booking and Payment System**

***Enabled Users to book experience on Ramble App***

![Payment GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/PaymentUser.gif)

***Enabled Creators to claim their income gained by selling tickets on Ramble Creator App***

![Payment GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/PaymentCreator.gif)

> Booking and payment system

- Allowed Users transact with the Ramble, which also enable Creators claim transferred funds after the events
- Configured Stripe pod on front-end and Stripe API on server-side
- Set up QR Code sending and checking for tickets verification 
- Set up verification code check for securely claiming fund using Twilio

**Rating System**

![Rating GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/RatingSystem.gif)

> Rating System

- Built the dynamic UI for rating page
- Set up the local notification to remind User to rate two hour after the end of experience

---

## pods

```swift
// pods to install

 pod 'Parse'
  pod 'FBSDKCoreKit'
  pod 'Parse/FacebookUtils'
  
  # Location
  pod 'Mapbox-iOS-SDK', '5.2'
  pod 'MapboxGeocoder.swift', '~> 0.10'
  pod 'GooglePlaces', '3.0.0'
  
  # Logic
  pod 'PromiseKit', '6.2.6'
  pod 'SDWebImage', '4.4.1'
  pod 'Stripe'
  
  # UI
  pod 'SVProgressHUD'
  pod 'IQKeyboardManagerSwift'
  pod 'JVFloatLabeledTextField', :git => 'https://github.com/ThiagoOrniz/JVFloatLabeledTextField.git'
  
  pod 'TOCropViewController', '2.3.6'
  pod 'BSStackView', '1.0.0'
  pod 'DTPhotoViewerController', '1.2.4'
  # Message System
  pod 'MessageKit'
  pod 'ParseLiveQuery'
  # Message Calender
  pod 'JTAppleCalendar', '~> 7.1.7'
```
---

## Test

```swift
// set to Config file
// for connecting the gurana server/development database
//        private static let devUrl = "https://**********************/parse"
// Test on simulator, for connecting the localhost server/development database
        private static let devUrl = "http://localhost:1337/parse"
// Test on real device and Connect the remote ngrok server/development database
//        private static let devUrl = "http://*************.ngrok.io/parse"
```

---

## Documentation (To be done)

---
