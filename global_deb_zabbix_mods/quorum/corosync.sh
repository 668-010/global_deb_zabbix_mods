#!/bin/bash
#
# Скрипт проверки коросинка
# 0 - Значит всё правильно
# 1 - Значит для двух нод не настреон кворум
# 2 - Значит для более двух настроен кворум (не должен быть настроен)

sumnodes=$(cat /etc/corosync/corosync.conf | grep nodeid: -wc)                          # Количество нодов в коросинк
if [ $sumnodes -eq 2 ]                                                                  # Если нодов равно два
    then
        if grep "two_node: 1" /etc/corosync/corosync.conf > /dev/nul                    # и если найден параметр two_node: 1 то всё норм, если нет то алерт
                then echo 0
                else echo 1
                fi
    else
        if [ $sumnodes -gt 2 ]                                                           Иначе если количество нод больше двух
                then
                    if grep "two_node: 1" /etc/corosync/corosync.conf > /dev/nul        # и если найден параметр two_node: 1 то алерт, если нет то всё норм.
                        then echo 2
                        else echo 0
                    fi
        fi
fi
