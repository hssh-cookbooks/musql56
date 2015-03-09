# mysql56

## Ubuntu 14.04での注意点

Ubuntu 14.04では`mysql-server-5.6`パッケージをインストールした際、
マシンのメモリが足りないとインストール後のdaemonの立ち上げに失敗します。
Ubuntu 14.04の環境にこのcookbookを適用する場合は、最低でも1Gのメモリを与えて下さい。
詳しくは下記のチケットを参照下さい。

- [Bug #1312936 “Post-installation script fails” : Bugs : mysql-5.6 package : Ubuntu](https://bugs.launchpad.net/ubuntu/+source/mysql-5.6/+bug/1312936)
