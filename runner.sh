#!/bin/bash
# runner_loop.sh

SCRIPTS=(A.sh B.sh C.sh D.sh E.sh F.sh G.sh H.sh I.sh J.sh K.sh L.sh M.sh N.sh O.sh P.sh)

INDEX=0
TOTAL=${#SCRIPTS[@]}

while true; do
    SCRIPT=${SCRIPTS[$INDEX]}

    echo "[$(date)] 停止所有 docker 容器..."
    RUNNING=$(sudo docker ps -q)
    if [ -n "$RUNNING" ]; then
        sudo docker stop $RUNNING
    else
        echo "[$(date)] 没有正在运行的容器"
    fi

    echo "[$(date)] 开始运行: $SCRIPT"
    chmod +x "$SCRIPT"

    # 使用 expect 自动回答
    expect <<EOF
        log_user 1
        spawn bash "./$SCRIPT"

        # 遇到 y/n 选项
        expect {
            -re "(?i)yes/no" { send "y\r"; exp_continue }
            -re "(?i)y/n"    { send "y\r"; exp_continue }

            # 遇到数字选项
            -re "([0-9]+)"   { send "1\r"; exp_continue }

            eof
        }
EOF

    if [ $? -ne 0 ]; then
        echo "[$(date)] $SCRIPT 执行失败，继续下一个"
    fi

    # 更新索引
    INDEX=$(( (INDEX + 1) % TOTAL ))

    echo "[$(date)] $SCRIPT 完成，休眠 24 小时..."
    sleep 24h
done
