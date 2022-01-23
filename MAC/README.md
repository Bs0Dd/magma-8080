English | [Русский](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/README-ru_RU.md)

# Magma - Message Authentication Code mode (MAC)

Message Authentication Code mode implementation for Intel 8080A processor.

* Encryption/decryption in blocks of **64 bits**.
* Key **256 bit**.
* Cost: **~156 000 ticks** per call (**~16 calls/s**).
* Encryption/Decryption Speed: up to **1 Kbit/s**.


## A set of subroutines

To facilitate the use of the algorithm, the main subroutines are collected in a single "library" - **imagma** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/imagma.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/imagma.bin) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/imagma.rk).  
The programmer just needs to call the required subroutines and read the result at a fixed address.  
3 public subroutines and 2 public values ​​are available - the following addresses are valid for them:

|  Subroutine  |                    Purpose                  |  Address  |
| :----------: | :-----------------------------------------: | :-------: |
|    magimi    | Add to MAC 64-bit block at an address in HL | org + 0h  |
|    imrst     |    Reset Message Authentication Code area   | org + 17h |
|    setkey    |       Setting a key at an address in HL     | org + 2Ah |

|  Value   | Length (bytes) |   Description   |  Address   |
| :------: | :------------: | :-------------: | :--------: |
|   key    |       32       |  Encryption key | org + 1CEh |
|  imito   |       8        |       MAC       | org + 1EEh |


Files **bin** and **rk** imply loading their code to **7000h**. Accordingly addresses:

|   Name   | Address |
| :------: | :-----: |
|  magimi  |  7000h  |
|  initiv  |  7017h  |
|  setkey  |  702Ah  |
|   key    |  71CEh  |
|  imito   |  71EEh  |


## Examples

Examples of crypting program (**Magma-Imito**):  
 * **magma-imito-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/magma-imito-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/magma-imito-86rk.rk) - Version for PC **Radio-86RK** (with display)  
 * **magma-imito-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/magma-imito-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/MAC/magma-imito-uni.bin) - Not tied to a specific device version (**HLT** after the end of the program)
 
