# BetterMineOS

## Structure
/Commands is the folder that you add to your $PATH so that you can call the commands from anywhere  
/Servers is the folder where you make your server folders  
/Backups is for backups.. I shouldn't have to explain this

## Add these to your .bashrc
export PATH="$HOME/.../BetterMineOS/Commands:$PATH"  
export BetterMineOS="$HOME/.../BetterMineOS/"  

## To set up a server
1. Create a folder in /Servers (The name will be used in the start command)
2. Place Autoupdate...sh (its a long name) in the folder
3. Edit Autoupdate...sh's $version variable to have the version you want

## Notes
.gitignore ignores all the folders related to servers
