English | [Русский](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/README-ru_RU.md)

# Magma - Counter mode (CTR)

Counter mode implementation for Intel 8080A processor.

* Encryption/decryption in blocks of **64 bits**.
* Key **256 bit**.
* Cost: **~156 000 ticks** per call (**~16 calls/s**).
* Encryption/Decryption Speed: up to **1 Kbit/s**.


## A set of subroutines

To facilitate the use of the algorithm, the main subroutines are collected in a single "library" - **gmagma** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/gmagma.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/gmagma.bin) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/gmagma.rk).  
The programmer just needs to call the required subroutines and read the result at a fixed address.  
4 public subroutines and 2 public values ​​are available - the following addresses are valid for them:

|  Subroutine  |                  Purpose                 |  Address  |
| :----------: | :--------------------------------------: | :-------: |
|    magexe    | Process 64-bit block at an address in HL | org + 0h  |
|    initiv    |        Initialize Init. Vector (IV)      | org + 1Ch |
|    setkey    |     Setting a key at an address in HL    | org + 2Bh |
|    setiv     |     Setting the IV at an address in HL   | org + 37h |

|  Value   | Length (bytes) |   Description   |  Address   |
| :------: | :------------: | :-------------: | :--------: |
|   key    |       32       |  Encryption key | org + 214h |
|  inivc   |       8        |   Init. Vector  | org + 234h |


Files **bin** and **rk** imply loading their code to **7000h**. Accordingly addresses:

|   Name   | Address |
| :------: | :-----: |
|  magexe  |  7000h  |
|  initiv  |  701Ch  |
|  setkey  |  702Bh  |
|  setiv   |  7037h  |
|   key    |  7214h  |
|  inivc   |  7234h  |

The encryption/decryption result will always be located at **data**.


## Examples

Examples of crypting program (**Magma-gCrypto**):  
 * **magma-gcrypto-86rk** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-86rk.asm) [(.rk)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-86rk.rk) - Version for PC **Radio-86RK** (with display)  
 * **magma-gcrypto-uni** [(.asm)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-uni.asm) [(.bin)](https://github.com/Bs0Dd/magma-8080/blob/main/CTR/magma-gcrypto-uni.bin) - Not tied to a specific device version (**HLT** after the end of the program)
 
