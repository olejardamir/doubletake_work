# AZ-104 Transcript Coverage Matrix

## Purpose

This matrix maps every substantive learning point from the five uploaded exam-prep transcripts to the consolidated study outline. Non-substantive material such as introductions, music cues, certification encouragement, and repeated statements to practice in the portal is excluded from topic coverage, except where hands-on portal familiarity is itself emphasized as an operational requirement.

## Status Legend

- **Covered**: The study outline explicitly contains the point.
- **Partial**: The outline contains the general concept but not the full nuance stated in the transcript.
- **Missing**: No corresponding point was found in the outline.
- **Non-substantive**: Presenter introduction, repetition, encouragement, or transition with no additional study topic.

---

# 1. Manage Azure Identities and Governance

| ID | Transcript point | Matching study-outline section | Status | Required update |
|---|---|---|---|---|
| ID-01 | Entra ID is the renamed Azure Active Directory. | Microsoft Entra ID | Covered | None |
| ID-02 | Know the Azure portal and the Entra administration portal. | Microsoft Entra ID | Covered | None |
| ID-03 | Create and manage users and groups. | Users; Groups | Covered | None |
| ID-04 | Distinguish cloud, hybrid, and guest users. | Users | Covered | None |
| ID-05 | Know when each user type is used. | Users | Covered | None |
| ID-06 | Understand Entra licensing. | Entra Licensing | Covered | None |
| ID-07 | PIM requires a P2 license. | Entra Licensing | Covered | None |
| ID-08 | Identity Protection requires a P2 license. | Entra Licensing | Covered | None |
| ID-09 | Self-Service Password Reset requires a P1 license. | Entra Licensing; Self-Service Password Reset | Covered | None |
| ID-10 | Understand external users and what makes an account a guest. | External and Guest Users | Covered | None |
| ID-11 | Know how and when to invite a guest. | External and Guest Users | Covered | None |
| ID-12 | Understand how invited guest accounts are managed. | External and Guest Users | Covered | None |
| ID-13 | Understand built-in Azure roles. | Azure Role-Based Access Control | Covered | None |
| ID-14 | Distinguish Owner, Contributor, and User Access Administrator. | Azure Role-Based Access Control | Covered | None |
| ID-15 | Know which role can create or delete resources. | Azure Role-Based Access Control | Covered | None |
| ID-16 | Know which role can grant access to others. | Azure Role-Based Access Control | Covered | None |
| ID-17 | Understand custom roles. | Custom Roles | Covered | None |
| ID-18 | Custom role definitions use JSON and can be imported. | Custom Roles | Covered | None |
| ID-19 | Reading role definitions is more important than authoring them. | Custom Roles | Partial | Add explicit read-and-interpret emphasis. |
| ID-20 | Understand permission and policy scope. | Azure Scope Hierarchy | Covered | None |
| ID-21 | Know the hierarchy: management group, subscription, resource group, resource. | Azure Scope Hierarchy | Covered | None |
| ID-22 | Permissions and policies inherit to child scopes. | Azure Scope Hierarchy | Covered | None |
| ID-23 | Inherited assignments cannot simply be broken at a child scope. | Azure Scope Hierarchy | Covered | None |
| ID-24 | Distinguish Entra administrative roles from Azure resource roles. | Entra Roles vs Azure Resource Roles | Covered | None |
| ID-25 | Understand scope differences between identity and resource roles. | Entra Roles vs Azure Resource Roles | Covered | None |
| ID-26 | Understand Azure Policy. | Azure Policy | Covered | None |
| ID-27 | Distinguish a single policy definition from an initiative. | Azure Policy | Covered | None |
| ID-28 | An initiative groups policy definitions. | Azure Policy | Covered | None |
| ID-29 | Policies support governance and compliance. | Azure Policy | Covered | None |
| ID-30 | Understand Delete and Read-only resource locks. | Resource Locks | Covered | None |
| ID-31 | Know the effect of each lock. | Resource Locks | Covered | None |
| ID-32 | Resource groups act as containers. | Resource Groups | Covered | None |
| ID-33 | Resource groups cannot be nested. | Resource Groups | Covered | None |
| ID-34 | Every resource belongs to a resource group. | Resource Groups | Covered | None |
| ID-35 | A resource group can contain resources from multiple regions. | Resource Groups | Covered | None |
| ID-36 | Resources can be moved, subject to dependencies and limitations. | Resource Groups | Covered | None |
| ID-37 | Understand subscriptions as billing and organizational boundaries. | Azure Subscriptions | Covered | None |
| ID-38 | Resources cannot be created without a subscription. | Azure Subscriptions | Covered | None |
| ID-39 | Understand different subscription types and use cases. | Azure Subscriptions | Covered | None |
| ID-40 | Understand Cost Management and budgets. | Cost Management | Covered | None |
| ID-41 | Understand management groups for multiple subscriptions. | Management Groups | Covered | None |
| ID-42 | Management groups support centralized security and policy. | Management Groups | Covered | None |
| ID-43 | Management groups are not useful merely to wrap one subscription. | Management Groups | Partial | Add this explicit design principle. |
| ID-44 | Understand tagging and metadata. | Tags | Covered | None |
| ID-45 | Interpret access-management and user/group properties. | Groups; Azure Role-Based Access Control | Partial | Add explicit user/group property review. |
| ID-46 | Hands-on familiarity with users, groups, resource groups, and role access is expected. | High-Priority Hands-On Areas | Covered | None |

**Identity coverage result:** 43 Covered, 3 Partial, 0 Missing.

---

# 2. Implement and Manage Storage

| ID | Transcript point | Matching study-outline section | Status | Required update |
|---|---|---|---|---|
| ST-01 | Configure storage firewalls and virtual-network access. | Storage Firewalls and Virtual Networks | Covered | None |
| ST-02 | Understand network routing effects on storage access. | Storage Firewalls and Virtual Networks | Covered | None |
| ST-03 | Know where storage network controls are configured in the portal. | Storage Firewalls and Virtual Networks | Covered | None |
| ST-04 | Understand Shared Access Signatures. | Shared Access Signatures | Covered | None |
| ST-05 | SAS can have start and expiration times. | Shared Access Signatures | Covered | None |
| ST-06 | SAS is suitable for delegated, time-limited application or guest access. | Shared Access Signatures | Covered | None |
| ST-07 | Understand storage account keys. | Storage Account Access Keys | Covered | None |
| ST-08 | Storage accounts expose two keys. | Storage Account Access Keys | Covered | None |
| ST-09 | Understand key management and rotation. | Storage Account Access Keys | Covered | None |
| ST-10 | Understand stored access policies and why they are used. | Stored Access Policies | Covered | None |
| ST-11 | Know the stated limit of five stored access policies for the applicable resource. | Stored Access Policies | Covered | None |
| ST-12 | Distinguish Microsoft-managed and customer-managed keys. | Storage Encryption | Covered | None |
| ST-13 | Key Vault can store or support management of keys. | Storage Encryption; Storage Account Access Keys | Covered | None |
| ST-14 | Understand identity-based access for Azure Files. | Storage Authorization Options | Covered | None |
| ST-15 | Compare SAS, account keys, and IAM/RBAC. | Storage Authorization Options | Covered | None |
| ST-16 | Create and configure a storage account. | Storage Account Fundamentals | Covered | None |
| ST-17 | Understand storage endpoint and URL structure. | Storage Account Fundamentals | Covered | None |
| ST-18 | Know Blob, Files, Queues, and Tables. | Storage Account Fundamentals | Covered | None |
| ST-19 | A container is part of Blob Storage. | Blob Storage | Covered | None |
| ST-20 | Understand LRS, ZRS, GRS, GZRS, and read-access variants. | Storage Redundancy | Covered | None |
| ST-21 | Know when and why to use each redundancy option. | Storage Redundancy | Covered | None |
| ST-22 | Understand object replication between storage accounts or regions. | Object Replication | Covered | None |
| ST-23 | Distinguish object replication from built-in redundancy. | Object Replication | Covered | None |
| ST-24 | Storage data is encrypted by default. | Storage Encryption | Covered | None |
| ST-25 | The transcript states 256-bit encryption. | Storage Encryption | Covered | None |
| ST-26 | Know where encryption is configured. | Storage Encryption | Covered | None |
| ST-27 | Use Storage Explorer to manage multiple storage accounts and subscriptions. | Storage Explorer | Covered | None |
| ST-28 | Use AzCopy to move data between environments or storage accounts. | AzCopy | Covered | None |
| ST-29 | Azure Files supports Windows, Linux, macOS, and SMB 3.0. | Azure Files | Covered | None |
| ST-30 | The portal provides commands for connecting to a file share. | Azure Files | Partial | Add explicit portal-generated connection commands. |
| ST-31 | Azure Files is for managed file sharing, not end-user collaboration. | Azure Files | Covered | None |
| ST-32 | Create a container before uploading blobs. | Blob Storage | Covered | None |
| ST-33 | Understand Hot, Cool, Cold, and Archive tiers. | Access Tiers | Covered | None |
| ST-34 | Choose tiers based on access patterns and cost. | Access Tiers | Covered | None |
| ST-35 | Lifecycle management automates tier transitions. | Lifecycle Management | Covered | None |
| ST-36 | A lifecycle policy can hold multiple rules or transitions. | Lifecycle Management | Covered | None |
| ST-37 | Example: move to Cool after 30 days and Archive after 90 days. | Lifecycle Management | Covered | None |
| ST-38 | Understand snapshots for point-in-time recovery. | Snapshots | Covered | None |
| ST-39 | Understand soft delete and the stated 1-to-365-day retention range. | Soft Delete | Covered | None |
| ST-40 | Understand blob versioning and version IDs. | Blob Versioning | Covered | None |
| ST-41 | A version is a point-in-time blob state, not collaborative document versioning. | Blob Versioning | Partial | Add explicit distinction from collaboration versioning. |
| ST-42 | Hands-on portal familiarity with storage configuration is expected. | High-Priority Hands-On Areas | Covered | None |

**Storage coverage result:** 40 Covered, 2 Partial, 0 Missing.

---

# 3. Deploy and Manage Azure Compute Resources

| ID | Transcript point | Matching study-outline section | Status | Required update |
|---|---|---|---|---|
| CP-01 | ARM templates use JSON. | ARM Templates | Covered | None |
| CP-02 | Be able to read and interpret ARM templates. | ARM Templates | Covered | None |
| CP-03 | Writing templates from scratch is not the primary emphasis. | ARM Templates | Covered | None |
| CP-04 | ARM templates deploy Azure resources. | ARM Templates | Covered | None |
| CP-05 | Be able to read and interpret Bicep files. | Bicep | Covered | None |
| CP-06 | Recognize a missing line or declaration in Bicep. | Bicep | Covered | None |
| CP-07 | Understand the required components of a VM. | Virtual Machine Creation | Covered | None |
| CP-08 | VM requirements include disks, networking, and management settings. | Virtual Machine Creation | Covered | None |
| CP-09 | Understand optional and advanced VM settings. | Virtual Machine Creation | Covered | None |
| CP-10 | Understand VM sizes and families. | Virtual Machine Sizes and Families | Covered | None |
| CP-11 | Select a family based on workload characteristics. | Virtual Machine Sizes and Families | Covered | None |
| CP-12 | H-series is associated with high-performance computing. | Virtual Machine Sizes and Families | Covered | None |
| CP-13 | Less demanding test workloads may use entry-level/general-purpose sizes. | Virtual Machine Sizes and Families | Partial | Add explicit low-complexity test workload example. |
| CP-14 | Understand HDD and SSD disk types. | Managed Disks | Covered | None |
| CP-15 | Know how to add, attach, or detach disks. | Managed Disks | Covered | None |
| CP-16 | Understand disk encryption and key management. | Managed Disks | Covered | None |
| CP-17 | Compare availability zones and availability sets. | Availability Sets; Availability Zones | Covered | None |
| CP-18 | Availability zones provide redundancy within a region. | Availability Zones | Covered | None |
| CP-19 | Availability sets use fault and update domains. | Availability Sets | Covered | None |
| CP-20 | Different application tiers may use separate availability sets. | Availability Sets | Partial | Add web-tier/data-tier example. |
| CP-21 | Understand Virtual Machine Scale Sets. | Virtual Machine Scale Sets | Covered | None |
| CP-22 | VM Scale Sets support availability, performance, and autoscaling. | Virtual Machine Scale Sets | Covered | None |
| CP-23 | Compare vertical, horizontal, and automatic scaling. | Scaling | Covered | None |
| CP-24 | Distinguish scale up/down from scale out/in. | Scaling | Covered | None |
| CP-25 | Move VMs across resource groups or supported subscriptions. | Moving Virtual Machines | Covered | None |
| CP-26 | Understand regional migration conceptually. | Moving Virtual Machines | Covered | None |
| CP-27 | Identify VM dependencies that must move or be recreated. | Moving Virtual Machines | Covered | None |
| CP-28 | Understand ACR, ACI, and ACA. | Container Service Comparison | Covered | None |
| CP-29 | ACR stores and manages container images. | Azure Container Registry | Covered | None |
| CP-30 | ACR offers tiers. | Azure Container Registry | Covered | None |
| CP-31 | ACI is suited to single/simple container workloads and test/development scenarios. | Azure Container Instances | Covered | None |
| CP-32 | ACA is a managed application platform for containerized workloads. | Azure Container Apps | Covered | None |
| CP-33 | Understand ACR integration with ACI and ACA. | Container Service Comparison | Covered | None |
| CP-34 | Understand sizing and scaling of ACI and ACA workloads. | Azure Container Apps; Azure Container Instances | Covered | None |
| CP-35 | Kubernetes is not a focal topic in the transcript series. | None | Non-substantive | Scope note only; no study point required. |
| CP-36 | Distinguish App Service from App Service Plan. | App Service Plans; Azure App Service | Covered | None |
| CP-37 | App Service Plan defines settings, capacity, region, and tier. | App Service Plans | Covered | None |
| CP-38 | App Service Plan is region-specific. | App Service Plans | Covered | None |
| CP-39 | Scale up changes the plan/tier or size. | App Service Scaling | Covered | None |
| CP-40 | Scale out increases the number of instances. | App Service Scaling | Covered | None |
| CP-41 | Understand Basic, Standard, Premium, and feature differences. | App Service Features by Tier | Covered | None |
| CP-42 | Tier determines access to deployment slots, backups, and scaling. | App Service Features by Tier | Covered | None |
| CP-43 | App Service and App Service Plan work together. | Azure App Service | Covered | None |
| CP-44 | Hands-on work with ACA and related services was recommended. | High-Priority Hands-On Areas | Covered | None |

**Compute coverage result:** 41 Covered, 2 Partial, 0 Missing, 1 Non-substantive.

---

# 4. Implement and Manage Virtual Networking

| ID | Transcript point | Matching study-outline section | Status | Required update |
|---|---|---|---|---|
| NW-01 | Create and configure a VNet. | Virtual Networks | Covered | None |
| NW-02 | Create and manage subnets. | Subnets | Covered | None |
| NW-03 | Use subnet separation to improve security. | Subnets | Covered | None |
| NW-04 | Understand public IP Basic vs Standard SKUs. | Public IP Addresses | Covered | None |
| NW-05 | Understand dynamic vs static public IP assignment. | Public IP Addresses | Covered | None |
| NW-06 | Understand public IP availability-zone considerations. | Public IP Addresses | Covered | None |
| NW-07 | Understand VNet peering. | VNet Peering | Covered | None |
| NW-08 | Compare regional and global peering. | VNet Peering | Covered | None |
| NW-09 | Understand one-way vs two-way communication/configuration concepts. | VNet Peering | Covered | None |
| NW-10 | Understand routing across multiple connected VNets. | VNet Peering; User-Defined Routes | Covered | None |
| NW-11 | Understand UDRs and route tables. | User-Defined Routes | Covered | None |
| NW-12 | Associate route tables with subnets. | User-Defined Routes | Covered | None |
| NW-13 | Reuse one route table across multiple subnets. | User-Defined Routes | Covered | None |
| NW-14 | Compare system routes and UDRs. | System Routes; User-Defined Routes | Covered | None |
| NW-15 | Use Network Watcher for connectivity troubleshooting. | Network Watcher; Network Troubleshooting | Covered | None |
| NW-16 | Interpret network errors and identify a resolution path. | Network Troubleshooting | Covered | None |
| NW-17 | Understand NSGs. | Network Security Groups | Covered | None |
| NW-18 | Know default NSG rules. | Network Security Groups | Covered | None |
| NW-19 | Configure custom inbound and outbound NSG rules. | Network Security Groups | Covered | None |
| NW-20 | NSGs provide Layer 4 filtering based on IP and port. | Network Security Groups | Covered | None |
| NW-21 | NSGs are not a replacement for a full firewall. | Network Security Groups | Covered | None |
| NW-22 | Understand ASGs. | Application Security Groups | Covered | None |
| NW-23 | Use ASGs to group workloads and simplify traffic segmentation. | Application Security Groups | Covered | None |
| NW-24 | Compare ASGs and NSGs. | Application Security Groups | Covered | None |
| NW-25 | Use Azure Bastion for secure RDP and SSH. | Azure Bastion | Covered | None |
| NW-26 | Know how Bastion is configured at a high level. | Azure Bastion | Covered | None |
| NW-27 | One Bastion deployment can support peered VNets where supported. | Azure Bastion | Covered | None |
| NW-28 | Understand service endpoints. | Service Endpoints | Covered | None |
| NW-29 | Understand private endpoints and Private Link. | Private Endpoints and Private Link | Covered | None |
| NW-30 | Compare service endpoints and private endpoints. | Private Endpoints and Private Link | Covered | None |
| NW-31 | Know supported-service considerations for service endpoints. | Service Endpoints | Covered | None |
| NW-32 | Understand public DNS zones. | Azure DNS | Covered | None |
| NW-33 | Understand private DNS zones. | Azure DNS | Covered | None |
| NW-34 | Compare internal and external name resolution. | Azure DNS | Covered | None |
| NW-35 | Understand public and internal Azure Load Balancers. | Azure Load Balancer | Covered | None |
| NW-36 | Understand load-balancer high-availability use cases. | Azure Load Balancer | Covered | None |
| NW-37 | Understand health probes. | Health Probes | Covered | None |
| NW-38 | Use Network Watcher and health probes to troubleshoot load balancing. | Health Probes; Network Troubleshooting | Covered | None |
| NW-39 | Compare Azure Load Balancer and Application Gateway. | Azure Load Balancer; Application Gateway | Covered | None |
| NW-40 | Azure Load Balancer is Layer 4; Application Gateway is Layer 7. | Azure Load Balancer; Application Gateway | Covered | None |
| NW-41 | Hands-on exploration of Network Watcher was strongly emphasized. | High-Priority Hands-On Areas | Covered | None |
| NW-42 | Subnetting, NSGs, ASGs, public IPs, private endpoints, and load balancing are priority study areas. | Relevant networking sections | Covered | None |

**Networking coverage result:** 42 Covered, 0 Partial, 0 Missing.

---

# 5. Monitor and Maintain Azure Resources

| ID | Transcript point | Matching study-outline section | Status | Required update |
|---|---|---|---|---|
| MO-01 | Understand Azure Monitor. | Azure Monitor | Covered | None |
| MO-02 | Compare metrics, Log Analytics/logs, and alerts. | Metrics vs Logs vs Alerts | Covered | None |
| MO-03 | Know when to use each monitoring capability. | Metrics vs Logs vs Alerts | Covered | None |
| MO-04 | Know how to configure each capability. | Metrics; Logs and Log Analytics; Alerts | Covered | None |
| MO-05 | Azure Monitor can cover Azure, other clouds, and on-premises resources. | Azure Monitor | Covered | None |
| MO-06 | Configure diagnostic/log settings. | Logs and Log Analytics | Covered | None |
| MO-07 | Analyze logs. | Logs and Log Analytics | Covered | None |
| MO-08 | Create monitoring dashboards and visualizations. | Dashboards and Visualization | Covered | None |
| MO-09 | Configure alerts. | Alerts | Covered | None |
| MO-10 | Alerts use Action Groups. | Action Groups | Covered | None |
| MO-11 | Action Groups can send email. | Action Groups | Covered | None |
| MO-12 | Action Groups can send SMS. | Action Groups | Covered | None |
| MO-13 | Action Groups can trigger webhooks/custom code or Azure Automation. | Action Groups | Covered | None |
| MO-14 | Configure and interpret VM monitoring. | Virtual Machine Monitoring | Covered | None |
| MO-15 | Understand Application Insights for application and code monitoring. | Application Insights | Covered | None |
| MO-16 | Application Insights is lower priority but still in scope. | Application Insights | Covered | None |
| MO-17 | Understand Network Watcher as a monitoring and troubleshooting service. | Network Monitoring; Network Watcher | Covered | None |
| MO-18 | Understand and configure Connection Monitor. | Connection Monitor | Covered | None |
| MO-19 | Hands-on portal work with monitoring components is expected. | High-Priority Hands-On Areas | Covered | None |
| MO-20 | Understand Recovery Services vault. | Recovery Services Vault | Covered | None |
| MO-21 | The transcript groups Azure Backup and ASR under the recovery-vault concept. | Recovery Services Vault | Covered | None |
| MO-22 | Understand centralized views for managing vaults and backups. | Recovery Services Vault | Covered | None |
| MO-23 | Understand backup configurations and policies. | Azure Backup; Backup Policies | Covered | None |
| MO-24 | Backup policies define frequency and retention. | Backup Policies | Covered | None |
| MO-25 | Understand daily, monthly, and yearly retention. | Backup Policies | Covered | None |
| MO-26 | Understand permissions for backup and restore operations. | Backup Permissions | Covered | None |
| MO-27 | Separate backup and restore responsibilities using RBAC. | Backup Permissions | Covered | None |
| MO-28 | Know how to create a recovery vault at a high level. | Recovery Services Vault | Partial | Add explicit vault-creation requirement. |
| MO-29 | Understand Azure Site Recovery replication. | Azure Site Recovery | Covered | None |
| MO-30 | ASR supports regional disaster-recovery failover. | Azure Site Recovery; Failover | Covered | None |
| MO-31 | Compare a VM backup with workload replication. | Backup vs Replication | Covered | None |
| MO-32 | Backup and replication solve different recovery objectives. | Backup vs Replication | Covered | None |
| MO-33 | Understand ASR configuration and replication settings. | Azure Site Recovery | Covered | None |
| MO-34 | Understand planned/unplanned failover concepts. | Failover | Covered | None |
| MO-35 | Interpret ASR reports and alerts. | Azure Site Recovery | Covered | None |
| MO-36 | The transcript states VM backup and its vault must be in the same region. | Azure Backup | Covered | None |
| MO-37 | Replication targets a secondary region for disaster recovery. | Azure Site Recovery; Backup vs Replication | Covered | None |

**Monitoring and recovery coverage result:** 36 Covered, 1 Partial, 0 Missing.

---

# 6. Non-Substantive Transcript Material

The following material does not require study-outline bullets:

- Presenter name, trainer credentials, greetings, and music cues.
- General statements that AZ-104 is difficult.
- Recommendations to have six months of experience.
- References to course delivery formats and AWS transition courses.
- Repeated encouragement such as “you will do great.”
- Repeated statements that a topic may appear on the exam, where the underlying topic is already mapped.
- Verbal corrections, filler, and transcription errors.

The repeated recommendation to use the Azure portal **was retained** because it is an operational learning expectation, not merely encouragement.

---

# 7. Gap Summary

No entirely missing substantive topic was found. Eight items were only partially explicit in the study outline:

1. Reading and interpreting custom role definitions rather than authoring them.
2. Management groups are primarily intended to manage multiple subscriptions.
3. Explicit review of manager/user/group properties in access management.
4. Portal-generated connection commands for Azure file shares.
5. Blob versioning is distinct from collaborative document versioning.
6. Entry-level/general-purpose VM sizing for low-complexity test workloads.
7. Separate availability sets for distinct application tiers, such as web and data tiers.
8. Explicit creation of a Recovery Services vault.

---

# 8. Exact Updates Required in the Study Outline

Add the following bullets to make the study outline fully explicit:

## Identity and Governance

- Be able to read and interpret a custom role definition without necessarily authoring one from scratch.
- Use management groups primarily to apply governance and access controls across multiple subscriptions.
- Review relevant user, group, and manager properties when interpreting access-management configurations.

## Storage

- Know that the Azure portal can generate platform-specific commands for connecting to an Azure file share.
- Distinguish Blob versioning, which preserves point-in-time blob states and version IDs, from collaborative document versioning.

## Compute

- Select lower-cost entry-level or general-purpose VM sizes for low-complexity development and testing workloads when advanced compute is unnecessary.
- Consider separate availability sets for separate application tiers, such as web and data tiers, when using availability-set designs.

## Monitoring and Recovery

- Know how to create a Recovery Services vault and identify the regional and access prerequisites for protecting a resource.

---

# 9. Final Coverage Result

| Domain | Covered | Partial | Missing | Non-substantive |
|---|---:|---:|---:|---:|
| Identities and Governance | 43 | 3 | 0 | 0 |
| Storage | 40 | 2 | 0 | 0 |
| Compute | 41 | 2 | 0 | 1 |
| Virtual Networking | 42 | 0 | 0 | 0 |
| Monitoring and Recovery | 36 | 1 | 0 | 0 |
| **Total** | **202** | **8** | **0** | **1** |

## Consistency Check

The detailed domain totals identify 202 covered mappings, 8 partial mappings, 0 missing mappings, and 1 non-substantive scope note. This equals 211 mapped rows in total, of which 210 are substantive or partially substantive study points.

After applying the eight updates listed above, all 210 substantive study points are explicitly covered. The Kubernetes row remains a non-substantive scope note because it describes excluded content rather than a topic to study.
