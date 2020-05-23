# RakuDist on community infrastructure 


```
                          +------- [AWS ec2] -----+                  +----------[VM host - brezeleisen] ----------------+
                          |  |///////////////|    |                  |    |//////////////////////|     [test jobs]      |
 [user] =>   run tests => |  |    Web UI ----|----|---> scp file -->-|----|---> Sparky Daemon    | ~>  podman exec      |
          read reports => |  |               |    |  (trigger build) |    |                      | ~> [docker debian]   |
                          |  |               |    |                  |    |//////////////////////| ~> [docker ubuntu]   |
                          |  |   Sparky UI   |->--|----- rsync ---->-|------>------ /  |           ~> [docker alpine]   |
                          |  |///////////////|    |  sparky files,   |                 |                                |
                          |       | (read)        |     reports      +-----------------|--------------------------------+
                          |       \               |                                    |    
                          |   ////////\           |                                    |
                          |   | MySQL |  <--------|-----( read / write )  -------------+  
                          |   \////////           |
                          |                       |
                          +-----------------------+



```  
