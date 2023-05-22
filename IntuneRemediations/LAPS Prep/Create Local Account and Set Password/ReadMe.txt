This script pair detects if the account you want exists on the machine and has a password set.
If the account does not exists, it is created with a complex password and added to the local administrators group.
If the account exists without a password, a complex password is set. A different script pair will catch that the account
is not an administrator and remedy that.