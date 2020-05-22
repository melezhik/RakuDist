# RakuDist on community infrastructure 


```
                          +------- [AWS ec2] -----+                  +----------[VM host - brezeleisen] ----------------+
                          |  |///////////////|    |                  |    |//////////////////////|     [test jobs]      |
 [user] => run test    => |  |    Web UI ----|----|---> scp file -->-|----|---> Sparky Daemon    | ~>  docker exec      |
          read report  => |  |    Sparky UI  |    | (trigger build)  |    |                      | ~> [docker debian]   |
                          |  |               |    |                  |    |//////////////////////| ~> [docker ubuntu]   |
                          |  |///////////////|<---|--- scp reports---|------------- /  |           ~> [docker alpine]   |
                          |                       |                  +-----------------|--------------------------------+
                          |   ////////\           |                                    |
                          |   | MySQL |  <--------|-----SQL queries  ------------------+  
                          |   \////////           |
                          |                       |
                          +-----------------------+



```  
