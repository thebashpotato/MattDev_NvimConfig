"""
Installer script for Neovim configuration
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

PYTHON_DEPS = ('pynvim', 'flake8', 'pylint', 'isort', 'yapf', 'jedi')


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
        if sys.platform != 'linux':
            self.error_msg(f"💻 '{sys.platform}' is currently not supported")

        # define members
        self.package_manager: str
        self.distro_root: str

        # run private bootstrap methods
        self.__pre_reqs()

    def __pre_reqs(self) -> None:
        """
        get the name of the users linux distibution,
        currently supporting only Ubuntu bases, and Arch bases
        :return: None, if unsupported
        """
        if distro.like() == "debian":
            self.package_manager = "apt-get"
            self.distro_root = distro.like()
        elif distro.like() == "arch":
            self.package_manager = "pacman"
            self.distro_root = distro.like()
        else:
            self.error_msg(
                f"Your distro: {distro.name()} is not currently supported,\n"
                f"please open a pull request for support")

        self.info_msg(f"Found: {self.distro_root} based distro")
        self.info_msg(f"Setting package manager to: {self.package_manager}\n")

    def _exec_command(self, command: str) -> None:
        """
        wrapper around subproccess
        """
        self.info_msg(f"Running: {command}")
        try:
            ret: sp.CompletedProcess = sp.run(command, check=True, shell=True)
            status = ret.returncode
            self.info_msg("✅ Done.. \n")
        except sp.CalledProcessError as error:
            self.error_msg(f"{error} with return code: {status}")

    @staticmethod
    def error_msg(message: str) -> None:
        """
        outputs colorized error message and exits
        """
        c = Colors
        sys.stderr.write(
            f"{c.BRed}ERROR{c.Reset}  {c.BWhite}{message}{c.Reset}\n")
        sys.exit(1)

    @staticmethod
    def warn_msg(message: str) -> None:
        """
        outputs colorized warning message
        """
        c = Colors
        sys.stdout.write(
            f"{c.BYellow}WARNING{c.Reset}  {c.BWhite}{message}{c.Reset}\n")

    @staticmethod
    def info_msg(message: str) -> None:
        """
        outputs colorized info message
        """
        c = Colors
        sys.stdout.write(
            f"{c.BGreen}INFO{c.Reset}  {c.BBlue}{message}{c.Reset}\n")

    def install_dependencies(self) -> None:
        """
        Arb doc
        """
        # install distro package manager based dependencies
        if self.distro_root == "debian":
            # update the system first
            cmd = f"sudo {self.package_manager} update && sudo {self.package_manager} upgrade -y"
            self.info_msg(f"🛫 Installing {distro.name()} dependencies\n")
            self._exec_command(cmd)
            for prog in DEBIAN_DEPS:
                cmd = f"sudo {self.package_manager} install {prog}"
                self._exec_command(cmd)
        else:
            # for now, else means we are dealing with an arch based distro
            # update the system first
            cmd = f"sudo {self.package_manager} -Syu"
            self.info_msg(f"🛫 Installing {distro.name()} dependencies\n")
            self._exec_command(cmd)
            for prog in ARCH_DEPS:
                cmd = f"sudo {self.package_manager} -S {prog}"
                self._exec_command(cmd)

        self.info_msg("🛫 Installing python dependencies\n")
        for prog in PYTHON_DEPS:
            cmd = f"pip3 install {prog} --user"
            self._exec_command(cmd)


if __name__ == "__main__":
    installer = Installer()
    installer.install_dependencies()
