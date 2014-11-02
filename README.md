# A Salt formula for installing MySQL with basic tuning

This formula installs mysql and generates a mysql root user password in
addition to some very basic tuning based on the total system memory available.

#### Pillar
```yaml
# Do not provide or leave the mysql section empty to take advantage of the
# autotune.
mysql:
  # Size of the key buffer in MB
  # Default: 5% of the available system memory
  #key_buffer_size: 10M

  # Size of the innodb buffer pool in MB
  # Default: 75% of the available system memory
  # innodb_buffer_pool_size: 1024M

  # The id of the server (only useful in replication scenraios)
  # By default this is not used unless it is set
  # server_id: 1

  # If set to true, this will turn on binary logging
  # By default this is no used unless it is set
  # master: True

# The 'private' interface determines what mysqld binds to.
interfaces:
  # Default: eth0
  private: eth0
```

#### Tuning
This formula will set the innodb_buffer_pool_size and and key_buffer_size
based on the available system memory. This formula assumes that the machine
this formula is applied to will only host mysql. In addition the following
parameters are always set:

```ini
innodb_flush_method     = O_DIRECT
innodb_flush_log_at_trx_commit = 1
```

#### How to use
If applying from a top file:
```shell
salt <sync-targets> state.highstate
```
Or if applying explicitly:
```shell
salt <sync-targets> state.sls mysql
```

#### Helpful links
* [MySQL](http://www.mysql.com/)
