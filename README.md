# Common Framework for All Background Process to Notify Process Completion to the Users.
# Overview
To indicate the users about the completion of the long running background processes irrespective of the pages through notification. 

![](https://github.com/SridharThayumanavar/Background-Process/blob/main/Background%20Process%20Notification.gif)

# Features
-  Users able to know the background process status through notifications.
-  Common framework – Functionality implemented in Global page at one time, and it should be applicable to the entire application.
-  More than one background process statuses to be captured through notification and no need to stay in the page. 
-  All the status of the background process to be captured in notifications. For example, failed, terminated.

# Custom Attributes 

| S.No | Attribute Name | Functionality | Values |
| --- | --- | --- | --- | 
| 1 | Success Message | A Text area to enter the custom success message to be displayed. | For Expample : Executed Successfully! |
| 2 | Disable Page/Process Name | To hide the page name and Process name from the success message. | Yes/No |
| 3 | Enable Process Notifications |To enable process notification to the users until completes entire process. | Yes/No |

# Dynamic Action on Page Load 

![](https://github.com/SridharThayumanavar/Background-Process/blob/main/Plugin-Backend_screenshot.jpg)

1.	To check background process only for one page then dynamic action to be created on that page one time only. 
2.	To check background process for entire application then dynamic action to be created on global page.

[Demo](https://apex.oracle.com/pls/apex/r/digital_bid_suite/bg-process/home)
