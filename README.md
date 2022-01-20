English | [Русский](https://github.com/Bs0Dd/magma-8080/blob/main/README-ru_RU.md)

# GOST 28147-89 "Magma" for Intel 8080A

![Title](https://raw.githubusercontent.com/Bs0Dd/magma-8080/main/86rk.png)

Encryption algorithm implementation for Intel 8080A processor.

* Encryption/decryption in blocks of **64 bits**.
* Key **256 bit**.
* Electronic Codebook mode (ECB).
* Cost: **~156 000 ticks** per call (**~16 calls/s**).
* Encryption/Decryption Speed: up to **1 Kbit/s**.


## A set of subroutines

To facilitate the use of the algorithm, the main subroutines are collected in a single "library" - **magma** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/magma.bin) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/magma.rk).  
The programmer just needs to call the required subroutines and read the result at a fixed address.  
4 public subroutines and 2 public values ​​are available - the following addresses are valid for them:

|  Subroutine  |               Purpose               |  Address  |
| :----------: | :---------------------------------: | :-------: |
|    magenc    |        64-bit block encoding        | org + 0h  |
|    magdec    |        64-bit block decoding        | org + Сh  |
|    setdat    | Setting a block at an address in HL | org + 18h |
|    setkey    |  Setting a key at an address in HL  | org + 24h |

|  Value   | Length (bytes) |   Description   |  Address   |
| :------: | :------------: | :-------------: | :--------: |
|   key    |       32       | Encryption key  | org + 1D5h |
|   data   |       8        |   Data block    | org + 1F5h |


Files **bin** and **rk** imply loading their code to **7000h**. Accordingly addresses:

|   Name   | Address |
| :------: | :-----: |
|  magenc  |  7000h  |
|  magdec  |  700Ch  |
|  setdat  |  7018h  |
|  setkey  |  7024h  |
|   key    |  71D5h  |
|   data   |  71F5h  |

The encryption/decryption result will always be located at **data**.


## Examples

Examples with direct inline algorithm:  
 * **magma-d-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-d-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-d-86rk.rk) - Version for PC **Radio-86RK** (with display of values)  
 * **magma-d-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-d-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-d-uni.bin) - Not tied to a specific device version (**HLT** after the end of the program)

Examples using a set of routines (at **7000h**):  
 * **magma-ld-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-ld-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-ld-86rk.rk) - Version for PC **Radio-86RK** (with display of values)  
 * **magma-ld-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-ld-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-ld-uni.bin) - Not tied to a specific device version (**HLT** after the end of the program)

Examples of crypting program (**Magma-Crypto**):  
 * **magma-crypto-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-crypto-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-crypto-86rk.rk) - Version for PC **Radio-86RK** (with display)  
 * **magma-crypto-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-crypto-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/magma-crypto-uni.bin) - Not tied to a specific device version (**HLT** after the end of the program)
 
## References

The programs are based on material from [this](https://spy-soft.net/magma-encryption/) article.
