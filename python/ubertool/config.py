"""
This module provides the RP To-Do config functionality.
"""

import configparser
from pathlib import Path
import typer


config_dir_path = Path(typer.get_app_dir(__app_name__)) / "config.yaml"

def init_app(db_path: str):

    """
    Initialize the application.
    """

    path.mkdir(exist_ok=True)
    path.touch(exist_ok=True)


