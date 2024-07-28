
Set-StrictMode -Off

$myArrys = "Test1", "Test2"
$myArrys


$myArrys1=@("Junaid","Zubair","Uzair")

$myArrys.Count

# How to add my Arrys

$myArrys=$myArrys+"Test3"
$myArrys+="Test4"

$myArrys

# How to remove arry 
$myArrys=$myArrys -ne "Test2"

$myArrys


# Array List

$mylist=[System.Collections.ArrayList]@()
$mylist1= New-Object -TypeName System.Collections.ArrayList #Recommended Way


$mylist1.GetType()
$mylist.GetType()

$mylist.IsFixedSize

[void]$mylist.Add("Test1") # adding void will not print the result
[void]$mylist.Add("Test2")
$mylist.AddRange(@("Test3","Test4","Test5")) #adding Range of list

$mylist.Remove("Test2") # This will remove Test2
$mylist.RemoveAt(0) # This will remove value at index 0
$mylist.RemoveRange(0,2) # This will remove value from index 0 to 2

$mylist # This will print the result