# BRIDGE Rider iOS
A homemade ride-sharing solution for schools to organize safer and more efficient carpooling.

BRIDGE is a company that bridges students and schools, by providing a trustworthy and reliable ride sharing service for students between their homes and schools. On top of this, BRIDGE develops educational fundraising initiatives by cooperating with schools and donating a part of our sales with them. Lastly, BRIDGE improves the current situation of traffic during morning and afternoon hours, creating a sustainable environment by reducing the number of vehicles on the road.

### THIS VERSION HAS BEEN DISCONTINUED!
#### Please refer to the new Bridge Rider Project [here](https://github.com/equinox-initiative/bridge-rider-flutter).

Only fork and build this version if you are a part of the BRIDGE Canary Program, and have been instructed to do so. Instructions for properly building this repository are below. If you would like to learn how you can join the BRIDGE Canary Program, check if you are eligible [here](https://github.com/BK1031/BRIDGE-Rider-ios/blob/master/CANARY.md).

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

## Issue/Feature Requests

The best way to provide contructive feedback is through GitHub itself. Create a new issue on the [Issue Tab](https://github.com/BK1031/BRIDGE-Rider-ios/issues). Then specify whether you are adding a bug, or requesting a new feature enhancement. Follow the guidelines below:

**Bugs:**
- Include what version of the app you are using, either through the commit id, or the TestFlight Version.
- Give a description of what the bug is (e.g. what went wrong). Please be as descriptive as possible
- Explain the steps you took that led to the bug. This will help us to recreate the bug and take steps to fix it

**Enhancements:**
- Give a description of the enhancement that you are requesting. What does it do? Why do we need it? Be as descriptive as possible.

Make sure to add additional labels based on what you are asking for. For example, if you are requesting a new feature that automatically selects the destination, then add the "Enhancement" label as well as the "Ride Request Algorithm" label.

After you are done, make sure to add the issue to the BRIDGE Rider iOS Project Board.

## License

[Restricted BSD 3-Clause License](https://github.com/BK1031/BRIDGE-Rider-ios/blob/master/LICENSE)

## Contributors

- Bharat Kathi  ***CTO BRIDGE LLC***
    - App Development
    - Database Infrastructure
- Myron Chan ***CEO BRIDGE LLC***
    - Storyboard Design
    - Icon Design
    - Logo Design
- Kashyap Chaturvedula
    - Moral Suport

###### *Powered By*
[![IMAGE ALT TEXT HERE](https://github.com/bharat1031/BRIDGE-app/blob/master/Firebase.png)](https://bridgeridesharing-app.firebaseio.com)
