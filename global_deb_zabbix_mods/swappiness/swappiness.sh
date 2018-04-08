#!/bin/bash

memtotal=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')	#Значение общей памяти системы
sys_swap=$(grep vm.swappiness /etc/sysctl.conf | awk '{print $3}')	#Значение срабатывания SWAP в sysctl


#=========================================================================================
#=========================================================================================
#Проверка параметра swappiness в sysctl.conf

function sysctl {
check_sys(){
mem32gb=33554432

#Если ОЗУ системы меньше или равно 32 Гб, и если значение vm.swap в sysctl не равно 5, то передает значение 1, иначе (значит все верно)передает 3
if (($memtotal <= $mem32gb))
then
    if [ $sys_swap -ne 5 ]
        then echo 1
        else echo 3
    fi
fi


#Если ОЗУ системы больше 32 Гб, и если значение vm.swap в sysctl не равно 1, то передает значение 2, иначе (значит все верно) передает 3
if (($memtotal > $mem32gb))
then
    if [ $sys_swap -ne 1 ]
        then echo 2
        else echo 3
    fi
fi
}

#Разяъснение значений 0 1 2
# 0 - Значит параметр vm.swappiness не настроен в /etc/sysctl.conf
# 1 - Значит что для системы с меньше чем или равно 32 Гб ОЗУ, параметр vm.swappiness в /etc/sysctl.conf настроен не верно, должно быть равно 5
# 2 - Значит что для системы с больше чем 32 Гб ОЗУ, параметр vm.swappiness в /etc/sysctl.conf настроен не верно, должно быть равно 1
# 3 - Всё настроено правильно.

# Проверка есть ли строка со значением vm.swappiness в syscrl.conf
if grep vm.swappiness /etc/sysctl.conf > /dev/nul
then check_sys
else echo 0
fi
}


#=========================================================================================
#=========================================================================================
# Проверка применен ли параметр swappiness в данный момент (онлайн)
# Если значение swappiness в системе (proc) не равен значению в sysctl.conf, то значит параметр из sysctl.conf не применена,
# поэтому отправляется значение 0 т.е. алерт, иначе (если равно) то настройки применены, отправляется значение 1.
function proc {
proc_swap=$(cat /proc/sys/vm/swappiness)
if [ $proc_swap -ne $sys_swap ]
then echo 0
else echo 1
fi
}

$1