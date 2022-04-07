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
>index			   ：保存残存区信息
>
>hooks/			 ：客户端或服务端的钩子脚本
>
>info/				 ：全局性排除（global exclude）文件，放置不希望被记录在.gitignore文件中的忽略模式（ignored patterns）
>
>objects/		   ：存储所有数据内容
>
>refs/    			 ：存储只想数据（分支、远程仓库和标签等）的提交对象的指针





# Git指令

- git init：新建.git目录
- git add
- git commit
- git status：
- git diff #file_path#：查看文件中的修改内容
- git log：看提交日志，可以加上--pretty=oneline这样就可以在一行里显示所有的提交。
- git log --graph --pretty=oneline --abbrev-commit：更加易懂的提交日志
- git reset --hard #hash_code#：回退到某个历史版本。注意，回退之后，后面的版本就很难找回来了，除非没有关终端，记得未来的某个版本号。
- git reset HEAD #file_path#：将**暂存区的**某个修改撤销掉，放回工作区。
- git reflog：如果回退了，终端关了，还想找到未来的版本，可以在这里看到所有命令以及每次命令对应的版本号，通过版本号来恢复。
- git checkout -- #file_path#：让**工作区的**文件回到最近一次git add或git commit时的状态，其实就是用版本库里的版本替换工作区的版本。**注意：**--非常重要，如果没有--，就表示切换到另一个分支的命令
- git checkout -b #branch_name#：切换分支到branch_name上，-b表示创建并切换，相当于执行了git branch #branch_name#和git checkout #branch_name#
- git switch #branch_name#：切换分支，和git checkout效果一样，更容易理解
- git branch：列出所有分支
- git branch -d #branch_name#：删除某个分支
- git merge #branch_name#：合并**指定分支**到**当前分支**。如果没有冲突的话，就会显示Fast-forward，即直接把master指向#branch_name#的当前提交。中间带上--no-ff的话会更安全，表示禁用Fast-forward模式，因为在Fastforward模式下，被合并分支的信息就丢失了，而禁用的话，就会给被合并分支创建一个commit（所以--no-ff后面还要加-m，给这次commit附带提交信息），这样就能在日志里找到这个分支，方便以后回退。如果发生冲突了，根据提示找到冲突文件，把里面的内容手动改了，把<<<<<和>>>>>这些提示删掉，对这些冲突文件进行git add和git commit，就能将两个分支合并起来了。
- **git stash**：把当前**工作区**的内容先存起来，这时可以去干别的事，干完再恢复工作区就好
- git stash list：查看stash区里存的内容
- git stash pop：把stash区的内容恢复到工作区里，并从list里删除。相当于先git stash apply #stash_code#，再git stash drop #stash_code#
- git cherry-pick #hash_code#：把某次提交的内容应用到当前分支上
- git remote -v：查看远程库的信息
- git push origin master：把本地master分支推送到origin远程库上，如果要推送dev分支的话就git push origin dev
- git pull：将远程库上的版本拉下来。常用发生的情况是你提交的时候，发现别人已经提交过了，你本地的版本落后了，所以要先git pull把远程库上的新版本拉下来，本地解决冲突，git commit，重新git push origin #branch_name#推送到远程库上。
- git tag #tag_name#：给提交打标签，这样就不用记住一长串哈希值。默认给当前分支的最新提交打标签。
- git tag -a #tag_name# -m "#comment#" #hash_code#：给某次提交打标签，hash_code可以通过git log查看。
- git show #tag_name#：查看某次标签详细内容

- git rm：从版本库里删除一个文件



# 辅助指令

- find .git/objects -type f：查找objects下所有文件，-type是自动判断文件类型
- 