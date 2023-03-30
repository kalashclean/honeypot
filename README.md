# honeypot_capstone
Enter into the HoneyBath directory
```
cd HoneyBath
```
Add the needed libraries
```
sudo apt update && sudo apt install python3 python3-pip npm docker.io docker-compose
```
install all the python requirements
```
pip install -r honeyd/requirements.txt
```
make all the bash file executable
```
find . -type f -name "*.sh" -exec chmod +x {} \;

```
Run the project 
```
sudo ./HoneyBath.sh
``` 
