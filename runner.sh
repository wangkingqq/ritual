#!/bin/bash
# runner_loop.sh

SCRIPTS=(A.sh B.sh C.sh D.sh E.sh F.sh G.sh H.sh I.sh J.sh K.sh L.sh M.sh N.sh O.sh P.sh)

INDEX=0
TOTAL=${#SCRIPTS[@]}

while true; do
    # 当前要运行的脚本
    SCRIPT=${SCRIPTS[$INDEX]}

    echo "[$(date)] 停止所有 docker 容器..."
    RUNNING=$(sudo docker ps -q)
    if [ -n "$RUNNING" ]; then
        sudo docker stop $RUNNING
    else
        echo "没有正在运行的容器"
    fi

    echo "[$(date)] 开始运行: $SCRIPT"
    chmod +x "$SCRIPT"
    ./"$SCRIPT"

    # 下一个索引（循环回到0）
    INDEX=$(( (INDEX + 1) % TOTAL ))

    echo "[$(date)] 完成，进入休眠 24 小时..."
    sleep 24h
done
