![alt tag](https://github.com/snowpunch/AppLove/blob/master/apploveicon.png?raw=true) 
![alt tag](https://github.com/qianyu09/AppLove/blob/master/0.png?raw=true) 
![alt tag](https://github.com/qianyu09/AppLove/blob/master/0.png?raw=true) 
![alt tag](https://github.com/qianyu09/AppLove/blob/master/0.png?raw=true) 
# App Love

[Download from the App store](https://itunes.apple.com/us/app/app-love/id1099336831?mt=8)


## Features
- **Utility App** that shows **ALL iOS Customer Reviews** for any app, across **ALL territories**.
- You can config which territories to download from.
- Language **translations** possible.

## The App's main Challenge
- **Huge data:**  155 territories, with each up to 10 pages of JSON and/or XML data. 
- So a **long download** if you select lots of territories and/or the app is popular.
- Needs an **interesting and informative progress bar** to deal with apps that have either too much data or not much at all.
- Servers tend to block if too much activity.
- All pages need to be downloaded at once. For this particular app we are not interested in just the latest reviews.

## The App Solution
- **Show each territory** as it's own little loader bar. **Color coded** to reflect errors, and quantity of downloads.
- **Blue** means 1-49 reviews **(1 page)** - helps show up better for apps with less reviews.
- **Black** means 50-500 reviews **(2 - 10 pages)** - scales up for the more successful apps.
- You need to download reviews for a really popular app (ie:Twitter) to get a full sense of the loader capabilities.
- If servers block in any territory from a JSON call, then flash red and switch to calling data via XML call. If both fail then stay red.
 
## Cocoapods used
- AlmoFire
- SwiftyJSON
- SDWebImage
- **SwiftyGlyphs** [Awesome CocoaPod!](https://github.com/snowpunch/SwiftyGlyphs)

## Installation

- Open terminal and navigate to directory with 'podfile'.
- Run **'pod install'**
- Then **open app via xcworkspace** (not xcodeproj) - as per normal cocoaPod using apps.

## Author & licence

- Woodie Dovich,  woodiewebsafe@gmail.com
- App Love is available under the MIT license. See the LICENSE file for more info.
