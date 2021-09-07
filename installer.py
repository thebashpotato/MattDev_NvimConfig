"""
Installer script for my Neovim configuration
Author: Matt Williams
License: None
"""

import argparse
import json
import os
import shutil
import subprocess as sp
import sys
from pathlib import Path
from typing import List, Dict


# check if user is root
if os.getenv("USER") == "root":
    sys.stderr.write(
        "\033[1;31mError\033[0m We humbly request that you do not run this script as root \n"
    )
    sys.exit(1)

# make sure the user isn't running this script with a virutal env activated, if they are exit,
# as the python dependencies need to be installed for the $USER,
# if they are not neovim won't be able to use them
if os.getenv("VIRTUAL_ENV"):
    sys.stderr.write(
        "\033[1;31mError\033[0m The python dependencies are meant to be installed globally\n"
        "      Please deactivate your virutal environment\n"
    )
    sys.exit(1)

import distro


class Log:
    """
    A convience wrapper class for formatted colorized output
    """

    black = "\033[1;30m"
    red = "\033[1;31m"
    grn = "\033[1;32m"
    yellow = "\033[1;33m"
    blue = "\033[1;34m"
    purp = "\033[1;35m"
    cyan = "\033[1;36m"
    white = "\033[1;37m"
    reset = "\033[0m"

    @staticmethod
    def info(msg: str):
        """
        Log a blue highlighted info msg
        """
        sys.stdout.write(f"{Log.grn}[✓]{Log.reset}  {Log.grn}{msg}{Log.reset}\n")

    @staticmethod
    def complete(msg: str):
        """
        Log a green completion message
        """
        sys.stdout.write(f"{Log.blue}[✓]{Log.reset}  {Log.white}{msg}{Log.reset}\n")

    @staticmethod
    def warn(msg: str):
        """
        Log a yellow highlighted warning message
        """
        sys.stdout.write(f"{Log.yellow}[!]{Log.reset}  {Log.white}{msg}{Log.reset}\n")

    @staticmethod
    def error(msg: str):
        """
        Log an error message then exit the program
        """
        sys.stderr.write(f"{Log.red}[x]{Log.reset}  {Log.white}{msg}{Log.reset}\n")
        sys.exit(1)


class MetaInfo:
    """
    represent the users distribution, with all needed meta data
    """

    def __init__(self):
        self.user = os.getenv("USER")
        self.distro = None
        self.pkgmanager = None
        self.install_commands = None
        self.dependencies: List[str] = list()
        self.python_dependencies: List[str] = list()
        self.rust_dependencies: List[str] = list()

        if not self.__parse_contents():
            raise RuntimeError("Could not load distro configuration")

    def __repr__(self) -> str:
        """
        Debug function
        """
        return (
            f"\tUser: {self.user}\n"
            f"\tDistro: {self.distro}\n"
            f"\tPackage Manager: {self.pkgmanager}\n"
            f"\tCommands: {self.install_commands}\n"
            f"\tDependencies: {self.dependencies}\n"
            f"\tPython Dependencies: {self.python_dependencies}\n"
            f"\tRust Dependencies: {self.rust_dependencies}\n"
        )

    def __str__(self) -> str:
        """
        Formatted output of relevent members
        """
        return (
            f"\tUser: {self.user}\n"
            f"\tDistro: {self.distro}\n"
            f"\tPackage Manager: {self.pkgmanager}\n"
        )

    @staticmethod
    def __load_file() -> (Dict[str, any] or None):
        """
        load the json file
        """
        here = Path(__file__).resolve(strict=True).parent
        for file in here.iterdir():
            if file.name == "deps.json":
                try:
                    with open(file, "r") as contents:
                        data: Dict[str, any] = json.load(contents)
                        return data
                except KeyError:
                    return None
        return None

    def __parse_contents(self) -> bool:
        """
        Use both distro.id and distro.like to accurately
        get the users distribution or parent distribution
        """
        try:
            json_data: Dict[str, any] = self.__load_file()
            if not json_data:
                return False
            distro_data: Dict[str, any] = json_data["distros"]
            self.python_dependencies = json_data["python-deps"]
            self.rust_dependencies = json_data["rust-deps"]

            for distro_type, pkgman in distro_data.items():
                if distro_type == distro.id() or distro_type in distro.like().split():
                    self.distro = distro.id()
                    for key, value in pkgman.items():
                        self.pkgmanager = key
                        self.install_commands = value["cmd"]
                        self.dependencies = value["deps"]
        except KeyError:
            return False

        return True


class Installer:
    """
    Installer object
    """

    def __init__(self):
        self.meta: MetaInfo
        self.config_home: Path
        self.nvm_home: Path
        self.meta = MetaInfo()

        # if the user has defined XDG_CONFIG_HOME we know where
        # node version manager will choose to install
        # its configuration files
        if os.getenv("XDG_CONFIG_HOME"):
            self.config_home = Path(os.getenv("XDG_CONFIG_HOME"))
        else:
            self.config_home = Path.home() / ".config"

        if os.getenv("NVM_DIR"):
            self.nvm_home = Path(os.getenv("NVM_DIR"))
        else:
            self.nvm_home = self.config_home / "nvm"

        self.nvm_home.mkdir(parents=True, exist_ok=True)
        self.neovim_home = self.config_home / "nvim"
        self.shell = os.getenv("SHELL")

    def __is_installed(self, command: str) -> bool:
        """
        wrapper around subproccess, to test if a program is already installed,
        this will not work for libraries etc, but only for executables
        :return: True, False
        """
        cmd = f"command -v {command}"
        ret: sp.CompletedProcess = sp.run(
            cmd, check=False, capture_output=True, shell=True
        )
        if ret.returncode != 0:
            # the program is not installed
            return False

        # the program is installed
        prog = ret.stdout.decode().strip("\n")
        Log.info(f"Found installation of {prog} Skipping...\n")
        return True

    def __exec_command(self, command: str) -> None:
        """
        wrapper around subproccess, if a command fails to execute properly,
        error_msg will print, and promptly exit the entire script.
        :return: None
        """
        Log.info(f"Running: {command}")
        try:
            sp.run(command, check=True, shell=True, executable=self.shell)
            Log.complete("Done...")
        except sp.CalledProcessError as error:
            Log.error(f"{error}")

    def __install_distro_dependencies(self) -> None:
        """
        Install dependencies through users package manager
        :returns: None
        """
        # install distro package manager based dependencies
        Log.info(f"Installing system dependencies for..\n{self.meta}")
        for prog in self.meta.dependencies:
            if not self.__is_installed(prog):
                self.__exec_command(
                    f"sudo {self.meta.pkgmanager} {self.meta.install_commands} {prog}"
                )

    def __install_python_dependencies(self) -> None:
        """
        Install python based dependencies through pip to users
        $HOME/.local/bin
        :returns: None
        """
        Log.info("Installing python dependencies\n")
        for prog in self.meta.python_dependencies:
            if not self.__is_installed(prog):
                self.__exec_command(f"pip3 install {prog} --user")

    def __install_node_version_manager(self) -> None:
        """
        First search and see if the user has a current installation of Node,
        if they do not, install node version manager
        :returns: None
        """
        Log.info("Installing Node Version Manager\n")
        if not self.__is_installed("node"):
            self.__exec_command(
                "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash"
            )
            # the fish shell requires extra set up
            if os.path.basename(self.shell) in "fish":
                Log.info("Found fish shell\n")
                if not self.__is_installed("fisher"):
                    Log.info("Installing Fisher package manager\n")
                    self.__exec_command(
                        "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
                    )
                    Log.info("Installing nvm for fisher\n")
                    self.__exec_command("fisher install jorgebucaran/nvm.fish")
                    self.__exec_command("nvm install latest")
                    self.__exec_command("set --universal nvm_default_version latest")
            else:
                Log.warn("Need to run node version manager for other shells")
                # TODO: Run nvm commands for other shells

        else:
            Log.info("Found Node Version Manager.. Skipping...\n")

    def __install_rustup(self) -> None:
        """
        First search and see if the user has a current installation of rustup,
        if they do not, install rustc, cargo etc
        """
        if not self.__is_installed("cargo"):
            Log.info("Installing the Rust toolchain\n")
            self.__exec_command(
                "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
            )
            # source the file
            self.__exec_command('bash -c "source $HOME/.cargo/env"')

        for prog in self.meta.rust_dependencies:
            if not self.__is_installed(prog):
                self.__exec_command(f"cargo install {prog}")

    def __install_config(self) -> None:
        """
        Install the actual configuration files
        """
        Log.info("Installing Neovim Configuration files\n")

        def copy_config() -> None:
            new_config = Path.cwd() / "nvim"
            Log.info("Installing new config\n")
            shutil.copytree(new_config, self.neovim_home)

        if self.neovim_home.is_dir():
            Log.info("Backing up your existing configurations")
            # back up the users existing configs
            config_dir = self.neovim_home.parent
            backup_config = config_dir / "nvim.bak"

            if not backup_config.exists():
                Log.info(f"Backing up your existing configurations to: {backup_config}")
                self.neovim_home.replace(backup_config)
            else:
                Log.warn(
                    f"{backup_config.name} already exists, removing and re-backing up\n"
                )
                shutil.rmtree(backup_config)
                self.neovim_home.replace(backup_config)

            copy_config()
        else:
            copy_config()

    def install_dependencies(self, arguments: argparse.Namespace) -> None:
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
        if arguments.uninstall:
            # run uninstallation code
            Log.error("Uninstalling is not yet supported")

        if arguments.install:
            self.__install_distro_dependencies()
            self.__install_python_dependencies()

            if arguments.rustup:
                self.__install_rustup()

            if arguments.nvm:
                self.__install_node_version_manager()

            self.__install_config()

            print()
            Log.info("Press Enter to finish installation")
            input()
            if not self.__is_installed("nvim"):
                Log.warn(
                    "Neovim was not found on your system, the config has been installed"
                )
            self.__exec_command("nvim")
            Log.complete("Your installation is now complete")


def main():
    """
    run the script
    """
    parser = argparse.ArgumentParser(
        prog="installer",
        usage="%(prog)s [options]",
        description="Install neovim config on supported platforms and include optional parameters",
        allow_abbrev=False,
        epilog="I hope you enjoy my config, please submit a pull request or open an issue for improvements",
    )

    group = parser.add_mutually_exclusive_group()

    group.add_argument(
        "-i",
        "--install",
        action="store_true",
    )
    group.add_argument(
        "-u",
        "--uninstall",
        action="store_true",
    )

    parser.add_argument(
        "--rustup",
        action="store_true",
        help="Install the rustup toolchain, and install sefr command line search engine program for neovim",
    )

    parser.add_argument(
        "--nvm", action="store_true", help="Install node version manager"
    )

    args = parser.parse_args()

    try:
        installer = Installer()
        installer.install_dependencies(args)
    except RuntimeError as error:
        Log.error(str(error))


if __name__ == "__main__":
    main()
