from ubertool.common.options import OutputFormat
from typing import Optional
import logging
import os
import typer

logger = logging.getLogger(__name__)

def dump_chain(
        host: str = typer.Argument(..., help='The remote host'), 
        port: int = typer.Argument(..., help='The remote port'),
        rich: bool = typer.Option(False, help='Enhanced formatting output in rich text. Default is false' )):
    """
        Prints import attributes of the certificate chain to standard out.

        Defaults to json output
    """
    
    import json 
    import ssl 
    from .x509_utils import resolve_cert_chain, CertificateEncoder
    from cryptography import x509
   
    logger.debug(f'host={host} port={port}')
    pem_ascii = ssl.get_server_certificate((host, port))
    cert = x509.load_pem_x509_certificate(bytes(pem_ascii, 'utf-8'))
    chain = resolve_cert_chain(cert)
    if rich:
        from .rich import x509_table
        from rich import print as rich_print
        for c in chain:
            rich_print(x509_table(c))
        return
    
    print(json.dumps(chain, cls=CertificateEncoder))

