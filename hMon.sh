#!/bin/bash
# Author: Diego Narducci
# E-mail: diego.narducci88@gmail.com

# Versão 0.1a -> Versão inicial.
######################################################
# Script de monitoramento de temperadura deos hardwares do sistema, onde tem um setpoint para tomada de ação.
# Criei esse script por uma necessidade minha em monitorar a temperatura da placa de video enquanto realizava algo que gerasse extresse na mesma, assim que a temperatura da vga alcança o valor da variavel nvidiaTempMax automaticamente o programa ou jogo é fechado, o moniytoramento é feito a cada 30 segundos.
#
# Dependencias: nvidia-smi, lm-sensors, hddtemp ...
#
# Utilização: esse script deve ser adiiconado ao crontab do sistema e ser executado como root e com tempo de rexecução escolhido pelo usuario.
# abra com permissão root o arquivo /etc/crontab com seu editor de texto preferido e anexe na ultima linha:
# */5 * * * * root [caminho do executavel]/hMon.sh
# e salve, o valor "5" pode ser modificado por vc como o intervalo de tempo que o script sera executado
# caso nao funcione execute sudo systemctl restart cron.

######################################################

folder=/usr/local/hd

tempSda=$(hddtemp /dev/sda | cut -c 34-35)
tempSdb=$(hddtemp /dev/sdb | cut -c 30-31)
tempNvidia=$(nvidia-smi | grep -i "%" | cut -c 9-10)

if [ $tempSda -gt 44 ]
then
	DISPLAY=":0.0" zenity --info --text="Temperatura alta em SDA $tempSda C"
fi

if [ $tempSdb -gt 44 ]
then
	DISPLAY=":0.0" zenity --info --text="Temperatura alta em SDA $tempSdb C"
fi

if [ $tempNvidia -gt 72 ]
then
	DISPLAY=":0.0" zenity --info --text="Temperatura alta em Placa de Video $tempSdb C"
	sudo pkill -9 -e .*steam.*
	sudo pkill -9 -e .*hl2.*
fi

echo "Temperatura: $tempSda C no hd: sda às: $(date)" >> $folder/log_temp_sda.log
echo "Temperatura: $tempSdb C no hd: sda às: $(date)" >> $folder/log_temp_sdb.log
echo "Temperatura: $tempNvidia C na placa de video às: $(date)" >> $folder/log_temp_nvidia.log
