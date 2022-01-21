[English](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/README.md) | Русский

# Магма - Режим простой замены (ECB)

![Title](https://raw.githubusercontent.com/Bs0Dd/magma-8080/main/86rk.png)

Реализация режима простой замены для процессора КР580ВМ80А (Intel 8080A).

* Шифрование/дешифрование блоками по **64 бита**.
* Ключ **256 бит**.
* Затраты: **~156 000 тактов** за один вызов (**~16 вызовов/с**).
* Скорость шифрования/дешифрования: до **1 Кбит/с**.


## Набор подпрограмм

Для облегчения использования алгоритма основные подпрограммы собраны в единую "библиотеку" - **magma** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma.bin) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma.rk).  
Программисту достаточно всего лишь вызывать нужные подпрограммы и читать результат по фиксированному адресу.  
Доступны 4 публичные подпрограммы и 2 публичных значения - для них действуют следующие адреса:

| Подпрограмма |           Назначение           |   Адрес   |
| :----------: | :----------------------------: | :-------: |
|    magenc    |    Кодирование 64-бит блока    | org + 0h  |
|    magdec    |   Декодирование 64-бит блока   | org + Сh  |
|    setdat    | Установка блока по адресу в HL | org + 18h |
|    setkey    | Установка ключа по адресу в HL | org + 24h |

| Значение | Длина (байт) |     Описание    |   Адрес    |
| :------: | :----------: | :-------------: | :--------: |
|   key    |      32      | Ключ шифрования | org + 1D5h |
|   data   |      8       |   Блок данных   | org + 1F5h |


Файлы **bin** и **rk** подразумевают загрузку их кода по адресу **7000h**. Соответственно адреса:

| Название |  Адрес  |
| :------: | :-----: |
|  magenc  |  7000h  |
|  magdec  |  700Ch  |
|  setdat  |  7018h  |
|  setkey  |  7024h  |
|   key    |  71D5h  |
|   data   |  71F5h  |

Результат шифрования/дешифрования всегда будет находиться по адресу **data**.


## Примеры

Примеры с непосредственным встраиванием алгоритма:  
 * **magma-d-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-d-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-d-86rk.rk) - Версия для ПЭВМ **Радио-86РК** (с выводом значений на дисплей)  
 * **magma-d-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-d-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-d-uni.bin) - Не привязанная к конкретному устройству версия (**HLT** после конца программы)

Примеры с использованием набора подпрограмм (по адресу **7000h**):  
 * **magma-ld-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-ld-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-ld-86rk.rk) - Версия для ПЭВМ **Радио-86РК** (с выводом значений на дисплей)  
 * **magma-ld-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-ld-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-ld-uni.bin) - Не привязанная к конкретному устройству версия (**HLT** после конца программы)

Примеры шифрующей программы (**Магма-Крипто**):  
* **magma-crypto-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-crypto-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-crypto-86rk.rk) - Версия для ПЭВМ **Радио-86РК** (с выводом на дисплей)  
* **magma-crypto-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-crypto-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/ECB/magma-crypto-uni.bin) - Не привязанная к конкретному устройству версия (**HLT** после конца программы)
