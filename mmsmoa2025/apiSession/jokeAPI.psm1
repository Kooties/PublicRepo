function Get-Joke{
    Invoke-RestMethod -method Get -uri "https://v2.jokeapi.dev/joke/programming?blacklistflags='nsfw','religious','racist','sexist','explicit','political'&type=single"
}

Export-ModuleMember -Function Get-Joke