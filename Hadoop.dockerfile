From centos:6.6
MAINTAINER anthonyy <yangzx@hust.edu.cn>

ADD hadoop-2.7.7.tar.gz /usr/local
COPY jdk-8u131-linux-x64.rpm /usr/local
ADD glibc-2.14.tar.gz /tmp

RUN cd /tmp/glibc-2.14  \
    && mkdir build  \
    && cd build \
    && yum -y install gcc   \
    && ../configure --prefix=/usr/local/glibc-2.14  \
    && make -j4 \
    && make install
    
RUN ln -sf /usr/local/glibc-2.14/lib/libc-2.14.so /lib64/libc.so.6

RUN cd /usr/local   \
    && rpm -i jdk-8u131-linux-x64.rpm   \
    && rm -rf jdk-8u131-linux-x64.rpm

ENV JAVA_HOME=/usr/java/jdk1.8.0_131
ENV PATH=${JAVA_HOME}/bin:$PATH

ENV HADOOP_HOME=/usr/local/hadoop-2.7.7
ENV PATH=${HADOOP_HOME}/bin:${PATH}
ENV HADOOP_PREFIX=${HADOOP_HOME}

RUN cd ${HADOOP_HOME}  \
    && mkdir tmp    \
    && mkdir -p dfs/name    \
    && mkdir -p dfs/data    \
    && echo "export JAVA_HOME=${JAVA_HOME}" >> etc/hadoop/hadoop-env.sh \
    && echo "export HADOOP_PREFIX=${HADOOP_PREFIX}">>etc/hadoop/hadoop-env.sh   \
    && echo "export JAVA_HOME=${JAVA_HOME}">>etc/hadoop/yarn-env.sh \
    && echo "slave1">>etc/hadoop/slaves \
    && echo "slave2">>etc/hadoop/slaves \
    && rpm --rebuilddb  \
    && yum install initscripts -y   \
    && yum -y install which \
    && yum -y install openssh-server    \
    && echo "PermitRootLogin yes">>/etc/ssh/sshd_config \
    && yum -y install openssh-clients   \
    && mkdir /root/.ssh \
    && ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa  \
    && cat /root/.ssh/id_rsa.pub>/root/.ssh/authorized_keys    \
    && echo "   IdentityFile ~/.ssh/id_rsa">>/etc/ssh/ssh_config   \
    && echo "   StrictHostKeyChecking=no" >> /etc/ssh/ssh_config   \
    && chmod 600 /root/.ssh/authorized_keys 

COPY conf/core-site.xml ${HADOOP_HOME}/etc/hadoop
COPY conf/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop
COPY conf/mapred-site.xml ${HADOOP_HOME}/etc/hadoop
COPY conf/yarn-site.xml ${HADOOP_HOME}/etc/hadoop