<b>MSU2U-iOS</b>
<b>=========</b>

<b>About:</b>

MSU2U-iOS is an iOS application developed by students for Midwestern State University. The application seeks to provide a functional and convenient means of easily accessing faculty directories, news, maps, sports, campus events, social media, and other such information. The MSU2U project provides the student developers with a valuable experience in which fundamentals of mobile application development are learned in the context of a team environment.

An Android version of the application is also concurrently being developed, and may be found at https://github.com/MSU2U/MSU2U-Android.

<b>How to use:</b>

1. Create a folder somewhere on your computer to store the project. If using the Terminal, type 'mkdir MSU2U-iOS' for example.
2. Create a local repository in that folder by navigating to it using the Terminal and typing the command 'git init'. If git is not installed, open XCode, and in the Menu Bar click/navigate to the following XCode->Preferences->Downloads, and click on the 'Install' button next to the Command Line Tools which will install git and other useful command line tools.
3. Make sure you are currently in the directory you created in step 1 within the terminal and clone the project to your computer by typing the following command:
    git clone --recursive git://github.com/tjohnson1965/MSU2U-iOS.git

The above command will download all of the MSU2U-iOS files and also the ShareKit Submodule files which are necessary for the project to compile and run properly. Downloading the project using the ZIP format will be missing the ShareKit submodule folder contents.

4. In order for the Share functionality to work in the app, consult the folder 'Share API Keys/Code' from the MSU2U Dropbox account and copy the DefaultSHKConfigurator.m file into the project. By default, this file already exists in the project but it does not have the API keys entered, so it is simply a template. If you have no desire to use the Share functionality when working with or using the app, you don't need to add this file or worry about filling in the API keys.

5. If there are any questions regarding the project, please notify either Matthew Farmer (matthew.farmer@mwsu.edu) or Dr. Tina Johnson (tina.johnson@mwsu.edu). Comments/questions may also be left within GitHub.
