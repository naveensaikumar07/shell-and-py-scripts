echo " Choose from following"
echo " 1) List files"
echo " 2) print present working directory"
echo " 3) print kernal version"
read CHOICE
case $CHOICE in
    1 ) ls -lhrt ;;
    2 ) pwd ;;
    3 ) uname -r ;;
    * ) echo "Invalid Option"  ;;
esac
