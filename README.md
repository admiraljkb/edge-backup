# edge-backup

AutoIT3 Windows Utility to backup your Garmin Edge or Forerunner based product.

This script is in AutoIT3, version v3.3.14.5 (also works with 3.3.15.3 beta).  Downloadable here:  <https://www.autoitscript.com/site/autoit/downloads/>

(rough instructions follow)

Instructions:

* Option 1 - To simply run, pull this repo down local, and then right click on `Run Script`.  (have to have AutoIT3 installed)
* Option 2 - Download the already compiled EXE from the [release page](https://github.com/admiraljkb/edge-backup/releases).  The EXE is standalone and doesn't require anything else installed.

Restoration Instructions:
1. Plug Garmin into PC  ("x" below is the drive letter assigned to your Garmin EDGE or Forerunner)
1. Copy `.FIT` files to x:\Garmin\NewFiles
1. Copy `.PRG` files to x:\Garmin\Apps
1. Copy `.SET` files to x:\Garmin\Apps\SETTINGS

I created this because Garmin 1030 units seem to need a lot of hard resets after the 9.10 version firmware, reconfiguring them is quite a pain, and so is manually backing them up.

* Garmin - getting a working version of this util only took me roughly 4 hours.  Why couldn't y'all do it?  XOXO and all, but c'mon guys.  :)
* Used info provided from Garmin Support here: <https://support.garmin.com/en-MY/?faq=eWswdSH4aC3xrXxmQj7U9A>
* Add'l info provided by aweatherwall in this post: <https://forums.garmin.com/sports-fitness/cycling/f/edge-1030/224731/profile-backup-when-exchanging-unit> 

* Add'l credit where credit is due - Used the following two sample scripts as the base which turned this into childs play:

  * <https://www.autoitscript.com/forum/topic/190705-backup-your-files/>
  * <https://www.autoitscript.com/forum/topic/156196-log4a-a-logging-udf/>
