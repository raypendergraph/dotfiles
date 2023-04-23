
import typer

app = typer.Typer()

def _load():
    from . import commands
    from . import cert
    app.add_typer(cert.app, name='cert')

_load()
