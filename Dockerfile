FROM ghcr.io/srl-labs/clab:0.81.1
RUN apk --no-cache add supervisor \
                       openvswitch
# ////////////// Open vSwitch Section ////////////// #

# Create database and pid file directory
RUN mkdir -pv /var/run/openvswitch/ && \
    /usr/bin/ovsdb-tool create /etc/openvswitch/conf.db && \
    /usr/sbin/ovsdb-server --remote=punix:/var/run/openvswitch/db.sock --run "/usr/bin/ovs-vsctl --no-wait init"


# Add supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf


# When container starts, supervisord is executed
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
