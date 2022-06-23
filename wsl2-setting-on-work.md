---
title: 2022-04-15_10-15 wsl2-Ubuntu20.04-setting
date: 2022-04-15
tags:
  -
---
# WSL2 Ubuntu20.04導入

## インストールしたもの

- windows terminal
- Ubuntu 20.04 On windows

## Ubuntuの起動

- スタートメニューよりUbuntu 20.04 On Windowsを起動
- ユーザー名とパスワードを入力
- 以降、windows terminalから起動(初回はwindows terminalから起動出来なかった)

## 既定のバージョンをwsl2にする

- プロキシ環境下では実行不可能
― PowerShell起動
  - 既定をWSL2に変更
    - コマンド: wsl -–set-default-version 2
  - 現在のバージョン確認
    - コマンド: wsl –l -v
  - ディストリビューション単位で設定
    - コマンド: wsl –set-version <Distribution> 2

<div style="page-break-before:always"></div>

## sudo apt update出来ない

- 解決策
  - ネットワークの設定からイーサネットの共有をする
    - 共有先-> vEthernet (WSL) ←　不要!!!
  - bashrcに下記追加

    ```
    export HTTP_PROXY_USER=ykadmin
    export HTTP_PROXY_PASS=YKAdmin-PRXY
    export HTTP_PROXY=http://${HTTP_PROXY_USER}:${HTTP_PROXY_PASS}@10.1.1.30:8080/
    export HTTPS_PROXY=${HTTP_PROXY}
    ```
    ↑これじゃだめですた(zshrcの記述をコピペしてしまった;;;)
    ```
    export http_proxy="http://10.1.1.30:8080"
    export https_proxy=$http_proxy
    ```
    ↑こっちが正
  - apt.confファイルにProxy設定を追加
    - /etc/apt/apt.conf
    ```
    Acquire::http::Proxy "http://10.1.1.30:8080";
    Acquire::https::Proxy "http://10.1.1.30:8080";
    ```
<div style="page-break-before:always"></div>

## Homebrewを導入する

- build-essentialを導入する
  - コマンド
    - sudo apt-get install build-essential curl file git
    - build-essentialとは？
    ```
    <https://kazuhira-r.hatenablog.com/entry/2020/11/30/204027>
    ```
- 公式ページのワンライナーからインストールを実行
- 初期設定
  - パスを通してコマンドを使えるようにする
  - bashrcに下記追記
  ```
  # brew
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  ```
- HomebrewでZSHをインストールして、デフォルトシェルをZSHに変更
  - brew install zsh
  - brew install zplug
  - zshrcは既存のものをコピペ
  - デフォルトシェル変更方法
  ```
  echo `which zsh` | sudo tee -a /etc/shells
  chsh -s `which zsh`
  ```

## githubへSSH接続出来ない

- 下記記事通りに設定
  ```
  https://note.com/noabou/n/n3ba65990e2b1
  ```
  - ~/.ssh/configにプロキシ経由を追加
    ``` https://toshibohjp.github.io/blog/2013/05/02/using-ssh-over-https-port-on-your-linux/ ```
  - sudo apt install connect-proxy

## node.jsの導入

- nodebrew
  - brew install nodebrew
  - nodebrew setup
    - pathを設定する(~/.zshrcへ追記)
  - nodebrew install stable
  - nodebrew use v{バージョン指定}
  - npmも一緒にインストールされる

## npm install出来ない

- proxy配下だとnpm install動かない
- ``` npm config -ls -l ``` ← 現在の設定を確認
- ``` npm config set strict-ssl false ``` ← 設定変更
- ``` npm config set registry "http://registry.npmjs.org/" ``` ← 設定変更
- ``` npm config set proxy "http://ykadmin:YKAdmin-PRXY@10.1.1.30:8080" ``` ← 設定変更
- create-react-app
  - 作成したフォルダに移動
  - npm install
  - yarn start  ← command not foundになる
  - npm -g install yarnを実行(グローバルにインストールしちゃう)
  - brew install yarnでもいいっぽい

- ``` https://zenn.dev/riraosan/articles/91b8e4946fa045 ```
- 色々やってみる
  ``` https://qiita.com/wafuwafu13/items/2fe43414aa6e1899f494 ```

## electronの起動まで

- 必要なもの
  ``` https://mirumi.me/tech/206/ ```
- インストール-> 起動まで
  ``` http://liginc.co.jp/web/html-css/177611 ```
- 実行時エラーの対処について
  - インストールが不足しているっぽいエラー
  - sudo apt-get install apt-file
  - sudo apt-file update
  - 欲しいライブラリが入手できるパッケージを探す
  - 入れたパッケージ
    - libgtk2.0-0
    - libxss1
    - libgconf-2-4
- Pango-ERROR **: 16:52:49.728: Harfbuzz version too old (1.2.7)が発生する
  - libsdl-pango-devパッケージをインストールする
    - sudo apt-get install -y libsdl-pango-dev
    - エラー直らず
  - Harfbuzzのアップデート
    - ``` https://noknow.info/it/os/install_harfbuzz_from_source?lang=ja ```
    - ダメ
    - libharfbuzz-binをインストール
      - コマンド: sudo apt-get install libharfbuzz-bin
      - エラー直らず
- displayが機能しているか確認
  - sudo apt install x11-apps -y
  - xcalc
  - 参考: ``` https://tamnology.com/wsl2-vcxsrv/ ```
- こっちも試す
  ``` https://qiita.com/TanakanoAnchan/items/5c76b7bb2f39ccc10018 ```
  ``` https://scrapbox.io/miyamonz/WSL2%E3%81%A7electron ```
- proxy環境下の罠について
  ``` https://qiita.com/LuckyRetriever/items/2f377b1ce34f7d12903c ```
- 参考
  ``` http://pineplanter.moo.jp/non-it-salaryman/2021/01/28/electron-revise/ ```

## wget出来ない

- wgetインストール: brew install wget
- /etc/wgetrcにプロキシ設定追記
  - http_proxy = http://10.1.1.30:8080/
  - https_proxy = http://10.1.1.30:8080/

## 大変参考になった記事

- wsl2 ubuntu20.04設定
  ``` https://note.com/noabou/n/n3ba65990e2b1 ```
- ディレクトリ構成
  ``` https://hayana.work/archives/1463 ```
- github用に新規ユーザーを追加した
  - ユーザー名: mamenomi
  - password: 5k8w3ds4

    ``` https://www.server-world.info/query?os=Ubuntu_20.04&p=initial_conf&f=1 ```
  - gitコマンド
    ``` https://estuarine.jp/2020/10/git/ ```
  - nmp installについて
    ``` https://zenn.dev/ikuraikura/articles/71b917ab11ae690e3cd7 ```
  - ネットワーク関係
    ``` https://qiita.com/smallpalace/items/f2bd349d447ebb9c31cc ```
- linuxコマンド
  - ``` https://qiita.com/LostEnryu/items/89f67cf608cd244373b1 ```
  - evalとは
    - ``` https://bunjava.com/shell_eval/ ```
- vim
  - ``` https://7ka.org/ubuntu_terminal_vim/ ```

## python環境

- pyenvインストール
  - コマンド: brew install pyenv
- pipenvインストール
  - コマンド: brew install pipenv
- pyenv-virtualenvインストール
  - コマンド: brew install pyenv-virtualenv
- pythonのインストール
  - コマンド: pyenv install 3.8.13
  - エラーでインストール出来ず
  - ~/.zshrc追記
  ```
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:/} brew"
  ```
  - パッケージのインストール
  ```
  sudo apt install \
  libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
  libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  libopencv-dev
  ```
  - https://zenn.dev/neruo/articles/install-pyenv-on-ubuntu ← 参考
  ― エラー解消!
- brew でエラ―発生
  - /home/uchida/.pyenv/shimsがPATHにあると余計なconfigファイルを参照してきてしまう
  - brewコマンド実行時用のPATHをaliasで定義する
  ```
  alias brew='PATH=/home/linuxbrew/.linuxbrew/bin/:/home/linuxbrew/.linuxbrew/sbin:/usr/bin brew'
  ```

## Django REST FRAMEWORK
  - restApi用のフォルダ作成、移動
  - pipenv install python 3.8
    ― エラー発生!
