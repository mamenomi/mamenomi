### QNAP NAS設定

- 参考URL
    > https://from-age35.com/2028.html
- ssh接続接続
  - QNAP NASのコントロールパネルでssh接続を許可
  - ポートはデフォルトの22
- ターミナルでssh接続
  - macのターミナルはデフォルトでssh接続可能(Windowsだと Tera Termを使用しなければならない)
  - ターミナルを立ち上げコマンド入力 ''' ssh admin@192.168.3.7 -p 22 '''
- container stationでubuntuをインストール
  - ホスト名= myQnap-ubuntu-1
  - IP= 192.168.3.201
  - addユーザー= myqnap_user01 pw= 112012
    - コマンド
      - adduser <user_name>
      - gpasswd -a <user_name> sudo -> sudo権限を付与。
      - <user_name>ユーザーは、必要なときにコマンドにsudoをつけて、ルートの権限を借りることができます。
      - apt install sudo -> sudoコマンドのインストール
- ubuntu にSSH接続
  - apt install vim -> vimのインストール(後々必要になるため)
  - login <user_name> -> 新規ユーザーでログイン
  - sudo apt install openssh-server -> SSHサーバーインストール
    - SSHサーバーはインストールしただけえは機能しない、適切な設定を入れ、サービスを起動して初めて外部から接続できるようになる。vimで設定の編集をする。
    - sudo vim /etc/ssh/ssh_config -> vimで設定ファイルを開く
    - 「PasswordAuthentication yes」と「Port 22」のコメント「#」を外し、上書き保存します。
    - service ssh start -> SSHサーバーの起動
- Python 3.xの環境構築【Ubuntu 20.04】
  - 参考URL
    > https://note.com/mokuichi/n/n627eb6773aad
