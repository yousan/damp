#!/usr/bin/env bash
BASE=/etc/

echo '"*.test"のアクセスをローカルホストに向ける設定を行います。'

make_resolver() {
   if [ ! -d ${BASE}/resolver ] ; then
     echo 'パスワード入力が求められますので、現在ログインしているユーザのパスワードを入力してください。'
     sudo mkdir ${BASE}/resolver
   fi

   if [ -f ${BASE}/resolver/dev ] ; then
     echo 'ファイルが既に存在しました'
     return
   else
     sudo sh -c "echo 'nameserver 127.0.0.1' > ${BASE}/resolver/test"
   fi
}

make_resolver

echo '作業が終了しました。閉じるボタンを押して終了してください。'