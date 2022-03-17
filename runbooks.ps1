$appID = "b111189a-9b19-4e22-bc1c-3e92845943d4"
$tenantID = "350c7acd-ee85-44bd-8aab-638a15a0f600"
$secretID = "4e4c1f65-c5dc-493a-942b-cda49f6a969e"
$secretValue = "~sg7Q~KZw-ODs_wgtxEK5OTdQSQCSYC9aa5rW"

$uri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$body = @{
    client_id = $appID
    scope = "https://graph.microsoft.com/.default"
    client_secret = $secretValue
    grant_type = "client_credentials"
}

$tokenRequest = Invoke-WebRequest -Method Post -Uri $uri -ContentType "application/x-www-form-urlencoded -Body $body -UseBasicParsing"

$token = ($tokenRequest.Content | ConvertFrom-Json).access_token

$uri = "https://graph.microsoft.com/beta/"
$headers = @{Authorization = "Bearer $token"}
$ctype = "application/json"

