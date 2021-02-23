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

DEBIAN_DEPS = ('git', 'curl', 'python3-pip', 'python3-venv', 'exuberant-ctags',
               'ack-grep')
ARCH_DEPS = ('git', 'curl', 'python-pip', 'ctags')

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
        self.distro_name: str

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
            self.distro_name = distro.name()
        elif distro.like() == "arch":
            self.package_manager = "pacman"
            self.distro_name = distro.name()
        else:
            self.error_msg(
                f"Your distro: {distro.like()} is not currently supported,\n"
                f"please open a pull request for support")

        self.info_msg(f"Found: {self.distro_name}")
        self.info_msg(f"Setting package manager to: {self.package_manager}")

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
            f"{c.BBlue}INFO{c.Reset}  {c.BWhite}{message}{c.Reset}\n")

    def exec_command(self, command: str) -> None:
        """
        wrapper around subproccess
        """
        self.info_msg(f"Running: {command}")
        try:
            ret: sp.CompletedProcess = sp.run(command, check=True, shell=True)
            status = ret.returncode
            self.info_msg("Done..")
        except sp.CalledProcessError as error:
            self.error_msg(f"{error} with return code: {status}")

    def install_pip_deps(self) -> bool:
        """
        Arb doc
        """
        for program in PYTHON_DEPS:
            cmd = "pip3 install " + program + " --user"
            self.exec_command(cmd)


if __name__ == "__main__":
    installer = Installer()
    installer.install_pip_deps()
