'''
This module provides the CLI for UberTool.
'''
from typing import Optional
from ubertool import __app_name__, __version__, tls
import logging
import os
import typer


logging.basicConfig(
        level=os.environ.get('LOG_LEVEL', 'INFO').upper())

app = typer.Typer()
app.add_typer(tls.app, name='tls')

def _version_callback(value: bool) -> None:

    if value:

        typer.echo(f'{__app_name__} v{__version__}')

        raise typer.Exit()


@app.callback()
def main(
        version: Optional[bool] = typer.Option(
            None,
            '--version',
            '-v',
            help='Show the application\'s version and exit.',
            callback=_version_callback,
            is_eager=True,
            )
        ) -> None:

    return
