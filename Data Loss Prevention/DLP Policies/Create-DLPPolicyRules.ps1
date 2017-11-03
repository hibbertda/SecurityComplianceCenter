<#

    .SYNOPSIS 
    Script to create a general set of DLP policies in the Office 365 
    Security & Compliance Center. 

    .DESCRIPTION
    This script will create a set of three DLP policies in the Office 365
    Security & Compliance Center. A DLP policy will be created for each major 
    service in Office 365 (Exchange Online, SharePoint Online, OneDrive for Business)
    

Create Default DLP Policy Rules

TechNet: New-DLPCompliancePolicy
https://technet.microsoft.com/EN-US/library/mt627834(v=exchg.160).aspx

TechNet: New-DLPComplianceRule
https://technet.microsoft.com/EN-US/library/mt627834(v=exchg.160).aspx


#>

Param (
    # Office 365 tenant name - this will be used to generate policy/rule names
	[parameter(Position=0, Mandatory=$True)][String]$TenantName,
    # Comma seperated list of SMTP addresses to receive incident reports
    [parameter(Position=2, Mandatory=$True)][String]$IncidentReportRecipient
)

# Connect to S&C Center
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ `
    -Credential $UserCredential `
    -Authentication Basic `
    -AllowRedirection `
    -ErrorAction Stop

Import-PSSession $Session


# Create DLP Policy (Default DLP - SPO )
$SPO_PolicyName = "$TenantName DLP Policy - SharePoint Online"
New-DlpCompliancePolicy -Name $SPO_PolicyName `
    -SharePointLocation All `
    -Mode Disable `
    -ErrorAction Stop

# Create 'low' count rule
New-DlpComplianceRule -Name "$SPO_PolicyName - Low" -Policy $SPO_PolicyName -ContentContainsSensitiveInformation `
    @{Name="Credit Card Number"; minCount="1"; maxCount="4"}, `
    @{Name="U.S. / U.K. Passport Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Bank Account Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Driver's License Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Social Security Number (SSN)"; mincount="1"; MaxCount="4"} `
    @{Name="Drug Enforcement Agency (DEA) Number"; mincount="1"; MaxCount="4"} `
    -BlockAccess:$False `
    -NotifyAllowOverride FalsePositive, WithJustification `
    -NotifyUser Owner `
    -GenerateIncidentReport SiteAdmin, $IncidentReportRecipient `
    -IncidentReportContent Detections, DocumentAuthor, DocumentLastModifier, RulesMatched, Service, Severity, Title `
    -ReportSeverityLevel Low `
    -Comment "This rule will identify data (low count) stored in SharePoint Online or OneDrive for Business regardless if it is shared" `
    -ErrorAction Stop
    
# Create 'high' count rule
New-DlpComplianceRule -Name "$SPO_PolicyName - High" -Policy $SPO_PolicyName -ContentContainsSensitiveInformation `
    @{Name="Credit Card Number"; minCount="5"}, `
    @{Name="U.S. / U.K. Passport Number"; mincount="5"}, `
    @{Name="U.S. Bank Account Number"; mincount="5"}, `
    @{Name="U.S. Driver's License Number"; mincount="5"}, `
    @{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; mincount="5"}, `
    @{Name="U.S. Social Security Number (SSN)"; mincount="5"} `
    @{Name="Drug Enforcement Agency (DEA) Number"; mincount="5"} `
    -BlockAccess:$False `
    -NotifyAllowOverride FalsePositive, WithJustification `
    -NotifyUser Owner `
    -GenerateIncidentReport SiteAdmin, $IncidentReportRecipient `
    -IncidentReportContent Detections, DocumentAuthor, DocumentLastModifier, RulesMatched, Service, Severity, Title `
    -ReportSeverityLevel Medium `
    -Comment "This rule will identify data (high count) stored in SharePoint Online or OneDrive for Business regardless if it is shared" `
    -ErrorAction Stop

# Create DLP Policy (Default DLP - ODfB)
$ODfB_PolicyName = "$TenantName DLP Policy - OneDrive for Business"
New-DlpCompliancePolicy -Name $ODfB_PolicyName `
    -OneDriveLocation All `
    -Mode Disable `
    -ErrorAction Stop

# Create 'low' count rule
New-DlpComplianceRule -Name "$ODfB_PolicyName - Low" -Policy $ODfB_PolicyName -ContentContainsSensitiveInformation `
    @{Name="Credit Card Number"; minCount="1"; maxCount="4"}, `
    @{Name="U.S. / U.K. Passport Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Bank Account Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Driver's License Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Social Security Number (SSN)"; mincount="1"; MaxCount="4"} `
    -BlockAccess:$False `
    -NotifyAllowOverride FalsePositive, WithJustification `
    -NotifyUser Owner `
    -GenerateIncidentReport SiteAdmin `
    -IncidentReportContent Detections, DocumentAuthor, DocumentLastModifier, RulesMatched, Service, Severity, Title `
    -ReportSeverityLevel Low `
    -Comment "This rule will identify data (low count) stored in OneDrive for Business regardless if it is shared" `
    -ErrorAction Stop

# Create 'high' count rule
New-DlpComplianceRule -Name "$ODfB_PolicyName - High" -Policy $ODfB_PolicyName -ContentContainsSensitiveInformation `
    @{Name="Credit Card Number"; minCount="5"}, `
    @{Name="U.S. / U.K. Passport Number"; mincount="5"}, `
    @{Name="U.S. Bank Account Number"; mincount="5"}, `
    @{Name="U.S. Driver's License Number"; mincount="5"}, `
    @{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; mincount="5"}, `
    @{Name="U.S. Social Security Number (SSN)"; mincount="5";} `
    -BlockAccess:$False `
    -NotifyAllowOverride FalsePositive, WithJustification `
    -NotifyUser Owner `
    -GenerateIncidentReport SiteAdmin `
    -IncidentReportContent Detections, DocumentAuthor, DocumentLastModifier, RulesMatched, Service, Severity, Title `
    -ReportSeverityLevel Medium `
    -Comment "This rule will identify data (high count) stored in OneDrive for Business regardless if it is shared" `
    -ErrorAction Stop

# Create DLP Policy (Default DLP - ExO)
$ExO_PolicyName = "$TenantName DLP Policy - Exchange Online"
New-DlpCompliancePolicy -Name $ExO_PolicyName `
    -ExchangeLocation All `
    -Mode Disable `
    -ErrorAction Stop

# Create 'low' count rule
New-DlpComplianceRule -Name "$ExO_PolicyName - Low" -Policy $ExO_PolicyName -ContentContainsSensitiveInformation `
    @{Name="Credit Card Number"; minCount="1"; maxCount="4"}, `
    @{Name="U.S. / U.K. Passport Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Bank Account Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Driver's License Number"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; mincount="1"; MaxCount="4"}, `
    @{Name="U.S. Social Security Number (SSN)"; mincount="1"; MaxCount="4"} `
    -BlockAccess:$False `
    -NotifyAllowOverride FalsePositive, WithJustification `
    -NotifyUser Owner `
    -GenerateIncidentReport SiteAdmin `
    -IncidentReportContent Detections, DocumentAuthor, DocumentLastModifier, RulesMatched, Service, Severity, Title `
    -ReportSeverityLevel Low `
    -Comment "This rule will identify data (low count) in Exchange Online sent to recipeints outside the organization" `
    -AccessScope NotInOrganization `
    -ErrorAction Stop

# Create 'high' count rule
New-DlpComplianceRule -Name "$ExO_PolicyName - High" -Policy $ExO_PolicyName -ContentContainsSensitiveInformation `
    @{Name="Credit Card Number"; minCount="5"}, `
    @{Name="U.S. / U.K. Passport Number"; mincount="5"}, `
    @{Name="U.S. Bank Account Number"; mincount="5"}, `
    @{Name="U.S. Driver's License Number"; mincount="5"}, `
    @{Name="U.S. Individual Taxpayer Identification Number (ITIN)"; mincount="5"}, `
    @{Name="U.S. Social Security Number (SSN)"; mincount="5";} `
    -BlockAccess:$False `
    -NotifyAllowOverride FalsePositive, WithJustification `
    -NotifyUser Owner `
    -GenerateIncidentReport SiteAdmin `
    -IncidentReportContent Detections, DocumentAuthor, DocumentLastModifier, RulesMatched, Service, Severity, Title `
    -ReportSeverityLevel Medium `
    -Comment "This rule will identify data (high count) in Exchange Online sent to recipeints outside the organization" `
    -AccessScope NotInOrganization `
    -ErrorAction Stop