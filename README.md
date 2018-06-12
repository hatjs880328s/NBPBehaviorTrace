# NBPUser- behavior trace


![swift](http://chuantu.biz/t6/273/1522900210x1822611227.jpg)-swift
![nbp](http://chuantu.biz/t6/273/1522900210x1822611227.jpg)-nbp
![userbehaviortrace](http://chuantu.biz/t6/273/1522900210x1822611227.jpg)-userbehaviortrace
![mergesort](http://chuantu.biz/t6/273/1522900210x1822611227.jpg)-mergesort
![customqueue](http://chuantu.biz/t6/273/1522900210x1822611227.jpg)-customqueue  





### 1.nbp user behavior trace[use objc Aspects kit]

### 2.sqlite3.2 from master rebuild ###

### 3.mergeSort - swift

### 4.custom queue [use closure do it]

### 5.logic layer [ibll follow JAVA-SPRING]


### 1.0 nbp user behavior trace  DISK-progress center
*   1.use mmap save the memory event infos.
*   2.read event info from file : if success then deleate the file ,
   if deleate file success return the fileStrinfo else return nil.
   user should not invoking the deleate function manual.
*   3.basic file/dir progress [file create | file deleate | file read | file write(use mmap)]


### 2.1 optimize the mmap over
* 1.add cache & no cache function change
* 2.use mmap save info
* 3.import sqliteFMDB but no use ( if mmap couldn't do well, change to sqlite very easy)

### 2.2 optimize the upload center 
* 1.scan documents/nopnoah_shan folder to search all files
* 2.if one file exist directly return else analyze all except last file 

# HOW TO USE :
* 
        // start-HOOKFunctions-Service
        AOPNBPCoreManagerCenter.getInstance().startService()
        // start-upload-Service
        AOPEventUploadCenter.getInstance().startService()
        AOPEventUploadCenter.getInstance().progressAction = { strResult , handle in
        }
