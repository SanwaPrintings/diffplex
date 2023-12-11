param ($accessToken = (Read-Host "Enter access token" -MaskInput))

rm .\bin\Release\*nupkg;
dotnet build --configuration Release;
dotnet pack --configuration Release;
$newPackage = (gci .\bin\Release\*nupkg)[0].Name;
$message = dotnet nuget push ".\bin\Release\$newPackage" --source github -k $accessToken;
$isConflict = ($message | ? { $_ -like '*conflict*' }).length -gt 0;

write-host;
$separateFlag = $true;
$message | ? { if ($_ -clike '*Usage*') { $separateFlag = $false; } $separateFlag; };
if ($isConflict)
{
    write-host 'Increment version in project file.'
}
