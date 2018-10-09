# About asmFishCP
This is a branch that contains extra (non-chronological) patches in order to keep asmFish
as competitive as possible. Due to the tedious nature of upkeeping assembly code, it is 
often the case that asmFish lags behind SF Dev by several months. This branch 
aims to compensate for this lag by providing immediate access to critical and/or easily 
portable patches. 

# Bench Matching
Because patches are often applied in a non-chronological fashion, all releases also include
a recompiled version of Stockfish, located in the **benchMatch** folder. For versions of asmFish 
that correspond to previous versions of official SF-releases, please refer to [lantonov/asmFish](https://github.com/lantonov/asmFish),
which I will also try to update as often as possible.

# BMI2/BMI1/popcnt/base Executables

### Instructions contained in BMI2 but not BMI1
BMI2 is an instruction set that includes all instructions in the BMI1 instruction set and the following additional instructions:

|Instruction|	Description|
|--|--|
|BZHI|	Zero high bits starting with specified bit position |
|MULX|	Unsigned multiplication without affecting flags	|
|PDEP|	Parallel bits deposit |
|PEXT|	Parallel bits extract |
|RORX|	Rotate right logical without affecting flags|
|SARX|	Shift arithmetic right without affecting flags|
|SHRX|	Shift logical right without affecting flags|
|SHLX|	Shift logical left without affecting flags|

The two most important "extra" instructions of BMI2 are the very nice [PEXT](https://www.felixcloutier.com/x86/PEXT.html) and [PDEP](https://www.felixcloutier.com/x86/PDEP.html) instructions. BMI2 instructions are supported by Haswell+ (Intel) and Excavator+ (AMD) processors.  
  
### Instructions contained in BMI1 but not popcnt
The difference between popcnt (modern) and BMI1 is that BMI1 contains the following "extra" instructions:

|Instruction | Description			                     | C/C++						|
|------------|-------------------------------------------|--------------------------------------|
|ANDN	     | Logical and not							 | ~x & y								|
|BEXTR	     | Bit field extract (with register)	     | (src >> start) & ((1 << len) - 1)	|
|BLSI	     | Extract lowest set isolated bit			 | x & -x								|
|BLSMSK	     | Get mask up to lowest set bit		     | x ^ (x - 1)							|
|BLSR	     | Reset lowest set bit						 | x & (x - 1)							|
|TZCNT	     | Count  zero bits	 | n/a								|

Of these, [TZCNT](https://www.felixcloutier.com/x86/TZCNT.html) and [BEXTR](https://www.felixcloutier.com/x86/BEXTR.html) probably result in the most speed-up, but the others are definitely nice too.

The two most important "extra" instructions of BMI2 are the very nice PEXT and PDEP instructions. BMI2 instructions are supported by Haswell+ (Intel) and Excavator+ (AMD) processors.

### Which build should you use?  
It is up to you to research the capabilities of your processor, but in general, you should keep in mind the following points:  

 1. Some AMD processors are only capable of using BMI1 and not BMI2.
  
 2. All Intel processors that can use BMI2 can also use BMI1.
  
 3. You should only use BMI1 if you are an AMD-owner whose processor is BMI1-capable but not BMI2-capable.
 
 4. If you cannot use BMI2, BMI1, or popcnt, then you should use the base executable, which contains macros to simulate the higher-level instructions.

