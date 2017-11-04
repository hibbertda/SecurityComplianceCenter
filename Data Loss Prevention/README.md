# Security & Compliance Center: DLP Demo

This script will create new sensitive information type and DLP policy in the Office 365 Security & Compliance Center for the purposes of doing a Demo of DLP features in Office 365. The policies will apply to all Exchange Online/SharePoint Online/OneDrive for Business Online location in the target Office 365 tenant. 

The script will utilize the native Security & Compliance Center PowerShell connection. This method does not support accounts that rely on modern authentication (MFA/ConditionalAccess), only basic authentication is supported.

## Getting Started

This script will create all of the configuration required to demonstrate and test Office 365 Data Loss Prevention (DLP) with non-sensitive keywords. 

### Prerequisites

* Assigned **Compliance Administrator** role in the Office 365 Security & Compliance Center. Or appropriate rights to create and manage DLP data types and policies.


### Installing

To create DLP run the script. There is no additional parameters required.

```
Create-DLPDemo.ps1
```

When the script is completed you will be provided with the DEMO string **" Find Me 123456789 "**.

![alt text](https://github.com/hibbertda/SecurityComplianceCenter/blob/master/Data%20Loss%20Prevention/content/Script_Done.PNG "Script done!")

## DLP Configuration

After the script is compelted check the configuration in the Office 365 [Security & Compliance Center](https://protection.office.com). 

### DLP Policy

![alt text](https://github.com/hibbertda/SecurityComplianceCenter/blob/master/Data%20Loss%20Prevention/content/DLP_Policy.PNG "DLP Policy")

The new DLP policy will be named **"DEMO DLP Policy"** and the policy will be enabled and turned on.

![alt text](https://github.com/hibbertda/SecurityComplianceCenter/blob/master/Data%20Loss%20Prevention/content/DLP_Policy_Detail.PNG "DLP Policy - Detail")

The policy detail will show three locations that cover all storage locations in Office 365.
* Exchange email
* SharePoint Sites
* OneDrive Accounts

There will be two policy rules/settings
* Demo - high
* Demo - low

![alt text](https://github.com/hibbertda/SecurityComplianceCenter/blob/master/Data%20Loss%20Prevention/content/DLP_Policy_Rules_Detail.PNG "DLP Policy Rules")

Rule conditions will be set to the newly created **DEMO** sensitive data type.

Rule actions are set to
* Notify users with email and policy tips
* Send incident reports to administrators

## Authors

* **Daniel Hibbert** - [hibbertda](https://github.com/hibbertda)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
