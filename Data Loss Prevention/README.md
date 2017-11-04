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

When the script is completed you will be provided with the DEMO string **Find Me 123456789**.
[logo]: https://github.com/hibbertda/SecurityComplianceCenter/blob/master/Data%20Loss%20Prevention/content/Script_Done.PNG "The script is done!"
![alt text][logo]

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Daniel Hibbert** - *Initial work* - [hibbertda](https://github.com/hibbertda)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
