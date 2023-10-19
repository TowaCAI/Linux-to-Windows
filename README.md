# Custom Windows 10 ISO with VirtIO Drivers

This script is designed to assist you in creating a customized Windows 10 ISO with VirtIO drivers. VirtIO drivers are device drivers optimized for virtual machines, providing improved performance and hardware compatibility. This script is intended for users running virtual machines based on KVM/QEMU who need a Windows 10 ISO with VirtIO drivers integrated.

## Prerequisites

Before running the script, ensure you have the following:

- A system running Linux (tested on Ubuntu)
- Root user privileges
- The official Windows 10 ISO from Microsoft's website: [Download Windows 10](https://www.microsoft.com/en-us/software-download/windows10)
  - Rename the downloaded ISO file to `Win10.iso` and place it in the same directory as this script.

## Usage

1. Clone this repository to your Linux system or download the script file.
2. Open your terminal and navigate to the directory where the script is located.
3. Ensure the script is executable by running:

    ```bash
    chmod +x linux-to-windows.sh
    ```

4. Run the script with administrative privileges:

    ```bash
    sudo ./linux-to-windows.sh
    ```

5. Follow the on-screen prompts and instructions provided by the script to create your customized Windows 10 ISO.

## Important Notes

- Be cautious when using this script, as it makes modifications to the Windows 10 ISO, your disk partitions, and the Grub bootloader configuration.
- Ensure you have a backup of any important data before running the script.
- The script assumes you are using Ubuntu or a similar Linux distribution; minor adjustments may be necessary for other distributions.

## License

This script is provided under the [MIT License](LICENSE).

## Support

If you encounter issues or have questions, please [create an issue](https://github.com/TowaCAI/Linux-to-Windows/issues) on this repository.

## Acknowledgments

- The script was inspired by the need to create Windows 10 VMs with VirtIO drivers in a KVM/QEMU environment.

---

**Disclaimer**: Use this script at your own risk. The authors and maintainers of this script are not responsible for any data loss or damage to your system resulting from its use. Please review the script and its instructions carefully before proceeding.
