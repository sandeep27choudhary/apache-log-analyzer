# apache-log-analyzer

# Ansible Installation Guide

Follow these steps to install Ansible on a Linux system:

### Prerequisites:

1. **Python**
   
2. **Ansible**

### Installation Steps:

1. **Update Package Repository**:

   ```bash
   sudo apt update     # For Debian/Ubuntu
   sudo apt install -y python3 python3-pip  # For Debian/Ubuntu
   sudo pip3 install ansible
   sudo apt install ansible
   ansible --version
   ```
### to run the playbook
  ```bash
  cd ansible-playbook
  ansible-playbook log_analyzer.yml
  ```

### To run the script directly
  ```bash
  chmod +x server_log_analyzer.sh
  ./server_log_analyzer.sh <path to logs>
  ```


