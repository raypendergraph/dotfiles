import typer

app = typer.Typer()

def _load():
    from . import commands
    app.command('dump-chain')(commands.dump_chain)

_load()
