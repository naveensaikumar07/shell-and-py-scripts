import os

os.chdir("/home/nsk")
for dirs in os.listdir():
    if  not dirs.startswith("."):
        print(dirs)
print("."*50)
print(os.system("cat /etc/os-release"))
print(os.system("uname -r "))
print(os.system("ps -aux"))

