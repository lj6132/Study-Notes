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

// g++ -Dtt main.cpp -o main -g �Ϳ������ú�tt��һ����#ifdef DEBUG���л�����ģʽ������#ifdef Win32�л�ϵͳ�汾
// g++ main.cpp -o main -g      ����û�����ú�tt�����

// gdb main                     ����gdb
// b 23                         ��int res = gcb(a, b);��һ�д�ϵ�
// r                            ���г��򣬻�ͣ�ڵ�23��
// info b                       �鿴���жϵ�Ľ������
// s                            ����ִ�У����뵽gcb���return�У����Կ����β�a��b��ֵ�������жϺ�tt��û����Ч

//                              ֱ���ûس����ظ�ִ����һ��ָ��
//                              ͬ��

// pt                           pstacktrace�鿴���̵���ջ
// frame 3                      �鿴pt�е�����ջ֡����Ϣ
// info frame                   �鿴��ǰ����ջ֡����ϸ��Ϣ
// info args                    �鿴��ǰ�����Ĳ���
// info locals                  �鿴��ǰ�������еľֲ�����

// n                            ֱ��ִ��������gcb����
// q                            �˳��������Խ���