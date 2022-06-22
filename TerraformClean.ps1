Param(
    [Parameter(Mandatory=$False)]
    [String] $Dir = ".",
    [Parameter(Mandatory=$False)]
    [switch] $Auto
)

$ErrorActionPreference = 'silentlycontinue'

$terraform = (Get-ChildItem -Path $Dir -Filter ".terraform.*" | ForEach-Object {$_.FullName})
$tfstate = (Get-ChildItem -Path $Dir -Filter "terraform.tfstate*" | ForEach-Object {$_.FullName})

if ($Auto -eq $False)
{
    if ($terraform -or $tfstate)
    {
        $tfstate | ForEach-Object { $_.Split('\')[-1] }
        $terraform | ForEach-Object { $_.Split('\')[-1] }

        $Option = Read-Host -Prompt 'Confirm to delete (Yes/No)'
        $Option.ToLower() | out-null
        if ($Option -eq "yes" -or $Option -eq "y")
        {
            ForEach-Object { Remove-Item $tfstate }
            ForEach-Object { Remove-Item -Recurse $terraform }
            Write-Host("`n[+] Terraform files deleted.`n")
        }
        else
        {
            Write-Host("`n[!] Aborting...`n")
        }
    }
    else
    {
        Write-Host("`n[!] No terraform files was found.`n")
    }
}
else
{
    if ($terraform -or $tfstate)
    {
        ForEach-Object { Remove-Item $tfstate }
        ForEach-Object { Remove-Item -Recurse $terraform }
        Write-Host("`n[+] Terraform files deleted.`n")
    }
    else
    {
        Write-Host("`n[!] No terraform files was found.`n")
    }
}