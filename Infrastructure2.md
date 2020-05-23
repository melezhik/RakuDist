# RakuDist on community infrastructure 

Version 2

```
                          +------- [AWS ec2] -----+                  +----------[VM host - brezeleisen] -----------------+
                          |  |///////////////|    |                  |    |//////////////////////////////////////////////|
 [user] =>  run tests     |  |  ssh tunnel   |----|---> http ---->---|----|--> RakuDist UI   |                           |
          read reports    |  |               |    |                  |    |                  |                           |
               |          |  |               |    |                  |    |                  |                           |
               |          |  |  ssh tunnel   |----|---> http ---->---|----|--> Sparky UI     |                           |
               |          |  |///////////////|    |                  |    |                  |                           |
               |          |       | reverse       |                  |    |------------------+------------[ docker ] ----+
               |          |       \  proxy        |                  |    |    Sparky  |              =>   debian        |    
               |          |   ////////\           |                  |    |    Daemon  | -> [podman]  =>   centos        | 
               \ ----->   |   | nginx |           |                  |    |            |      test    =>   alpine        |
                          |   \////////           |                  |    |//////////////////////////////////////////////|
                          |                       |                  |              SQLite DataBase / Reports            |
                          +-----------------------+                  +---------------------------------------------------+

```  
