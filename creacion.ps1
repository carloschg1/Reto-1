$file_groups=Import-Csv -Path departamentos.csv
$file_users=Import-Csv -Path empleados.csv

foreach ($group in $file_groups) {
  New-LocalGroup -Name $group.Nombre -Description $group.Descripcion
}

foreach ($user in $file_users) {
  $clave=ConvertTo-secureString $user.Password -AsPlainText -Force
  New-LocalUser $user.cuenta -Password $clave -FullName $user.nombre_apellido -Description $user.descripcion -AccountNeverExpires  
  Set-LocalUser $user.Password -PasswordNeverExpires $false
  net user $user.Password /logonpasswordchg:yes
  Add-LocalGroupMember -Group $user.Departamentos -Member $user.Password
}
