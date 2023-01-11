# Expectations
start-process https://www.cyber.gov.au/acsc/view-all-content/news/joint-advisory-released-managed-service-providers-and-customers-mitigate-cybersecurity-risks
start-process https://www.oaic.gov.au/privacy/the-privacy-act
Start-Process https://www.legislation.gov.au/Details/C2022C00361

# Microsoft 365 Business Premium
start-process https://www.microsoft.com/en-us/microsoft-365/business/microsoft-365-business-premium
Start-Process https://learn.microsoft.com/en-us/office365/servicedescriptions/office-365-platform-service-description/office-365-plan-options
Start-Process https://m365maps.com/

# Tenant
## Logs
start-process https://security.microsoft.com/auditlogsearch
start-process https://learn.microsoft.com/en-us/microsoft-365/compliance/audit-standard-setup?view=o365-worldwide
start-process https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Audit
start-process https://learn.microsoft.com/en-us/azure/active-directory/reports-monitoring/concept-audit-logs
start-process https://learn.microsoft.com/en-us/azure/active-directory/reports-monitoring/
## Exchange
start-process  https://learn.microsoft.com/en-us/microsoft-365/compliance/audit-mailboxes?view=o365-worldwide#ID0EABAAA=Mailbox_auditing_actions
https://raw.githubusercontent.com/directorcia/Office365/master/o365-connect-exo.ps1 -noupdate
$mailboxes = Get-EXOMailbox -ResultSize Unlimited -Properties DefaultAuditSet,AuditAdmin,AuditDelegate,AuditOwner,PersistedCapabilities,AuditLogAgeLimit, AuditEnabled
$mailboxes | select-object displayname,DefaultAuditSet,AuditAdmin,AuditDelegate,AuditOwner,PersistedCapabilities,AuditLogAgeLimit, AuditEnabled
Start-Process https://learn.microsoft.com/en-us/powershell/module/exchange/set-organizationconfig?view=exchange-ps
start-process https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/preset-security-policies?view=o365-worldwide

## Windows
auditpol /get /category:*
.\win10-bp-get.ps1

## Portals
start-process https://security.mirosoft.com
start-process https://compliance.microsoft.com/

## Best practices
start-process https://github.com/directorcia/Office365/blob/master/best-practices.txt

## Accounts
start-process  https://learn.microsoft.com/en-us/microsoft-365/admin/setup/priority-accounts?view=o365-worldwide

# HAWK
Install-module -name hawk
md c:\temp\hawk
connect-msolservice
start-hawktenantinvestigation
