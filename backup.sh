#!/bin/bash

# Краткое описание сткрипта
# Скрипт осуществляет инкрементальное и полное резервное копирование,
# в зависимости от поставленных некущей даты.
# Инкрементальные бэкапы создаются ежедневно в 00:30, а также ежемесячно
# первого числа каждого месяца, сразу после инкрементального копирования
# за этот день.
# Задания будут запускаться по cron'у.
# Хранятся 30 инкрементальных копий, а так же 12 ежемесячных копий.

# День месяца для полного бэкапа
BACKUP_DAY=1

# Текущий день
CURRENT_DAY=`/bin/date +%e`

# Каталог, которую необходимо бэкапить
INPUT=/share

# Каталог, в которую необходимо бэкапить
OUTPUT=/backups

# Каталог с измененными занными
INCREMENT=increment

# Каталог с текущим бэкапом
CURRENT=current

# Каталог с полным бэкапом за месяц
FULL=full

# Непосредственно само ежедневное резервирование
/usr/bin/rsync -aqc --force --ignore-errors --delete -b --backup-dir=$OUTPUT/$INCREMENT/`/bin/date +%d.%m.%Y` $INPUT $OUTPUT/$CURRENT
# и удаление копий старше 30 дней
/usr/bin/find $OUTPUT/increment/ -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \;

if [ $CURRENT_DAY = $BACKUP_DAY ] ; then
	/usr/bin/rsync -aqc --force --ignore-errors $INPUT $OUTPUT/$FULL/`/bin/date +%d-%m-%Y-%H-%M`
	/usr/bin/find $OUTPUT/$FULL/ -maxdepth 1 -type d -mtime +365 -exec rm -rf {} \;
fi
