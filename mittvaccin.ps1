### Quick and dirty script to read the mittvaccin.se open API's

   $sites=@('https://booking-api.mittvaccin.se/clinique/1352/appointments/11916/slots/','https://booking-api.mittvaccin.se/clinique/1351/appointments/11924/slots/',
   'https://booking-api.mittvaccin.se/clinique/1350/appointments/11941/slots/')

$collection = @()
$today=Get-Date
$start = $today.ToString("yyMMdd")
$end = $today.AddDays(10).ToString("yyMMdd")

foreach ($site in $sites){
Write-Host "Processing: $site$start-$end"
$data=(Invoke-restmethod -Uri "$site$start-$end")

if ($data.slots | Where-Object available -like "True"){
    foreach ($dates in $($data).Where({ $_.slots -like "*True*" })) {
    if ($site -like "*11941*") {$newsite ="Hallsberg"}
    if ($site -like "*11916*") {$newsite ="Conventum"}
    if ($site -like "*11924*") {$newsite ="Boglunds"}
    #echo "site $site $newsite $dates.date"

        $collection += [pscustomobject] @{
            site = $newsite
            date = $dates.date
            slots = $data | Select -ExpandProperty slots| where {$_.Available -like "True"}  
        
        }

    }
 }
$collection |ft
}
