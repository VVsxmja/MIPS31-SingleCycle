# MIPS31-SingleCycle

同济大学 计算机组成原理 MIPS31 作业

## 简介

实现了MIPS ISA的一个子集。没有实现协处理器。

使用哈佛架构实现，即指令内存和数据内存互相隔离。

为了方便使用 [MARS](https://courses.missouristate.edu/kenvollmar/mars/) 生成 
MIPS 汇编代码的标准执行结果来和 CPU 运行的结果进行比对，在顶层模块对代码段和数据段的起始位置做了映射。

该 MIPS 子集的细节见 `datapath.xlsx`

## 一些工具

## `dumpcoe/dumpcoe.bat`

使用 MARS 生成 MIPS 汇编代码汇编后的 hex 形式，输出到 COE 文件。

用法见脚本内的注释