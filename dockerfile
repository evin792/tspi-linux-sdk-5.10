FROM ubuntu:22.04
LABEL maintainer="Kevin Wang <wang_jin@outlook.com>"

ENV DEBIAN_FRONTEND=noninteractive

# 备份源列表并更改源
RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak
RUN sed -i 's@http://.*ubuntu.com@http://repo.huaweicloud.com@g' /etc/apt/sources.list

RUN apt update

# 安装指定的软件包
RUN apt install -y git ssh make gcc libssl-dev liblz4-tool expect \
    g++ patchelf chrpath gawk texinfo diffstat binfmt-support \
    qemu-user-static live-build bison flex fakeroot cmake gcc-multilib \
    g++-multilib unzip device-tree-compiler ncurses-dev libgucharmap-2-90-dev \
    bzip2 expat gpgv2 cpp-aarch64-linux-gnu time mtd-utils python2.7 python2 \
    bc sudo bc bsdmainutils

# 再次更新并修复安装
RUN apt update && apt install -y -f

# 创建非root用户
RUN useradd -m -d /home/admin -s /bin/bash admin && \
    echo "admin:admin" | chpasswd

# 修改sudo权限
RUN apt install -y sudo && \
    echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 切换到admin用户并设置工作目录
USER admin
WORKDIR /home/admin

