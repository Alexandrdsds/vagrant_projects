# Список імен віртуальних машин
$vms = @("graylog01", "graylog02", "graylog03")

# Ім'я знімка
$snapshotName = "snapshot_name"

# Цикл по кожній VM
foreach ($vm in $vms) {
    Write-Host "Creating snapshot for $vm"
    vagrant snapshot save $vm $snapshotName
}

Write-Host "All snapshots created successfully."