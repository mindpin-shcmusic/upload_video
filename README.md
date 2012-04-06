##启动服务

1 启动工程

```
  rails server
```

2 启动 redis

3 开启 resque 队列 接收处理进程

```
  VVERBOSE=1 INTERVAL=1 QUEUE=media_file_encode RAILS_ENV=development rake environment resque:work
```

##一些说明

1 上传视频后，会向  resque 队列放入一个转换FLV格式的请求，所以要启动一个接收处理 resque 队列的进程

2 resque 队列依赖 redis 所以需要启动redis
 

 