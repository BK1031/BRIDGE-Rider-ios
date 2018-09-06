# BRIDGE Rider iOS
A homemade ride-sharing solution for schools to organize safer and more efficient carpooling.

BRIDGE is a company that bridges students and schools, by providing a trustworthy and reliable ride sharing service for students between their homes and schools. On top of this, BRIDGE develops educational fundraising initiatives by cooperating with schools and donating a part of our sales with them. Lastly, BRIDGE improves the current situation of traffic during morning and afternoon hours, creating a sustainable environment by reducing the number of vehicles on the road.

This repository contains the canary version of the BRIDGE Rider app. This is not intended for public use. The most stable version of the BRIDGE Driver and Rider apps are on the App Store, and are recommended for regular use.

Only fork and build this version if you are a part of the BRIDGE Canary Program, and have been instructed to do so. Instructions for properly building this repository are below.

You can find updates on my twitter here: [@BK1031_OFFICIAL](https://twitter.com/BK1031_OFFICIAL)

## Instructions for Building BRIDGE App Beta

***Note: You will need a Macintosh or device running MacOS to proceed***

Fork the repository.

You will need to have CocoaPods installed for this app to run. Luckily, it is very easy to install if you don't aldready have it.

`$ sudo gem install cocoapods`

Navigate to the folder where you forked the repository. You should see something like this.

![alt text](https://github.com/BK1031/ImageAssets/blob/master/Screen%20Shot%202018-09-05%20at%204.56.55%20PM.png "BRIDGE Project in Finder")

Make sure that you see the Podfile in the folder. Then navigate to that same folder, but via terminal this time. You can use the command `ls` to verify that you are in the correct directory.

![alt text](https://github.com/BK1031/ImageAssets/blob/master/Screen%20Shot%202018-09-05%20at%204.53.33%20PM.png "BRIDGE-Rider-ios Project in Terminal")

Once you are in this directory install the Podfile with the following command.

`$ pod install`

Your terminal output should look something like the following.

![alt text](https://github.com/BK1031/ImageAssets/blob/master/Screen%20Shot%202018-09-05%20at%204.54.28%20PM.png "Pod Install in Terminal")

Now, go ahead and open the *BRIDGE-Rider.xcworkspace*. Make sure you open this and **not** the *BRIDGE-Rider.xcodeproj*. Build the project to make sure that no errors occur.

You now have the Canary Release of the BRIDGE Rider App that you can sideload onto your device!

*If there are any issues, feel free to let us know by creating a new issue report.*

###### *Powered By*
[![IMAGE ALT TEXT HERE](https://github.com/bharat1031/BRIDGE-app/blob/master/Firebase.png)](https://bridgeridesharing-app.firebaseio.com)
