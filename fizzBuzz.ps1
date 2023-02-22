$number = 1..100
$fizz = 3
$buzz = 5

foreach($num in $number){
    if(($num%$fizz -eq 0) -and ($num%$buzz -eq 0)){
        Write-Host "FizzBuzz"
    }elseif($num%$fizz -eq 0){
        Write-Host "Fizz"
    }elseif($num%$buzz -eq 0){
        Write-Host "Buzz"
    }else{
        Write-Host $num
    }
}