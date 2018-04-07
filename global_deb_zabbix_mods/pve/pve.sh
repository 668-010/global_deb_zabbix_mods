#!/bin/bash

vmid=$2

function protection { 								#Проверка защиты виртуальной машины
if grep protection /etc/pve/qemu-server/$vmid.conf > /dev/nul 			#Если в конфиге машины есть строка параметра protection
then grep protection /etc/pve/qemu-server/$vmid.conf | cut -d ' ' -f2 		#То проверить какое числовое значение этого параметра (1-включен, 0-выключен)
else echo 0									#Иначе значит параметр защиты нет, не настроен\выключен
fi
}

function cores {								#Проверка количества выделенных ядер на ВМ
grep cores /etc/pve/qemu-server/$vmid.conf | cut -d ' ' -f2			#Показать параметр количество ядер
}

function vzdump {								#Проверка плана бэкапа
if grep $vmid /etc/cron.d/vzdump > /dev/nul					#Если в cron есть строка с номером VMID
then echo 1									#То всё нормально
else
    if grep disable-vzdump /etc/pve/qemu-server/$vmid.conf > /dev/nul		#Иначе если нету, то проверить наличие комментария "disable-vzdump" в параметрах машины
        then echo 1								#если есть комментарий то всё норм
        else echo 0								#иначе если нет, то алер
    fi
fi
}

function kernel {		#Проверка версии ядра
uname -r
}

$1