# RakuDist on community infrastructure 


```
                          +------- [AWS ec2] -----+                  +----------[VM host - brezeleisen] ----------------+
                          |  |///////////////|    |                  |    |//////////////////////|     [test jobs]      |
 [user] => run test    => |  |    Web UI ----|----|---> scp file -->-|----|---> Sparky Daemon    | ~>  docker exec      |
          read report  => |  |               |    |  (trigger build) |    |                      | ~> [docker debian]   |
                          |  |               |    |                  |    |//////////////////////| ~> [docker ubuntu]   |
                          |  |   Sparky UI   |->--|- rsync sparky ->-|------>------ /  |           ~> [docker alpine]   |
                          |  |///////////////|    |    files         +-----------------|--------------------------------+
                          |                       |                                    |    
                          |   ////////\           |                                    |
                          |   | MySQL |  <--------|-----SQL queries  ------------------+  
                          |   \////////           |
                          |                       |
                          +-----------------------+



```  
