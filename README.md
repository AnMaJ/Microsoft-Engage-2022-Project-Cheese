# Microsoft-Engage-2022-Project-Cheese
It is a flutter android app which uses face recognition api to find a lost child, and notifies the police and child's parents about the location, and the info of the user who found the lost child.

**Some sailent features of the app are as follows:**<br/>
## User Interface: 
 * It allows anyone to create an account by giving the following details:
    * Name
    * Phone Number
    * Email ID : Should be vaild, otherwise a snackbar will pop up showing that the email id entered is invalid. It should also be unique.
    * Password : It should be atleast 6 characters long otherwise a snackbar will pop up displaying the same.
 * Once the user signs in the user is asked to share its **location** (This is mandatory as it is one of the crucial information that will be passed on to the police and the child's parents if the child is found)
 * Then, on the home page there are 4 buttons, namely:
    * **Scan the lost child:** This page allows you to scan the piture of the lost child via two methods:
      * Use Camera (the front camera in your device): It will detect the face and will also guide you to put your face in the designated portion for proper detection. Once the face is detected, the picture is clicked automatically.
      * Use gallery: Let's say you were not able to take the image of the child with your front camera, or you had taken it some time earlier and the image is stored in your gallery, then you can utiize this option to select this image of the child.<br/>
    Once the image is selected, tap on **Search Lost Child** button to initiate the search. It will take some time to process the image and then will initiate the search with the images stored in the database. If a match is found, **an email will be automatically sent to the child's parents and the police, with the current location of the user and all the other user details except its password** a screenshot of the eamils sent are given below:<br/>
    ### Police Email
   <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/Police_email.png" alt="login" width="" height="500" /> <br/>
   ### Parent Email
   <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/Parent_email.png" alt="login" width="" height="500" /> <br/>
    * **How to use:** It provides a user manual.
    * **Settings:** It facilitates the user to change its registered phone number and password.
    * **Logout:** Logs the user out of the console.

## Police Interface
  * The police station will be registered using the same signup page as that for normal users, but they will be given a security code from our side (In this case there is only one police station registered with the following credentials: **Email Id: mansi122@gamil.com Password: uwu1221 Security Code: 123456** )
  * The police has to use **Login as Police** button to login and then enter the security code to login.
  * On the repoting page, the police is supposed to enter the details of the lost child and upload its picture and then hit Upload File button to add the child to the lost child database.
      

# Cheese

A face recognition app which facilitates faster and hassale free reprting of a lost child to both the police and its parents.

**Here are a few screens from the app:**

<img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/s1final.png" alt="login" width="" height="500" />       <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/signup_page.png" alt="login" width="" height="500" />       <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/login_page.png" alt="login" width="" height="500" />       <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/home_page.png" alt="login" width="" height="500" />
<img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/scan with email.png" alt="login" width="" height="500" />       <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/report.png" alt="login" width="" height="500" />       <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/settings_page.png" alt="login" width="" height="500" />       <img src="https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/verification.png" alt="login" width="" height="500" />

## 🎬 Short Demo (4 min long)

https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese/blob/master/Cheese_video_demo.mp4


## ⚙️ Tech-Stack
**Frontend:** [Flutter(version 3.0.0)](https://flutter.dev/) (Documentation: https://docs.flutter.dev/)<br/> 
**Backend and Database:** [Firebase and Firestore](https://firebase.google.com/) <br/>
**Face Recognition Api:** [Regula Face Api](https://docs.regulaforensics.com/resources/#web)

## 🏃🏻 Getting Started

### Prerequisites:
* Get Flutter up and running. For this purpose visit - [Flutter docs](https://flutter.dev/docs/get-started/install).

## For installation

* If you are using an IDE like [Android Studio](https://developer.android.com/studio), you may use suitable GUI/hotkeys. Here is how you can work things from the terminal.
### An Important Note : Please run this project with flutter version 3.0.0 only
```
git clone https://github.com/AnMaJ/Microsoft-Engage-2022-Project-Cheese.git
cd Microsoft-Engage-2022-Project-Cheese
flutter pub get
flutter run 

```

## 🤝🏻 Contributions
Contribution of all sorts are welcome.
