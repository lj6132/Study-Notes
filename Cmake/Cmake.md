[TOC]

[CMake教程](https://blog.csdn.net/weixin_43669941/article/details/112913301)

# cmake概念







# 示例

1、准备好源代码calculatesqrt.cpp

```c++
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char* argv[])
{
	if (argc < 2){
		fprintf(stdout, "Usage: %s number\n", argv[0]);
		return 1;
	}

	double inputValue = atof(argv[1]);
	double outputValue = sqrt(inputValue);
	fprintf(stdout, "The square root of %g is %g\n", inputValue, outputValue);
	return 0;
}
```

2、写CMakeLists.txt

```makefile
cmake_minimum_required(VERSION 2.8)

#set the project name
project(CalculateSqrt)

#add the excutablea
add_executable(CalculateSqrt calculatesqrt.cpp)
```

3、新建一个build文件夹

4、在build文件夹下输入指令

```bash
#去父目录下自动找CMakeLists.txt
cmake ..
```

![20220424162930](..\img\20220424162930.png)

5、输入指令进行编译

```bash
#编译
make
```

![20220424163048](..\img\20220424163048.png)

6、完成编译

![20220424163253](..\img\20220424163253.png)
