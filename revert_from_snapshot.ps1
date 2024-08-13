$vms = @("graylog01", "graylog02", "graylog03")

# Ім'я знімка
$snapshotName = "snapshot_name"

# Цикл по кожній VM
foreach ($vm in $vms) {
    Write-Host "Restoring from snapshot for $vm"
    vagrant snapshot restore $vm $snapshotName
}

Write-Host "All vms were revert successfully."