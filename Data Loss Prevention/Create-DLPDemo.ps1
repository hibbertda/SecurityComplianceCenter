<#
  .NOTES
    Daniel A. Hibbert

  .SYNOPSIS 
    Create data types and policy to demo Office 365 DLP capabilities.

  .DESCRIPTION
    This script will create new sensitive information type and DLP policy
    in the Office 365 Security & Compliance Center for the purposes of doing
    a Demo of DLP features in Office 365.  

    The script will utilize the native Security & Compliance Center PowerShell connection. 
    This method does not support accounts that rely on modern authentication (MFA/Conditional 
    Access), only basic authentication is supported. 

  .LINK
  https://github.com/hibbertda/SecurityComplianceCenter/tree/master/Data%20Loss%20Prevention
#>

# Disclamer on authentication requirements for S&CC
$text = ("As of [May 6th 2017] the Office 365 Security & Compliance Center doesn't support modern authentication.`n `
You will need to use an account that is capable using Basic Auth, and that does not have MFA enabled. If MFA is enabled `
the account will be unable to authenticate.")
$window = new-object -comobject wscript.shell
$pop = $window.popup("$text",0,"DLP Demo Setup",0+48)	

# Attempt to connect to S&CC
clear-host

$ActiveSessions = Get-PSSession | Where-Object {$_.Availability -eq $true -and $_.ComputerName -like "*compliance.protection.outlook.com"}

if ($ActiveSessions.count -eq 0){
  Write-host -ForegroundColor Yellow "Connecting to Office 365 - Security & Compliance Center`n"
  try{
      $UserCredential = Get-Credential
      $Session = New-PSSession -ConfigurationName Microsoft.Exchange `
          -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ `
          -Credential $UserCredential `
          -Authentication Basic `
          -AllowRedirection `
          #-ErrorAction stop
      Import-PSSession $Session #-ErrorAction stop
  }
  # If the connection fails exit out of the script
  catch{
      Write-host -ForegroundColor red "Unable to connect to the Office 365 Security & Compliance Center"
      Exit
  }
}
#region sensitive_data_type
# Demo sensitive data type XML
[XML]$DemoDataType_XML = @"
<?xml version="1.0" encoding="utf-8"?>
<RulePackage xmlns="http://schemas.microsoft.com/office/2011/mce">
  <RulePack id="DAD86A92-AB18-43BB-AB35-96F7C594ADAA">
    <Version major="1" minor="0" build="0" revision="0"/>
    <Publisher id="619DD8C3-7B80-4998-A312-4DF0402BAC04"/>
    <Details defaultLangCode="en-us">
      <LocalizedDetails langcode="en-us">
        <PublisherName>Hibblabs DLP</PublisherName>
        <Name>Hibblabs Custom DLP for Demo</Name>
        <Description>This package is to make DLP demos easier</Description>
      </LocalizedDetails>
    </Details>
  </RulePack>
  <Rules>
    <Entity id="df3dc5b2-20e9-48ac-af46-f431d9bdc71c" patternsProximity="300" recommendedConfidence="75">
      <Pattern confidenceLevel="75">
        <IdMatch idRef="Regex_DemoID" />
        <Match idRef="Keyword_findme" />
      </Pattern>
    </Entity>
    <Regex id="Regex_DemoID">(\s)(\d{9})(\s)</Regex>
    <Keyword id="Keyword_findme">
      <Group matchStyle="word">
        <Term>Find Me</Term>
        <Term>findme</Term>
      </Group>
    </Keyword>
    <LocalizedStrings>
      <Resource idRef="df3dc5b2-20e9-48ac-af46-f431d9bdc71c">
        <Name default="true" langcode="en-us">
          DEMO
        </Name>
        <Description default="true" langcode="en-us">
          A custom classification for doing DLP demos
        </Description>
      </Resource>
    </LocalizedStrings>
  </Rules>
</RulePackage>
"@

# Save XML file to local computer
$XMLExportPath = "$ENV:USERPROFILE\Desktop\demodatatype.xml"
$DemoDataType_XML.save($XMLExportPath)

# Add DEMO data type to Security & Compliance Center
Clear-Host
Write-Host -ForegroundColor yellow "Creating custom sensitive data type"

Try{
  New-DlpSensitiveInformationTypeRulePackage `
  -FileData (Get-Content -Path $XMLExportPath -Encoding Byte) `
  -ErrorAction stop
}
catch {
  Write-host -ForegroundColor red "Unable to add data type"
  write-host $_.message
  Exit
}
#endregion

#region Create_Demo_DLP_Policy 
clear-host
try {
  $PolicyName = "DEMO DLP Policy"
  write-host -ForegroundColor yellow "Creating DLP policy: $PolicyName"
  New-DlpCompliancePolicy -Name $PolicyName `
      -OneDriveLocation All `
      -ExchangeLocation All `
      -SharePointLocation All `
      -Mode Enable `
      -ErrorAction stop

  # Create 'low' count rule
  New-DlpComplianceRule -Name "Demo - Low" -Policy $PolicyName `
      -ContentContainsSensitiveInformation @{Name="DEMO"; minCount="1"; maxCount="4"} `
      -BlockAccess:$False `
      -NotifyAllowOverride FalsePositive, WithJustification `
      -NotifyUser SiteAdmin, LastModifier, Owner `
      -GenerateIncidentReport SiteAdmin `
      -IncidentReportContent Default `
      -ReportSeverityLevel Low `
      -Comment "Demo low count rule" `
      -NotifyPolicyTipCustomText "This DEMO rule (low) will identiy and report on protected content" `
      -ErrorAction stop
      
  # Create 'high' count rule
  New-DlpComplianceRule -Name "Demo - High" -Policy $PolicyName `
      -ContentContainsSensitiveInformation @{Name="DEMO"; minCount="5"} `
      -BlockAccess:$False `
      -NotifyAllowOverride FalsePositive, WithJustification `
      -NotifyUser SiteAdmin, LastModifier, Owner `
      -GenerateIncidentReport SiteAdmin `
      -IncidentReportContent Default `
      -ReportSeverityLevel Medium `
      -Comment "Demo high count rule" `
      -NotifyPolicyTipCustomText "This DEMO rule (high) will identiy and block access to protected content" `
      -ErrorAction stop
}
Catch {
  Write-Host -ForegroundColor red "Unable to create DLP policy"
  Write-Host $_.Message
  Exit
}
#endregion 

#region Clean_up
Clear-Host
Write-Host -ForegroundColor green "DLP DEMO Setup Succesful!!!`n"
Write-Host "Create documents / emails with a string starting with 'Find Me' and 9 random numbers to fire the policy`n"
Write-host "[Example]:"
Write-host -ForegroundColor yellow "`tFind Me 123456789`n"

# Remove DLP XML
Remove-Item -Path $XMLExportPath | Out-Null

# Close session
Get-PSSession | Remove-PSSession
#endregion