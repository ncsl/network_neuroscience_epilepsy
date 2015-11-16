# Hosting

## Contact

[Kyle Reynolds](http://icm.jhu.edu/people/it-staff/)
Director of Networking
217D Hackerman Hall
E-mail: ksr@jhu.edu
Hours: 7:30 - 3:30

Kyle currently maintains the application hosts for [Rachel Karchin's group](http://karchinlab.org), e.g. [CRAVAT](http://www.cravat.us).


## Server Requisition

• Send specs to Kyle.

• Kyle will use the [Dell Solutions Configurator](http://partnerdirect.dell.com/sites/channel/en_us/Pages/SolutionsConfigurator.aspx) to find options.


## Server Installation Timeline

2-4 weeks:
• 1-3 weeks for purchasing
• 1 week for Kyle to get the server configured and racked

OS: RHEL 7.1
• TBD: OS Update schedule / process

System Monitoring: Ganglia
• CPU
• Memory
• Disk usage

Security:
• Access logs with audit capability.
• Firewall rules that enable ssh from internet, https from within Hopkins.

Users:
• bnorton with sudo privileges.
• eztrack application account with minimal privileges.

Mount Christophe's MEF file system:
• Christophe Jouny to create a user in WinAD.
• Mount shared drives from RES-11.
• Verify that an application account will be able to access these drives, search the folders, and copy a file.


## Server Hosting Location

There are [two data centers](http://www.it.johnshopkins.edu/services/technical/datacenterservices/) at
Mount Washington and the East Baltimore campus.


## Remote Access

### ssh external

Create firewall rules that enable ssh from internet


### https internal

https from Hopkins intranet.


### VPN

Getting VPN access for a third-party vendor has a few requirements imposed by the university:

- JHED credentials (Johns Hopkins Enterprise Directory) for authentication
- authorization to access the JHH network to reach the laptop
- human subjects training covering patient privacy and research ethics

ssh access might mean that we don't need to set this up.
