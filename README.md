# Production-Grade DevOps Pipeline: Automated Cloud Provisioning & Event-Driven CD

An enterprise-grade, fully automated, event-driven CI/CD ecosystem designed to minimize manual infrastructure overhead, eliminate deployment drift, and guarantee repeatable cloud environments. This project establishes a hands-off Continuous Deployment (CD) pipeline that dynamically transitions infrastructure and application code modifications from a local workspace directly to a secured AWS layout within minutes.

---

## 🚀 What the Project Does

This project eliminates manual cloud operations by introducing a Zero-Touch Automation Strategy.
* Automated Provisioning: Programmatically creates a secure, public-facing AWS infrastructure topology on demand.
* Configuration Enforcement: Hardens operating system boundaries, provisions packages, and structures runtime server environments automatically.
* Continuous Integration & Delivery: Intercepts real-time source code changes from version control via secure network-boundary traversal tunnels to automatically orchestrate dynamic software rollouts.

---

## 🗺️ Architecture Overview & Workflow

The architecture follows a modular, decoupled structure that isolates stateful infrastructure declarations from stateless runtime application definitions.

 [ Local Workspace ] -> ( Git Push ) -> [ GitHub Repository ]
                                               |
                                        ( Secure Webhook )
                                               v
[ Private Target Host ] <- ( Deploy ) <- [ Jenkins Pipeline ]
       |                  
  ( Ansible ) -> Hardens Node & Deploys Nginx Application
       |
  ( Terraform ) -> Provisions VPC, Subnets, SG, & Remote S3 State Backend

### End-to-End Execution Sequence
1. Code Mutation: A developer pushes code modifications or infrastructure updates to the main branch.
2. Secure Webhook Ingress: GitHub issues an asynchronous event notification payload through a secure reverse-proxy edge tunnel configured with HTTP host-header rewriting parameters to traverse local security perimeters.
3. Pipeline Interception: The centralized Jenkins engine captures the event packet, evaluates it against active Source Code Management (SCM) warm cache indexes, and awakens the corresponding dynamic pipeline task.
4. Cloud Orchestration & Refresh: The pipeline evaluates declarative cloud configurations, reads and updates external isolated backend state stores, passes system controls to configuration plays, and synchronizes system paths to the production cloud instances seamlessly.

---

## 🛠️ Tech Stack & Tooling

The infrastructure and application lifecycle are managed using industry-standard DevOps tools:

| Domain | Technology Used | Application Purpose |
| :--- | :--- | :--- |
| Cloud Provider | Amazon Web Services (AWS) | Hosts core compute resources, virtual networks, and secure remote asset states. |
| Infrastructure as Code | Terraform | Codifies VPCs, Public Subnets, Internet Gateways, Dynamic Route Tables, and Security Group configurations. |
| State Management | AWS S3 Backend | Lock isolation and state map persistence utilizing dedicated remote bucket structures (umar-jenkins-state-bucket-2026). |
| Configuration Management | Ansible Core | Orchestrates operating system updates, server hardening, and automated Nginx load/configuration execution via structural roles. |
| CI/CD Automation Server | Jenkins Pipelines | Manages workflow schedules via repo-contained Jenkinsfile configurations and captures event webhook lifecycles. |
| Boundary Ingress Gateway | Ngrok | Establishes a secure local reverse-proxy link with custom header rewriting to safely route internet traffic to private subnets. |
| Source Control Management | Git / GitHub | Governs application state tracking, branch version management (*/main), and trigger events. |

---

## ⚙️ Core Engineering Insights & Optimizations

To ensure production stability, the following architectural challenges were discovered and permanently mitigated:
* Network Header Realignment: Configured edge controllers with --host-header="localhost:8080" parameters to resolve inbound HTTP host destination mismatch validation failures.
* Cache Preservation: Disabled shallow Lightweight Checkout layers in Jenkins to force structural Git metadata tracking, anchoring persistent webhook-to-job index matching on idle server states.
* Runtime Process Segregation: Separated background ingress networking daemons from frontend execution terminals within the Windows Subsystem for Linux (WSL2) environment to eliminate gateway timeouts.

---

## 🛠️ Installation & Baseline Initialization

### 1. Fire Up Inbound Perimeter Tunneling
ngrok http 8080 --host-header="localhost:8080"
*Leave this window running and extract your forwarding domain.*

### 2. Connect Your Webhook Engine
* Add your tunnel URL to your GitHub repository webhooks settings, targeting the core endpoint: https://<your-subdomain>.ngrok-free.dev/github-webhook/
* Toggle the content type to application/json and track the push event.

### 3. Establish the First Manual Cache Handshake
Before pushing code from your terminal, navigate to your Jenkins Pipeline dashboard and click Build Now. This initial run pulls down full git branch metadata trees, warming up the internal routing tables inside Jenkins' memory space so future automatic pushes trigger instantly.
