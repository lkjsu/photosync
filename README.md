# photosync

### What was the goal?

- Try how UIImagePickerControllerDelegate could be used to select images in the iOS filesystem and send it over the network.
- store auth token in KeyChain.
- get familiar with SwiftUI.

### How it works?

- clone the repository
```
git clone https://github.com/lkjsu/photosync.git
```
#### create venv
make sure to use python 3.9
 ```
 python -m venv venv
 source ./venv/bin/activate
 ```
#### install requirements
```
pip install -r requirements.txt
```

#### run the server

```
python manage.py runserver
```
![example](https://github.com/lkjsu/photosync/blob/main/assets/example.gif)
