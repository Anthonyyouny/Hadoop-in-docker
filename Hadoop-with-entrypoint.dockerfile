FROM anthonyy/hadoop-2.7.7:v5
MAINTAINER anthonyy <yangzx@hust.edu.cn>


COPY hadoop-entrypoint.sh /usr/bin/
RUN chmod a+x /usr/bin/hadoop-entrypoint.sh

ENTRYPOINT [ "sh", "-c", "./usr/bin/hadoop-entrypoint.sh; bash"]
