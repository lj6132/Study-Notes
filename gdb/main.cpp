#include <stdlib.h>
#include <stdio.h>
#include <iostream>

using namespace std;


int gcb(int a, int b)
{
    return b ? gcb(b, a % b) : a;
}

int main()
{
    int a, b;

    a = 233;
    b = 2342;
#ifdef tt
    a = 26;
    b = 39;
#endif
    int res = gcb(a, b);
    std::cout << res << endl;
    return 0;
}

// g++ -Dtt main.cpp -o main -g 就可以设置宏tt，一般是#ifdef DEBUG来切换调试模式，或者#ifdef Win32切换系统版本
// g++ main.cpp -o main -g      就是没有设置宏tt的情况

// gdb main                     启动gdb
// b 23                         在int res = gcb(a, b);这一行打断点
// r                            运行程序，会停在第23行
// info b                       查看所有断点的进入情况
// s                            单步执行，进入到gcb里的return行，可以看到形参a和b的值。用于判断宏tt有没有生效

//                              直接敲回车，重复执行上一条指令
//                              同上

// pt                           pstacktrace查看进程调用栈
// frame 3                      查看pt中第三个栈帧的信息
// info frame                   查看当前所处栈帧的详细信息
// info args                    查看当前函数的参数
// info locals                  查看当前作用域中的局部变量

// n                            直接执行完整个gcb函数
// q                            退出整个调试进程