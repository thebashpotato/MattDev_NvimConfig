"""
Installer script for my Neovim configuration
Author: Matt Williams
License: None
"""

import argparse
import os
import sys
import subprocess as sp
from pathlib import Path
import distro

DEBIAN_DEPS = ('curl', 'python3-pip', 'python3-venv', 'exuberant-ctags',
               'ack-grep')
ARCH_DEPS = ('curl', 'python-pip', 'ctags')

PYTHON_DEPS = ('pynvim', 'flake8', 'pylint', 'isort', 'yapf', 'jedi',
               'ranger-fm')

RUST_DEPS = ('sefr')


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
        # check for the users platform
        if sys.platform not in 'linux':
            self.error_msg(f"💻 '{sys.platform}' is currently not supported")

        # check if user is root
        if os.getenv('USER') in 'root':
            self.error_msg(
                "We humbly request that you do not run this script as root")

        # define members
        self.package_manager: str = ""
        self.distro_root: str = ""
        self.neovim_install_dir: Path = Path.home() / '.config' / 'nvim'
        self.user_shell: str = os.getenv('SHELL')

        # run private bootstrap methods
        self.__pre_reqs()

    def __pre_reqs(self) -> None:
        """
        get the name of the users linux distribution,
        currently supporting only Debian bases, and Arch bases
        :return: None, exit with an error message if users distro is not supported
        """
        # see if the users distro is a debian or arch based system
        for distribution in distro.like().split(" "):
            if distribution in "debian":
                self.package_manager = "apt-get"
                self.distro_root = distribution
            if distribution in "arch":
                self.package_manager = "pacman"
                self.distro_root = distribution

        # if package_manager is empty, then the users distro is not a debian or arch base
        if not self.package_manager:
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
            ret: sp.CompletedProcess = sp.run(command, check=True, shell=True)
            if ret.returncode == 0:
                self.info_msg("✅️ Done.. \n")
        except sp.CalledProcessError as error:
            if ret.returncode == 127:
                self.error_msg(
                    f"Could not locate {command}, "
                    f"have you enabled all repositories on {distro.name()}?")
            # for now for any other error code, just show the error message
            self.error_msg(f"{error}")

    def __install_distro_dependencies(self) -> None:
        """
        Install dependencies through users package manager
        :returns: None
        """
        # install distro package manager based dependencies
        if self.distro_root in "debian":
            # update the system first
            self.info_msg(f"🛫 Installing {distro.name()} dependencies\n")
            self.__exec_command(
                f"sudo {self.package_manager} update && sudo {self.package_manager} upgrade -y"
            )

            for prog in DEBIAN_DEPS:
                if not self.__is_installed(prog):
                    self.__exec_command(
                        f"sudo {self.package_manager} install {prog} -y")

        if self.distro_root in "arch":
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
        self.info_msg("🧰 Installing Node Version Manager\n")

    def __install_rustup(self) -> None:
        """
        First search and see if the user has a current installation of rustup,
        if they do not, install rustc, cargo etc
        """
        self.info_msg("🧰 Installing the Rust toolchain\n")

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

    def install_dependencies(self, optional=True) -> None:
        """
        public wrapper method around other modular methods
        that handle very specific installtion methods
        1. install distro dependencies
        2. install python dependencies
        3. install nvm
        4. install optional dependencies

        :returns: None
        """
        self.__install_distro_dependencies()

        self.__install_python_dependencies()

        self.__install_node_version_manager()

        if optional:
            self.__install_rustup()


if __name__ == "__main__":
    installer = Installer()
    installer.install_dependencies()
