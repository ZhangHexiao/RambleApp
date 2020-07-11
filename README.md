![image](https://github.com/ZhangHexiao/RambleApp/blob/master/images/RambleIcon.png)


# Ramble

> Ramble will develop the leading experience discovery platform, allowing anyone to easily partake in activities they love, created by passionate people.

> Creators upload one-of-a-kind experiences to the Ramble Creator App

> Users can instantly select from a wide array of unique experiences

**My responsibility**

- Working as the only iOS developer in the team
- Managed the full development and distribution life cycle of two enterprise iOS apps -- Ramble and Ramble Creator
- Translated concept design into user interface compatible with various generations of iPhone, and designed application screen flows -- UITableView, UICollectionVIew, UITapGestureRecognizer
- Designed SQL database -- using Parse, Facebook API for logging
- Configured back-end Server -- using Parse Server and cloud functions to manage payment, updating available tickets, sending notification
- Real-time Chatting system -- using Parse Live-Query, MessageKit framework
- Payment system -- Users transact with the Ramble, which enable Creators claim transferred funds after the events; configured Stripe pod on front-end and Stripe API on server-side; send QR Code for tickets verification; send verification code for securely claiming fund using Twilio
- Notification system -- seting up UNUserNotificationCenter and server to push local and remote notification
- Rating system -- push review reminder to user after experience
- Configured various third-party API to customize the service for users -- MapBox and Google Place Service for discovering event, smart input TextField, and so on. 


[![Build Status](http://img.shields.io/travis/badges/badgerbadgerbadger.svg?style=flat-square)](https://travis-ci.org/badges/badgerbadgerbadger) [![Dependency Status](http://img.shields.io/gemnasium/badges/badgerbadgerbadger.svg?style=flat-square)](https://gemnasium.com/badges/badgerbadgerbadger) [![Coverage Status](http://img.shields.io/coveralls/badges/badgerbadgerbadger.svg?style=flat-square)](https://coveralls.io/r/badges/badgerbadgerbadger)[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

---
## Applied Development Paradigms

- Asynchronous programming to deal with order and fund transfer
- Multi-threading to update tableView and collectionView
- UI transitions, such as Present, Navigation, Child Controller
- Image processing, using AWS service and S3 Adapter
- Network & socket programming for chatting system
- SQL database design and optimization
- Integrating third-party libraries (e.g. Stripe Facebook, etc.) on server-side using Node.js
---
## New Added Features

***Version 3 Upate***
- Main page * Experience Detail page * Payment page * Date selection page

[![INSERT YOUR GRAPHIC HERE](https://github.com/ZhangHexiao/RambleApp/blob/master/images/version3.png)]()



**Home Page, Detail Page, Payment page**

![Recordit GIF](http://g.recordit.co/iLN6A0vSD8.gif)

> Detail
- Embeded Collection View in Custom Table View Cell to display discovered experience
- Added animation hiding the navbar when scroll down
- Displayed experiences sorted by categories
- Added slide-up menu to select date

---

***Version 2 Upate***
- Added search experience locally and remotely(change city)
- Built in-app Chatting system
- Built payment system
- Built rating system after attending experience

**Search local and remote Experience(Events)**

![Search GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/SearchAndLocation.gif)

> Search local and remote Experience(Events)
- Worked on Google Places, iPhone Privacy and Location Service
- Searched expericence from database and sorted based on distance and date

**Real-time Chatting System**

![Chatting GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/chatting.gif)

> Real-time chatting system
- Used MessageKit
- Used Parse Live-query
- Set up UNUserNotificationCenter and server to push local and remote notification

**Booking and Payment System**

***Enabled Users to book experience on Ramble App***

![Payment GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/PaymentUser.gif)

***Enabled Creators to claim their income gained by selling tickets on Ramble Creator App***

![Payment GIF](https://github.com/ZhangHexiao/RambleApp/blob/master/images/PaymentCreator.gif)

> Booking and payment system

- Allowed Users transact with the Ramble, which enable Creators claim transferred funds after the events
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

## Features
## Usage (Optional)
## Documentation (Optional)
## Tests (Optional)

- Going into more detail on code and technologies used
- I utilized this nifty <a href="https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet" target="_blank">Markdown Cheatsheet</a> for this sample `README`.

---

## Contributing

> To get started...

### Step 1

- **Option 1**
    - 🍴 Fork this repo!

- **Option 2**
    - 👯 Clone this repo to your local machine using `https://github.com/joanaz/HireDot2.git`

### Step 2

- **HACK AWAY!** 🔨🔨🔨

### Step 3

- 🔃 Create a new pull request using <a href="https://github.com/joanaz/HireDot2/compare/" target="_blank">`https://github.com/joanaz/HireDot2/compare/`</a>.

---

## Team

> Or Contributors/People

| <a href="http://fvcproductions.com" target="_blank">**FVCproductions**</a> | <a href="http://fvcproductions.com" target="_blank">**FVCproductions**</a> | <a href="http://fvcproductions.com" target="_blank">**FVCproductions**</a> |
| :---: |:---:| :---:|
| [![FVCproductions](https://avatars1.githubusercontent.com/u/4284691?v=3&s=200)](http://fvcproductions.com)    | [![FVCproductions](https://avatars1.githubusercontent.com/u/4284691?v=3&s=200)](http://fvcproductions.com) | [![FVCproductions](https://avatars1.githubusercontent.com/u/4284691?v=3&s=200)](http://fvcproductions.com)  |
| <a href="http://github.com/fvcproductions" target="_blank">`github.com/fvcproductions`</a> | <a href="http://github.com/fvcproductions" target="_blank">`github.com/fvcproductions`</a> | <a href="http://github.com/fvcproductions" target="_blank">`github.com/fvcproductions`</a> |

- You can just grab their GitHub profile image URL
- You should probably resize their picture using `?s=200` at the end of the image URL.

---

## FAQ

- **How do I do *specifically* so and so?**
    - No problem! Just do this.

---

## Support

Reach out to me at one of the following places!

- Website at <a href="http://fvcproductions.com" target="_blank">`fvcproductions.com`</a>
- Twitter at <a href="http://twitter.com/fvcproductions" target="_blank">`@fvcproductions`</a>
- Insert more social links here.

---

## Donations (Optional)

- You could include a <a href="https://cdn.rawgit.com/gratipay/gratipay-badge/2.3.0/dist/gratipay.png" target="_blank">Gratipay</a> link as well.

[![Support via Gratipay](https://cdn.rawgit.com/gratipay/gratipay-badge/2.3.0/dist/gratipay.png)](https://gratipay.com/fvcproductions/)


---

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- Copyright 2015 © <a href="http://fvcproductions.com" target="_blank">FVCproductions</a>.
