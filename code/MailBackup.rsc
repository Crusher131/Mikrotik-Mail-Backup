# Altere de acordo com sua necessidade

:local varassunto "Backup Mikrotik";
:local vardestino "Email de destino";
:local varcorpo "Corpo do e-mail";

# Gera a data de forma aceitavel para nome de arquivos
:global backupfn;
:local filename;

:local date [/system clock get date];
:local time [/system clock get time];
:local name [/system identity get name];

:local months ("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec");
:local varHour [:pick $time 0 2];
:local varMin [:pick $time 3 5];
:local varSec [:pick $time 6 8];
:local varMonth [:pick $date 0 3];
:set varMonth ([ :find $months $varMonth -1 ] + 1);

:if ($varMonth < 10) do={ :set varMonth ("0" . $varMonth); }

:local varDay [:pick $date 4 6];
:local varYear [:pick $date 7 11];
:set filename ($name. " - Data " .$varDay."-".$varMonth."-".$varYear." Hora ".$varHour.":".$varMin);

# From E-mail
:local fromto [/tool e-mail get user];

# Nome
:local name [/system identity get];

# file name for system backup 
:global backupfn ("Mikrotik - ".$filename.".backup");
:log info message="$filename";

# backup the data
/system backup save name="$backupfn";
:delay 10s;

# Envia E-mail Com Backup como anexo
/tool e-mail send to=$vardestino file=$backupfn subject=$varassunto body=$varcorpo;
/tool e-mail send to=$fromto file=$backupfn subject=$varassunto body=$varcorpo;
:delay 15;

# Remove Arquivo de backup
/file remove $backupfn;
