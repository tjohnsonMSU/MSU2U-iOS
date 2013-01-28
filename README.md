MSU2U-iOS
=========

How to use:

1. Create a folder somewhere on your computer to store the project. 'mkdir MSU2U-iOS' for example.
2. Create a local repository in that folder by navigating to it using the Terminal and typing the command 'git init'.
3. Make sure you are currently in the directory you created in step 1 and clone the project to your computer by typing the following command:
    git clone --recursive git://github.com/tjohnson1965/MSU2U-iOS.git

The above command will download all of the MSU2U-iOS files and also the ShareKit Submodule files which are necessary for the project to compile and run properly. Downloading the project using the ZIP format will be missing the ShareKit submodule folder contents.

4. In order for the Share functionality to work in the app, consult the folder 'Share API Keys/Code' from the MSU2U Dropbox account and copy the DefaultSHKConfigurator.m file into the project. By default, this file already exists in the project but it does not have the API keys entered, so it is simply a template. If you have no desire to use the Share functionality, you don't need to add this file or worry about filling in the API keys.

5. If there are any questions regarding the project, please notify either Matthew Farmer (matthew.farmer@mwsu.edu) or Dr. Tina Johnson (tina.johnson@mwsu.edu). Comments/questions may also be left within GitHub.
