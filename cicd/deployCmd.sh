#!/usr/bin/expect -f
#  ./deployCmd.exp <ipAddress> <userid> <password> <command> ...
set server [lrange $argv 0 0]
set name [lrange $argv 1 1]
set pass [lrange $argv 2 2]
set command  [lrange $argv 3 end]

spawn ssh $name@$server
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
send -- "\r"
expect " $"
send -- "$command\r"
expect " $"
send -- "exit"
send -- "\r"
expect eof

