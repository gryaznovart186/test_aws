## Инструкция по запуску
1. Сгенерировать SSH ключь если его нет (`ssh-keygen`) Ключь необходим для подключения по ssh к ВМ
2. Переименовать terraform.tfvars.example в terraform.tfvars и заполнить ключи для доступа к AWS(Если ключей нет можно создать и скачать ключи здесь https://console.aws.amazon.com/iam/home?region=us-east-2#/security_credentials)
3. Выполнить команду terraform init 
4. Выполнить комманду terraform apply(необходимо подтверждение запуска или флаг --auto-approve). При этом:
    * Будет создан объект aws_key_pair для доступа к вм по ssh (необходимы ключи из первого пункта)
    * Будет создан объект aws_security_group с входящими правилами для ssh и http, и исходящим правилом без ограничений
    * Будет создан aws_instance типа t2.micro с CentOS7 на который в итоге с помощью ансибла будет установлен докер и запущены докер контейнеры с ffmpeg и nginx
    * В output будет выведен публичные ip и dns 
5. Зайти через браузер по ip или dns из output: должна открыться страница с последней картинкой из стрима `rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov`
6. Удалить созданые объекты с помощью команды terraform destroy(необходимо подтверждение запуска или флаг --auto-approve)