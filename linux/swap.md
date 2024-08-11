# 创建swap
```bash
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=1GB count=32
sudo chmod 600 /swapfile
ls / | grep swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

## 修改 fstab（慎重）
```bash
sudo nano /etc/fstab
```
增加：
```
/swapfile swap swap defaults 0 0
```