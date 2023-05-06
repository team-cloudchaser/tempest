FROM docker.io/ltgc/gel

# Set working environment up
WORKDIR /root

# Copy and run
COPY ./shared/etc/ /root/etc/
COPY ./shared/sh/ /root/sh/shared
COPY ./etc/ /root/etc/
COPY ./sh/ /root/sh/distro
#RUN sh /root/sh/distro/init.sh
RUN bash /root/sh/shared/setup.sh
#RUN bash /root/sh/distro/setup.sh
#RUN bash /root/sh/shared/post.sh

# Run forever
EXPOSE 1122
CMD ["/sbin/init"]
#CMD ["sleep", "infinity"]