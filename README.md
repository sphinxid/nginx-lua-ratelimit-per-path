# nginx-lua-ratelimit-per-path
Simple example in nginx to implement rate limit per IP address per Path using nginx Lua.

set_ratelimit_by_ip_and_path(ip, path, limit, period, lua_dict)

Examples:

This will implement rate limit on specific path (/exact/path) inside the `server` block
```
server {
    listen       80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

   location = /exact/path {
        access_by_lua_block {        
            local ip = ngx.var.remote_addr
            local path = ngx.var.uri
            local limit = 10
            local period = 60 -- seconds
            local lua_dict_var = ngx.shared.my_ratelimit

            set_ratelimit_by_ip_and_path(ip, path, limit, period, lua_dict_var)
        } 
    }

    location /prefix/me {
        access_by_lua_block {        
            local ip = ngx.var.remote_addr
            local path = ngx.var.uri
            local limit = 10
            local period = 60 -- seconds
            local lua_dict_var = ngx.shared.my_ratelimit

            set_ratelimit_by_ip_and_path(ip, path, limit, period, lua_dict_var)
        } 
    }
}
```



This will implement rate limit on every path inside the `server` block.
```
server {
    listen       80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    access_by_lua_block {        
        local ip = ngx.var.remote_addr
        local path = ngx.var.uri
        local limit = 10
        local period = 60 -- seconds
        local lua_dict_var = ngx.shared.my_ratelimit

        set_ratelimit_by_ip_and_path(ip, path, limit, period, lua_dict_var)
    } 

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

