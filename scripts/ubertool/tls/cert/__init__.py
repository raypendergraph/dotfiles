import typer

app = typer.Typer()

def _load():
    from . import commands
    app.command('dump-cert-chain')(commands.dump_certificate_chain)

_load()
