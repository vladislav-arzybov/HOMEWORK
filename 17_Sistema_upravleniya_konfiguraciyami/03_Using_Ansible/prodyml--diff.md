```
reivol@Zabbix:~/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [CLICKHOUSE | Get clickhouse distrib] ******************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)

TASK [CLICKHOUSE | Get clickhouse-common-static distrib] ****************************************************************************************************************************************
changed: [clickhouse-01]

TASK [CLICKHOUSE | Install clickhouse packages] *************************************************************************************************************************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start clickhouse service] ******************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [CLICKHOUSE | Pause for 5 seconds to become available clickhouse-server] *******************************************************************************************************************
Pausing for 5 seconds (output is hidden)
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [CLICKHOUSE | Create database] *************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [VECTOR | Create dir] **********************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/vector/",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [VECTOR | Get vector distrib] **************************************************************************************************************************************************************
changed: [vector-01]

TASK [VECTOR | Unarchive vector] ****************************************************************************************************************************************************************
changed: [vector-01]

TASK [VECTOR | Copy bin file vector] ************************************************************************************************************************************************************
changed: [vector-01]

TASK [VECTOR | Copy systemd service vector] *****************************************************************************************************************************************************
changed: [vector-01]

TASK [VECTOR | Create user vector] **************************************************************************************************************************************************************
changed: [vector-01]

TASK [VECTOR | Create vector catalog] ***********************************************************************************************************************************************************
--- before
+++ after
@@ -1,6 +1,6 @@
 {
-    "group": 0,
-    "owner": 0,
+    "group": 1003,
+    "owner": 1002,
     "path": "/var/lib/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [VECTOR | Create default vector config catalog and vector.toml] ****************************************************************************************************************************
changed: [vector-01]

TASK [VECTOR | Config vector j2 template] *******************************************************************************************************************************************************
--- before: /etc/vector/vector.toml
+++ after: /home/reivol/.ansible/tmp/ansible-local-19471n9r6pf3y/tmpjeppesdh/vector.toml.j2
@@ -4,7 +4,7 @@
 #                                      \_/  \/
 #
 #                                    V E C T O R
-#                                   Configuration
+#                                   Configuration by ReiVol
 #
 # ------------------------------------------------------------------------------
 # Website: https://vector.dev
@@ -15,6 +15,7 @@
 # Change this to use a non-default directory for Vector data storage:
 # data_dir = "/var/lib/vector"
 
+#ReiVol
 # Random Syslog-formatted logs
 [sources.dummy_logs]
 type = "demo_logs"

changed: [vector-01]

RUNNING HANDLER [Start vector service] **********************************************************************************************************************************************************
changed: [vector-01]

PLAY [Install lighthouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [LIGHTHOUSE | Install git] *****************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [LIGHTHOUSE | Get distrib] *****************************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

PLAY [Install nginx] ****************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [NGINX | Install epel-release] *************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [NGINX | Install nginx] ********************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [NGINX | Configure nginx config for site] **************************************************************************************************************************************************
--- before: /etc/nginx/nginx.conf
+++ after: /home/reivol/.ansible/tmp/ansible-local-19471n9r6pf3y/tmptzg3b1qn/nginx.cfg.j2
@@ -1,84 +1,19 @@
-# For more information on configuration, see:
-#   * Official English Documentation: http://nginx.org/en/docs/
-#   * Official Russian Documentation: http://nginx.org/ru/docs/
-
-user nginx;
-worker_processes auto;
-error_log /var/log/nginx/error.log;
-pid /run/nginx.pid;
-
-# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
-include /usr/share/nginx/modules/*.conf;
+worker_processes  1;
+user root;
 
 events {
-    worker_connections 1024;
+    worker_connections  1024;
 }
 
+
 http {
-    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
-                      '$status $body_bytes_sent "$http_referer" '
-                      '"$http_user_agent" "$http_x_forwarded_for"';
+    include       mime.types;
+    default_type  application/octet-stream;
 
-    access_log  /var/log/nginx/access.log  main;
 
-    sendfile            on;
-    tcp_nopush          on;
-    tcp_nodelay         on;
-    keepalive_timeout   65;
-    types_hash_max_size 4096;
+    sendfile        on;
 
-    include             /etc/nginx/mime.types;
-    default_type        application/octet-stream;
+    keepalive_timeout  65;
 
-    # Load modular configuration files from the /etc/nginx/conf.d directory.
-    # See http://nginx.org/en/docs/ngx_core_module.html#include
-    # for more information.
     include /etc/nginx/conf.d/*.conf;
-
-    server {
-        listen       80;
-        listen       [::]:80;
-        server_name  _;
-        root         /usr/share/nginx/html;
-
-        # Load configuration files for the default server block.
-        include /etc/nginx/default.d/*.conf;
-
-        error_page 404 /404.html;
-        location = /404.html {
-        }
-
-        error_page 500 502 503 504 /50x.html;
-        location = /50x.html {
-        }
-    }
-
-# Settings for a TLS enabled server.
-#
-#    server {
-#        listen       443 ssl http2;
-#        listen       [::]:443 ssl http2;
-#        server_name  _;
-#        root         /usr/share/nginx/html;
-#
-#        ssl_certificate "/etc/pki/nginx/server.crt";
-#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
-#        ssl_session_cache shared:SSL:1m;
-#        ssl_session_timeout  10m;
-#        ssl_ciphers HIGH:!aNULL:!MD5;
-#        ssl_prefer_server_ciphers on;
-#
-#        # Load configuration files for the default server block.
-#        include /etc/nginx/default.d/*.conf;
-#
-#        error_page 404 /404.html;
-#            location = /40x.html {
-#        }
-#
-#        error_page 500 502 503 504 /50x.html;
-#            location = /50x.html {
-#        }
-#    }
-
-}
-
+}
\ No newline at end of file

changed: [lighthouse-01]

TASK [NGINX | Make config for lighthouse] *******************************************************************************************************************************************************
--- before
+++ after: /home/reivol/.ansible/tmp/ansible-local-19471n9r6pf3y/tmpmqefad69/default.cfg.j2
@@ -0,0 +1,20 @@
+server {
+    listen       80;
+    server_name  localhost;
+
+    #access_log  /var/log/nginx/host.access.log  main;
+
+    location / {
+        root   /home/reivol/lighthouse;
+        index  index.html index.htm;
+    }
+
+    #error_page  404              /404.html;
+
+    # redirect server error pages to the static page /50x.html
+    #
+    error_page   500 502 503 504  /50x.html;
+    location = /50x.html {
+        root   /usr/share/nginx/html;
+    }
+}
\ No newline at end of file

changed: [lighthouse-01]

RUNNING HANDLER [start nginx] *******************************************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [restart nginx] *****************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP **************************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
lighthouse-01              : ok=10   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
