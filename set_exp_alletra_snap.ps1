$LUN="LUN01"
$Prefix="VeeamAUX_"
$NewPrefix="Veeam_RO_"
$StrIP="10.0.0.1"
$user="3paradmin"

$getListCMD="showvv -p -copyof $LUN"
#$getListCMD="cat 3par.txt"

$OutputFile="c:\script\snaplist.txt"

ssh -l $user $3parIP $getListCMD > $OutputFile


foreach($line in Get-Content $OutputFile) 
{
    if($line -match $Prefix)
    {
        $obj=$line -split("\s+")
        $snap=$obj[1]
        $renameSnap = $snap -replace $Prefix,$NewPrefix     
        ssh -l $user $StrIP setvv -f -exp 1d $renameSnap $snap
    }
}
