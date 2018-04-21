#!/bin/bash
sens=/usr/bin/sensors
if $sens | grep "Physical id 0" > /dev/nul
    then $sens | grep "Physical id 0" | awk '{print $ 4}' | cut -c 2-3
    else
        if $sens | grep "Package id 0" > /dev/nul
            then $sens | grep "Package id 0" | awk '{print $ 4}' | cut -c 2-3
            else
                if $sens | grep "temp1" > /dev/nul
                    then $sens | grep "temp1" -m1 | awk '{print $ 5}' | cut -c 2-3
                    else
                        if $sens | grep "core1" > /dev/nul
                            then $sens | grep "Core 0" -m1 | awk '{print $ 6}' | cut -c 2-3
                        fi
                fi
        fi
fi
