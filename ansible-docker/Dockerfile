FROM centos:latest

RUN yum -y update && yum clean all
RUN yum -y install epel-release
RUN yum -y install openssh-server \
                    openssh-clients \ 
                    openssh \
                    ansible \
                    passwd

RUN mkdir /root/.ssh
WORKDIR /root/ansible_files
COPY . /root/ansible_files


RUN /usr/bin/ssh-keygen -A

EXPOSE 22

RUN rm -rf /run/nologin

CMD /usr/sbin/sshd -D

RUN ansible-playbook -i host_file playbook.yml