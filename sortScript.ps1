
# Global Variable Declaration #
$path = $args[0]
$sortType = $args[1]
$sortOrder = $args[2]

$numericArray = @()
$alphaArray = @()

<# 
   Sorting Function: 
       Accepts an array as a parameter and sorts based on the global variable $sortOrder
       Produces a comma seperated list of values and sorts according to script parameters
#>

function sortValues($outPutArray) {
    switch ($sortOrder) {
        "ascending"
            {$outPutArray = $outPutArray | Sort-Object}
        "descending"
            {$outPutArray = $outPutArray | Sort-Object -Descending}
        default {
            "Unknown sort order declaration"
            "Options: 'ascending' 'descending'"
            Exit
            }
    }
    $outPutArray -join ',' # Final Output of Program # 
}

<# Generating an Array ($dataArray) from comma seperated values in the text file declared in global variable $path 

   Known Assumptions: A file will always contain a single comma seperated list of values.
       All values are considered "sanitized" and should be evaluated as valid.      
#> 

Try {  
    $rawData = Get-Content $path
    $dataArray = $rawData.split(",")
}
Catch{
    "Unable to Locate file. Please Input Correct File Path"
    Exit
}

<# Determining data types for each value of the Array 
   
   Known Assumptions: data types are fixed.
     Strings will never be evaluated for their numeric value <example ASCII values> 
     Strings representing numbers will be explicitly typed <example '50'>  
#> 

foreach ($val in $dataArray) {
    Try
        {$numericArray += [decimal]$val}
    Catch 
        {$alphaArray += $val}
}


<# Establishing Dataset based on global variable $sortType
   Invoke call to function sortValues() 
   
   Known Assumptions: Data outside of the script's parameter scope should be ignored 

#>
switch ($sortType) {
"alpha"
    {sortValues($alphaArray)}
"numeric" 
    {sortValues($numericArray)}
"both" {
    $alphaArray += $numericArray
    sortValues($alphaArray)
    }
default {
    "Unknown sort type declaration." 
    "Options: 'alpha' 'numeric' 'both'"
    }
}


