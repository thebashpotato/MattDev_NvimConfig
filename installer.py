"""
Installer script for my Neovim configuration
Author: Matt Williams
License: None
"""

import os
import shutil
import subprocess as sp
import sys
from pathlib import Path

# check if user is root
if os.getenv('USER') == 'root':
    sys.stderr.write(
        "\033[1;31mError\033[0m We humbly request that you do not run this script as root \n"
    )
    sys.exit(1)

# check for the users platform
if sys.platform != 'linux':
    sys.stderr.write(
        f"\033[1;31mError\033 [0m💻 '{sys.platform}' is currently not supported \n"
    )
    sys.exit(1)

# make sure the user isn't running this script with a virutal env activated, if they are exit,
# as the python dependencies need to be installed for the $USER,
# if they are not neovim won't be able to use them
if os.getenv('VIRTUAL_ENV'):
    sys.stderr.write(
        "\033[1;31mError\033[0m The python dependencies are meant to be installed globally\n"
        "      Please deactivate your virutal environment\n")
    sys.exit(1)

import distro

DEBIAN_DEPS = [
    'curl', 'wget', 'python3-pip', 'python3-venv', 'exuberant-ctags',
    'ack-grep'
]
ARCH_DEPS = ['curl', 'python-pip', 'ctags']

PYTHON_DEPS = [
    'pynvim', 'flake8', 'pylint', 'isort', 'yapf', 'jedi', 'ranger-fm'
]

RUST_DEPS = ['sefr']


class Colors:
    """
    Struct to represent colors
    """
    BBlack = "\033[1;30m"
    BRed = "\033[1;31m"
    BGreen = "\033[1;32m"
    BYellow = "\033[1;33m"
    BBlue = "\033[1;34m"
    BPurple = "\033[1;35m"
    BCyan = "\033[1;36m"
    BWhite = "\033[1;37m"
    Reset = "\033[0m"


class Installer:
    """
    Installer object
    """
    def __init__(self):
        self.package_manager: str = ""
        self.distro_root: str = ""
        self.neovim_home: Path = Path.home() / '.config' / 'nvim'
        self.nvm_home: Path = Path.home() / '.nvm'
        if not self.nvm_home.is_dir():
            self.nvm_home = Path.home() / '.config' / 'nvm'
        self.shell: str = os.getenv('SHELL')

        # fill all variables with system requires before beginning install
        self.__system_requires()

    def __system_requires(self) -> None:
        """
        get the name of the users linux distribution,
        currently supporting only Debian bases, and Arch bases

        NOTE: Some distros such as antiX don't use the distro.like() method for listing
              the parent distro, this is lazyness on there part.

        :return: None, exit with an error message if users distro is not supported
        """
        # see if the users distro is a debian or arch based system
        for distribution in distro.like().split(" "):
            if distribution in ('debian', 'ubuntu'):
                self.package_manager = "apt-get"
                self.distro_root = distribution
            elif distribution == "arch":
                self.package_manager = "pacman"
                self.distro_root = distribution
            else:
                self.error_msg(
                    f"Your distro: {distro.name()} is not currently supported, "
                    f"please open an issue for support, or submit a pr")

        self.info_msg(f"Found: {self.distro_root} based distro")
        self.info_msg(f"Setting package manager to: {self.package_manager}\n")

    def __is_installed(self, command: str) -> bool:
        """
        wrapper around subproccess, to test if a program is already installed,
        this will not work for libraries etc, but only for executables
        :return: True, False
        """
        cmd = f"command -v {command}"
        ret: sp.CompletedProcess = sp.run(cmd,
                                          check=False,
                                          capture_output=True,
                                          shell=True)
        if ret.returncode != 0:
            # the program is not installed
            return False

        # the program is installed
        prog = ret.stdout.decode().strip('\n')
        self.info_msg(f"Found installation of {prog} Skipping...\n")
        return True

    def __exec_command(self, command: str) -> None:
        """
        wrapper around subproccess, if a command fails to execute properly,
        error_msg will print, and promptly exit the entire script.
        :return: None
        """
        self.info_msg(f"Running: {command}")
        try:
            sp.run(command, check=True, shell=True, executable=self.shell)
            self.info_msg("✅️ Done.. \n")
        except sp.CalledProcessError as error:
            self.error_msg(f"{error}")

    def __install_distro_dependencies(self) -> None:
        """
        Install dependencies through users package manager
        :returns: None
        """
        # install distro package manager based dependencies
        if self.distro_root == "debian":
            # update the system first
            self.info_msg(f"🛫 Installing {distro.name()} dependencies\n")
            self.__exec_command(
                f"sudo {self.package_manager} update && sudo {self.package_manager} upgrade -y"
            )

            for prog in DEBIAN_DEPS:
                if not self.__is_installed(prog):
                    self.__exec_command(
                        f"sudo {self.package_manager} install {prog} -y")

        if self.distro_root == "arch":
            self.info_msg(f"🛫 Installing {distro.name()} dependencies\n")
            self.__exec_command(f"sudo {self.package_manager} -Syu")

            for prog in ARCH_DEPS:
                if not self.__is_installed(prog):
                    self.__exec_command(
                        f"sudo {self.package_manager} -S {prog}")

    def __install_python_dependencies(self) -> None:
        """
        Install python based dependencies through pip to users
        $HOME/.local/bin
        :returns: None
        """
        self.info_msg("🛫 Installing python dependencies\n")
        for prog in PYTHON_DEPS:
            if not self.__is_installed(prog):
                self.__exec_command(f"pip3 install {prog} --user")

    def __install_node_version_manager(self) -> None:
        """
        First search and see if the user has a current installation of Node,
        if they do not, install node version manager
        :returns: None
        """
        if not self.nvm_home.is_dir():
            self.info_msg("🧰 Installing Node Version Manager\n")
            self.__exec_command(
                "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash"
            )
            # the fish shell requires extra set up
            if os.path.basename(self.shell) in "fish":
                self.info_msg("Found fish shell\n")
                if not self.__is_installed("fisher"):
                    self.info_msg("Installing Fisher package manager\n")
                    self.__exec_command(
                        "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
                    )
                    self.info_msg("Installing nvm for fisher\n")
                    self.__exec_command("fisher install jorgebucaran/nvm.fish")
                    self.__exec_command("nvm install latest")
                    self.__exec_command(
                        "set --universal nvm_default_version latest")
            else:
                ...
                # TODO: Run nvm commands for other shells

        else:
            self.info_msg("Found Node Version Manager.. Skipping...\n")

    def __install_rustup(self) -> None:
        """
        First search and see if the user has a current installation of rustup,
        if they do not, install rustc, cargo etc
        """
        if not self.__is_installed("cargo"):
            self.info_msg("🧰 Installing the Rust toolchain\n")
            self.__exec_command(
                "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
            )
            # source the file
            self.__exec_command('bash -c "source $HOME/.cargo/env"')

        for prog in RUST_DEPS:
            if not self.__is_installed(prog):
                self.__exec_command(f"cargo install {prog}")

    def __install_config(self) -> None:
        """
        Install the actual configuration files
        """
        self.info_msg("🧰 Installing Neovim Configuration files\n")

        def copy_config() -> None:
            new_config = Path.cwd() / 'nvim'
            self.info_msg("Installing new config\n")
            shutil.copytree(new_config, self.neovim_home)

        if self.neovim_home.is_dir():
            self.info_msg("Backing up your existing configurations")
            # back up the users existing configs
            config_dir = self.neovim_home.parent
            backup_config = config_dir / 'nvim.bak'

            if not backup_config.exists():
                self.info_msg(
                    f"Backing up your existing configurations to: {backup_config}"
                )
                self.neovim_home.replace(backup_config)
            else:
                self.warn_msg(
                    f"{backup_config.name} already exists, removing and re-backing up\n"
                )
                shutil.rmtree(backup_config)
                self.neovim_home.replace(backup_config)

            copy_config()
        else:
            copy_config()

    @staticmethod
    def error_msg(message: str) -> None:
        """
        outputs colorized error message and exits
        :return: None
        """
        c = Colors
        sys.stderr.write(
            f"{c.BRed}ERROR{c.Reset}  {c.BWhite}{message}{c.Reset}\n")
        sys.exit(1)

    @staticmethod
    def warn_msg(message: str) -> None:
        """
        outputs colorized warning message
        :return: None
        """
        c = Colors
        sys.stdout.write(
            f"{c.BYellow}WARNING{c.Reset}  {c.BWhite}{message}{c.Reset}\n")

    @staticmethod
    def info_msg(message: str) -> None:
        """
        outputs colorized info message
        :return: None
        """
        c = Colors
        sys.stdout.write(
            f"{c.BGreen}INFO{c.Reset}  {c.BBlue}{message}{c.Reset}\n")

    def install_dependencies(self) -> None:
        """
        public wrapper method around other modular methods
        that handle very specific installtion methods
        1. install distro dependencies
        2. install python dependencies
        3. install nvm
        4. install rustup
        5. install the actual configs

        :returns: None
        """
        self.__install_distro_dependencies()

        self.__install_python_dependencies()

        self.__install_node_version_manager()

        self.__install_rustup()

        self.__install_config()

        print()
        self.info_msg("Press Enter to finish installation")
        input()
        self.__exec_command("nvim")


if __name__ == "__main__":
    installer = Installer()
    installer.install_dependencies()
