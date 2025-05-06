function Get-Joke{
    Invoke-RestMethod -method Get -uri "https://v2.jokeapi.dev/joke/programming?blacklistflags='nsfw','religious','racist','sexist','explicit','political'&joketype=single"
}

function Get-CustomJoke{
    param(
        [string]$category,
        [string]$type,
        [string]$flags
    )
    if($category -and $type -and $flags){
        $args = "$category?blacklistflags=$flags,&joketype=$type"
    }elseif($category -and $type){
        $args = "$category?joketype=$type"
    }elseif($type -and $flags){
        $args = "any?blacklistflags=$flags,&joketype=$type"
    }elseif($category -and $flags){
        $args = "$category?blacklistflags=$flags"
    }elseif($category){
        $args = "$category"
    }elseif($type){
        $args = "any?joketype=$type"
    }elseif($flags){
        $args = "any?blacklistflags=$flags"
    }else{
        $args = "any"
    }
    $uri = "https://v2.jokeapi.dev/joke/$args"
    return Invoke-RestMethod -method Get -uri $uri
}

Export-ModuleMember -Function Get-Joke
Export-ModuleMember -Function Get-CustomJoke