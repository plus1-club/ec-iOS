# iLoader
iLoader helps you to show Activity Loader/Indicator to inform your app user about something is going on. You can use iLoader while your app processing some data or fetching data using API calls, and so on.

## Setup Instructions

### Using [CocoaPods](https://cocoapods.org)
Install with CocoaPods by adding the following to your Podfile:

`pod 'iLoader'`

#### Basic Examples

- For simple loader:   
   `iLoader.shared.show()`

- To hide the loader:  
   `iLoader.shared.hide()`

#### To modify loader use following properties:

- To change to loader color:  
   `iLoader.shared.loaderTintColor = .red`

- To set the title:  
   `iLoader.shared.loaderTitle = "Loading..."`

- To set the title text color:  
   `iLoader.shared.loaderTitleTextColor = .red`

- To set the background color of loader:  
   `iLoader.shared.loaderBackgroundColor = .black`

- To hide the loader after some time interval:  
   `iLoader.shared.showForTimeInterval(timeInterval: 5)`
