FROM ruby

RUN apt-get update
RUN apt-get install -y nodejs
RUN gem install jekyll

RUN apt-get install -y openssh-server supervisor vim
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD . /code
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /code
CMD ["/usr/bin/supervisord"]

EXPOSE 4000 22
