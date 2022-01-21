[English](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/README.md) | Русский

# Магма - Режим гаммирования (CTR)

![Title](https://raw.githubusercontent.com/Bs0Dd/magma-8080/main/86rk.png)

Реализация режима гаммирования для процессора КР580ВМ80А (Intel 8080A).

* Шифрование/дешифрование блоками по **64 бита**.
* Ключ **256 бит**.
* Затраты: **~156 000 тактов** за один вызов (**~16 вызовов/с**).
* Скорость шифрования/дешифрования: до **1 Кбит/с**.


## Набор подпрограмм

Для облегчения использования алгоритма основные подпрограммы собраны в единую "библиотеку" - **gmagma** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/gmagma.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/gmagma.bin) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/gmagma.rk).  
Программисту достаточно всего лишь вызывать нужные подпрограммы и читать результат по фиксированному адресу.  
Доступны 4 публичные подпрограммы и 2 публичных значения - для них действуют следующие адреса:

| Подпрограмма |               Назначение              |   Адрес   |
| :----------: | :-----------------------------------: | :-------: |
|    magexe    | Обработка 64-бит блока по адресу в HL | org + 0h  |
|    initiv    |    Инициализация Инит. Вектора (ИВ)   | org + 1Ch |
|    setkey    |     Установка ключа по адресу в HL    | org + 2Bh |
|    setiv     |       Установка ИВ по адресу в HL     | org + 37h |

| Значение | Длина (байт) |     Описание    |   Адрес    |
| :------: | :----------: | :-------------: | :--------: |
|   key    |      32      | Ключ шифрования | org + 214h |
|  inivc   |      8       |   Инит. Вектор  | org + 234h |


Файлы **bin** и **rk** подразумевают загрузку их кода по адресу **7000h**. Соответственно адреса:

| Название |  Адрес  |
| :------: | :-----: |
|  magenc  |  7000h  |
|  initiv  |  701Ch  |
|  setkey  |  702Bh  |
|  setiv   |  7037h  |
|   key    |  7214h  |
|   data   |  7234h  |

Результат шифрования/дешифрования всегда будет находиться по адресу **data**.


## Примеры

Примеры шифрующей программы (**Магма-гКрипто**):  
* **magma-gcrypto-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-86rk.rk) - Версия для ПЭВМ **Радио-86РК** (с выводом на дисплей)  
* **magma-gcrypto-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-uni.bin) - Не привязанная к конкретному устройству версия (**HLT** после конца программы)