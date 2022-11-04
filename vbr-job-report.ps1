$type="Backup"
$jobs=get-vbrjob
$tb="
<!DOCTYPE html>
<html>
<head>
<style>
#customers {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#customers td, #customers th {
  border: 1px solid #ddd;
  padding: 4px;
}

#customers tr:nth-child(even){background-color: #f2f2f2;}

#customers tr:hover {background-color: #ddd;}

#customers th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #04AA6D;
  color: white;
}
</style>
</head>
<body>"


$tb+="<table id='customers'>"
$tb+="<tr>"
$tb+="<th> Job Name : </th>"
$tb+="<th> Type : </th>"
$tb+="<th> High <br> Priority : </th>"
$tb+="<th> Start <br> Time : </th>"
$tb+="<th> Weekly : </t>" 
$tb+="<th> Monthly : </th>" 
$tb+="<th> Yearly : </th>"
$tb+="<th> Retention: </th>"
$tb+="<th> Retain <br> Days : </th>"
$tb+="<th> Deduplication : </th>"
$tb+="<th> Compression <br> Lvl: </th>"
$tb+="<th> Full <br> Backup: </th>"
$tb+="<th>Members : </th>" 
#$tb+="<th>ApproxSize : </th>"
$tb+="<th>Enabled : </th>" 
$tb+="</tr>"

foreach($job in $jobs) 
{
    if($job.TypeToString -match $type)
    {
        $option=$job.getoptions()
        $Members=Get-VBRJobObject -job $job

        $tb+="<tr>"
        $tb+="<td>"+$job.Name+"</td>"  
        $tb+="<td>"+$job.TypeToString+"</td>"
        $tb+="<td>"
        if ( $job.GetJobPriority() -eq "0") 
        {
            $tb+="No"
        }else{
            $tb+="Yes"
        }        
        $td+="</td>"        
               
        $tb+="<td>"+$job.ScheduleOptions.StartDateTimeLocal.ToShortTimeString() +"</td>"
        $tb+="<td>"+$option.GfsPolicy.Weekly.KeepBackupsForNumberOfWeeks+"</td>"
        $tb+="<td>"+$option.GfsPolicy.Monthly.KeepBackupsForNumberOfMonths+"</td>"
        $tb+="<td>"+$option.GfsPolicy.Yearly.KeepBackupsForNumberOfYears+"</td>"        
        $tb+="<td>"+$option.BackupStorageOptions.RetainDaysToKeep+"</td>"
        $tb+="<td>"+$option.BackupStorageOptions.RetainDays+"</td>"
        $tb+="<td>"+$option.BackupStorageOptions.EnableDeduplication+"</td>"
        $tb+="<td>"+$option.BackupStorageOptions.CompressionLevel+"</td>"
        $tb+="<td>"+$option.BackupStorageOptions.EnableFullBackup+"</td>"
        
        
        $tb+="<td>"
        #$tb+="<table><tr>"
        $i=0
        foreach($member in $members)
        {
             if($i -ne 0)
             {
                $tb+="<br>"
             }
             $tb+=$member.Name
#            $tb+="<td>"+$member.Name+"</td>"
#            $tb+="<td>"+$member.ApproxSizeString+"</td>"
             $i++
        }
#        $tb+="</tr></table>"
        $tb+="</td>"        
        $tb+="<td>"+$job.info.IsScheduleEnabled+"</td>"
        $tb+="</tr>"
    }
    
}


$tb+="</table>
</body>
</html>"

#echo $tb

$tb|out-file -FilePath c:\temp\veeam_report.html
