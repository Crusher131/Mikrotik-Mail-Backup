/system script
add dont-require-permissions=no name=MailBackup owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# Altere de acordo\
    \_com sua necessidade\r\
    \n\r\
    \n:local varassunto \"Backup Mikrotik\";\r\
    \n:local vardestino \"Emaildedestino\";\r\
    \n:local varcorpo \"corpo do email\";\r\
    \n\r\
    \n# Gera a data de forma aceitavel para nome de arquivos\r\
    \n:global backupfn;\r\
    \n:local filename;\r\
    \n\r\
    \n:local date [/system clock get date];\r\
    \n:local time [/system clock get time];\r\
    \n:local name [/system identity get name];\r\
    \n\r\
    \n:local months (\"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\");\r\
    \n:local varHour [:pick \$time 0 2];\r\
    \n:local varMin [:pick \$time 3 5];\r\
    \n:local varSec [:pick \$time 6 8];\r\
    \n:local varMonth [:pick \$date 0 3];\r\
    \n:set varMonth ([ :find \$months \$varMonth -1 ] + 1);\r\
    \n\r\
    \n:if (\$varMonth < 10) do={ :set varMonth (\"0\" . \$varMonth); }\r\
    \n\r\
    \n:local varDay [:pick \$date 4 6];\r\
    \n:local varYear [:pick \$date 7 11];\r\
    \n:set filename (\$name. \" - Data \" .\$varDay.\"-\".\$varMonth.\"-\".\$varYear.\" Hora \".\$varHour.\":\".\$varMin);\r\
    \n\r\
    \n# From E-mail\r\
    \n:local fromto [/tool e-mail get user];\r\
    \n\r\
    \n# Nome\r\
    \n:local name [/system identity get];\r\
    \n\r\
    \n# file name for system backup \r\
    \n:global backupfn (\"Mikrotik - \".\$filename.\".backup\");\r\
    \n:log info message=\"\$filename\";\r\
    \n\r\
    \n# backup the data\r\
    \n/system backup save name=\"\$backupfn\";\r\
    \n:delay 10s;\r\
    \n\r\
    \n# Envia E-mail Com Backup como anexo\r\
    \n/tool e-mail send to=\$vardestino file=\$backupfn subject=\$varassunto body=\$varcorpo;\r\
    \n/tool e-mail send to=\$fromto file=\$backupfn subject=\$varassunto body=\$varcorpo;\r\
    \n:delay 15;\r\
    \n\r\
    \n# Remove Arquivo de backup\r\
    \n/file remove \$backupfn;\r\
    \n"
/system scheduler
add interval=1d name=Backup_Mail on-event=MailBackup policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=mar/03/2020 \
    start-time=12:00:0
