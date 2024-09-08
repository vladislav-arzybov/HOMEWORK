#! /bin/bash
nginx_check() {
  if [[ -f /var/www/html/index.html ]] && [[ $(curl http://127.0.0.1 2> /dev/null) ]]; then
    return 0
  else 
    return 1
  fi;
}
nginx_check
