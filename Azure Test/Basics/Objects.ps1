$myHasTable=@{
    Key1= 100
    Apple=2.34
    Key3=$true
}

$myHasTable.GetType()

$myHasTable.Keys

$myHasTable."Apple"

$myHasTable.Add('key4','Testing and Add functions')

$myHasTable['Key5']= "Adding Key 5"
$myHasTable.key6="Adding Key 6"

$myHasTable