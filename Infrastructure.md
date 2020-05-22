# RakuDist on community infrastructure 


```
                          +------- [AWS ec2] -----+                +----------[VM host] ------------------------------+
                          |  |///////////////|    |                |    |//////////////////////|                      |
 [user] => run test    => |  |    Web UI     |    |  => scp =>     |    |      brezeleisen     | ~> docker exec       |
          read report  => |  |    Sparky UI  |    |  (trigger file)|    |      Sparky Daemon   |    [docker debian]   |
                          |  |               |    |                |    |//////////////////////|    [docker ubuntu]   |
                          |  |///////////////|    |                |                 |              [docker alpine]   |
                          |                       |                +-----------------|--------------------------------+
                          |   ////////\           |                                  |
                          |   | MySQL |  <--------|----------------------------------+  
                          |    \////////          |
                          |                       |
                          +-----------------------+



```  
