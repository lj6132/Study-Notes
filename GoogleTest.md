[TOC]

# Git内部原理

## git目录的本质

在新建git时，会在目录下新建一个.git目录，目录里包含几乎所有git存储和操作的东西

>.git
>
>config			  ：项目特有的配置选项
>
>description	 ：仅供GitWeb使用
>
>HEAD			   ：只想当前被检出的分支
>
>index			   ：保存暂存区信息
>
>hooks/			 ：客户端或服务端的钩子脚本
>
>info/				 ：全局性排除（global exclude）文件，放置不希望被记录在.gitignore文件中的忽略模式（ignored patterns）
>
>objects/		   ：存储所有数据内容
>
>refs/    			 ：存储指向数据（分支、远程仓库和标签等）的提交对象的指针，例如tags（tags和SHA-1的关系类似于域名和ip的关系）



## git add和git commit的时候发生了什么？

- 将被改写的文件保存为数据对象
  - 通过git hash-object底层命令，可以将任意数据存到object里，然后返回对应这个对象的唯一key，即后文的SHA-1指针。这里object起到一个对象数据库的作用。git cat-file可以通过key取出对应的数据对象。
  - 具体的，首先将对象类型的开头（如blob、如果是提交对象的话那就是commit开头，如果是树对象的话，那就是tree开头）作为头部信息（方便到时候复原），加一个空格，然后是数据内容的字节数（知道后续原始数据需要读取多少字节），再加个空字节，得到一个头部字符串。例如【blob 16\u0000】。
  - 然后将头部信息和原始数据拼接起来，得到一个新数据。例如【blob 16\u0000Hello World】。
  - 将该字符串进行哈希，得到的就是代表这个数据的SHA-1。
  - 将新数据通过zlib进行压缩。即将【blob 16\u0000Hello World】压缩，写到object下。其中会议SHA-1的前两个字符作为子目录名称，后38个字符作为子目录内文件的名称。
  - 这样一来，给定一个SHA-1，就能够取前两个字符（16进制）定位到子目录，然后在子目录里根据后38个字符定位到对象。通过解压对象，根据头部信息把后面的数据内容还原，就能得到原来的文件、树或提交对象。
- 更新暂存区（git add）
  - 把数据对象也存一份到index暂存区里
- 记录树对象
  - 使用git write-tree底层命令，可以将index**暂存区的内容**写成一个新的树对象文件，也可以将一个已有的树文件打包进暂存区，然后合并为一棵更大的树。
  - 根据index暂存区里的状态，创建一个tree对象。
  - tree对象类似于unix文件系统，一棵书对象包含了一条或者多条树对象记录（类似unix里的entry），每条记录含有一个指向数据对象的SHA-1指针以及相应的模式、类型、文件名信息。（指针和C++里的指针不一样，它其实就是一个key，借助git的对象字典，可以用这个SHA-1的key找到之前压缩好的数据对象）

​	例如，下图中就是一棵树，里面第一行的100644是文件模式，代表普通文件。100755代表可执行文件。120000代表符号链接。然后blob就是文件类型。a906....就是SHA-1哈希值，通过这个哈希值可以从git对象字典中取出存好的文件。README就是文件名。

![20220408111009](.\img\20220408111009.png)

![20220408111129](.\img\20220408111129.png)

- 创建一个***指明顶层树对象***和***父提交***的***提交对象***
  - 通过git commit-tree #tree_SHA# -p #parent_commit#，可以将tree_SHA对应的树进行提交（代表着当前项目的快照），这个树的父提交（也就是你这个节点对应的上一节点，如果是由多个分支合并而来的话，就会有多个父指针）号是parent_commit。提交时会返回这个提交对象对应的的SHA-1值。

​		在一次提交里，会有三类对象：数据对象、本次提交的目录树对象、提交对象。如下图所示。数据对象就是暂存区里的每一个数据，有可能是树，也有可能是文件。本次提交的目录树对象是指将整个暂存区的现状构建成一个树，里面有可能包含子树。提交对象就是本次提交的信息。

![20220409104357](.\img\20220409104357.png)

​		多次提交的情况如下图。下图中有三个提交对象，以third commit的提交对象为例，这个提交对象的SHA-1值为1a410e，父对象为cac0ca对应的上一次提交，意味着他是从cac0ca这个提交上面延续而来的（这个cac0ca是通过HEAD来找到的当前对象的SHA-1值）。通过这个父指针，就可以在git log中回溯得到整个提交历史。提交的内容都是一棵树，组织了这次提交里的所有文件。这次提交里没有修改任何文件，只是把现有的两个文件和d8329f树组装在一起了，所以树里没有多少数据文件，只有指针（也就是这些文件的SHA-1值）。通过这些指针，能找到third commit这个版本里所有的数据对象（从object里可以把对象找出来）

![20220408112750](.\img\20220408112750.png)

- 修改HEAD文件中指向的引用文件 里所记录的SHA-1值，让其值变为新提交的这个对象的SHA-1值。
- 最终object对象里拥有的文件如下图所示。

![20220408115253](.\img\20220408115253.png)

- 总结如下：单个文件会存成数据对象，整个版本的状态会存成树对象，所有的对象都会经过哈希，存到object下（类似linux的一切皆文件）。



## git的包文件

​		根据上一节描述可以知道，一个文件被修改时，哪怕它只修改了一个字符，也会生成新的数据对象。这样的话如果一个容量为k的大文件被修改了n次版本，就会占用n*k的空间，这样空间开销非常大。

​		而在git里，可以通过git gc来对文件进行整理，具体的是将版本进行整理，比如一个22k大的文件version1，和在后面修改了一个字节的文件version2。通过git gc就能将这两个文件进行合并成version1和一个version2_fix，其中version1是文件的完整内容，version2_fix只记录了版本差异。这样就将44k的空间压缩到了22k。

​		在git gc时，会生成一个idx文件，记录包文件中每个子对象的偏移信息，方便快速定位到各个子对象；还会生成一个pack包文件，包含被整理后所有对象的内容。

![20220408165352](.\img\20220408165352.png)

​		如下图所示，一个包文件里包含了这个版本里的所有数据对象信息，这些信息是和其他数据一样，整合成一个长串字符串存储的，所以需要前面的idx文件来记录不同偏移位置的文件是什么，方便快速查找。version2_fix里会记录它引用了version1（图中的b042a6），这样在提取文件时，可以通过version2_fix找到version1，然后将version1和version2_fix合成构成version2，这样会损失一些速度，但是可以减小空间占用。git会时常自动对仓库进行重新打包以节省空间。

![20220408165646](.\img\20220408165646.png)



## git branch和git checkout时发生了什么？

- git branch和git checkout是通过修改HEAD文件来实现的，HEAD文件通常是一个符号引用（就是里面写了一个路径，读取这个路径才能找到当前版本对象）例如，某次HEAD里的内容可能是【ref: refs/heads/master】，refs里记录的是对提交对象的引用，例如master里记录的可能就是当前最新版本的SHA-1值。
- 执行git checkout test时，HEAD里的内容变成了【ref: refs/heads/test】，test里记录的可能是测试分支里的SHA-1.



# Git指令

## 常用指令

- git init：新建.git目录



- git add：将文件添加到暂存区



- git commit：将暂存区内容提交



- git status：查看当前项目中所有文件的状态
- git status -s：紧凑输出文件的状态，M代表modify，A代表add，左列是暂存区的状态，右列是工作区的状态



- **git diff #file_path#**：查看**工作区**文件和**暂存区**快照中的差异
- git diff --staged：查看**暂存区**快照和**最后一次提交**的文件的差异



- git log：看提交日志，可以加上--pretty=oneline这样就可以在一行里显示所有的提交
- git log --graph --pretty=oneline --abbrev-commit：更加易懂的提交日志



- git reset --hard #hash_code#：回退到某个历史版本。注意，回退之后，后面的版本就很难找回来了，除非没有关终端，记得未来的某个版本号。
- git reset HEAD #file_path#：将**暂存区的**某个文件撤销掉，放回工作区。



- **git reflog**：查看引用日志，每一次提交或改变分支，引用日志都会被更新。如果回退了，终端关了，还想找到未来的版本，可以在这里看到所有命令以及每次命令对应的版本号，通过版本号来恢复。



- git checkout -- #file_path#：让**工作区的**文件回到最近一次git add或git commit时的状态，其实就是用版本库里的版本替换工作区的版本。**注意：**--非常重要，如果没有--，就表示切换到另一个分支的命令
- git checkout -b #branch_name#：切换分支到branch_name上，-b表示创建并切换，相当于执行了git branch #branch_name#和git checkout #branch_name#



- git switch #branch_name#：切换分支，和git checkout效果一样，更容易理解



- git branch：列出所有分支
- git branch -d #branch_name#：删除某个分支



- **git stash**：把当前**工作区**的内容先存起来，这时可以去干别的事，干完再恢复工作区就好
- git stash list：查看stash区里存的内容
- git stash pop：把stash区的内容恢复到工作区里，并从list里删除。相当于先git stash apply #stash_code#，再git stash drop #stash_code#



- git cherry-pick #hash_code#：把某次提交的内容应用到当前分支上（移花接木，懒得重复执行某次更改时可以用这个），这也是变基的底层命令。



- git push origin master：把本地master分支推送到origin远程库上，如果要推送dev分支的话就git push origin dev



- git fetch <remote> ：从远程仓库中拉取所有你还没有的数据，和git pull不同的地方在于，git pull拉去后会自动将远程分支和本地分支合并，而git fetch只会把文件拉下来，不会动本地的工作，需要自己手动来处理冲突并合并两个分支的工作。



- git merge #branch_name#：合并**指定分支**到**当前分支**。如果没有冲突的话，就会显示Fast-forward，即直接把master指向#branch_name#的当前提交。中间带上--no-ff的话会更安全，表示禁用Fast-forward模式，因为在Fastforward模式下，被合并分支的信息就丢失了，而禁用的话，就会给被合并分支创建一个commit（所以--no-ff后面还要加-m，给这次commit附带提交信息），这样就能在日志里找到这个分支，方便以后回退。如果发生冲突了，根据提示找到冲突文件，把里面的内容手动改了，把<<<<<和>>>>>这些提示删掉，对这些冲突文件进行git add和git commit，就能将两个分支合并起来了。



- git rebase #branch_name#：将**当前所在分支**变基到#branch_name#上，实际上是把当前分支所作的所有修改，在#branch_name#上重放一遍，结果和merge是一样的，只是提交记录变成了一根直线，整洁美观一点。但这个操作有风险，因为变基之后，当前分支的历史记录都消失了，如果别人基于当前分支还在开发，那相当于把他的分支的“祖先”变没了，造成严重影响，所以使用时要保证没有基于当前分支的其他子分支。



- git pull：相当于先git fetch再git merge，拉下**服务器**上**当前分支**上的本地没有的数据，然后自动合并。常用发生的情况是你提交的时候，发现别人已经提交过了，你本地的版本落后了，所以要先git pull把远程库上的新版本拉下来，本地解决冲突，git commit，重新git push origin #branch_name#推送到远程库上。



- git tag #tag_name#：给提交打标签，这样就不用记住一长串哈希值。默认给当前分支的最新提交打标签
- git tag -a #tag_name# -m "#comment#" #hash_code#：给某次提交打标签，hash_code可以通过git log查看



- git show #tag_name#：查看某次标签详细内容



- git rm：从版本库里删除一个文件，在工作目录删除文件之后，还要用这个来将文件移出版本管理的范围。



- git remote -v：查看对应的远程仓库信息
- git remote show #branch_name#：查看远程仓库的所有分支的信息



参考图：

![20220409114546](.\img\20220409114546.png)



# 辅助指令

- git config --global user.name ''#name#''：全局配置用户名信息
- git config --global user.email #email#：全局配置邮件地址
- git config --list --show-origin：查看git配置
- git help #command_name#：查看command_name的帮助手册
- git #command_name# -h：查看command_name后面可以带的选项



# 部分细节

## git是怎么对数据进行哈希的？

​		git将任意文件视为字符串，通过FNV算法计算出hash值。

```c++
#define FNV32_BASE ((unsigned int) 0x811c9dc5)
#define FNV32_PRIME ((unsigned int) 0x01000193)

unsigned int strhash(const char* str)
{
    unsigned int c, hash = FNV32_BASE;
    while ((c = (unsigned char)*str++))
        hash = (hash * FNV32_PRIME) ^ c;
    return hash;
}
```

