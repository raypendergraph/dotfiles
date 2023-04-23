from cryptography import x509
from cryptography.hazmat.primitives import hashes
from rich.table import Table

sha1 = hashes.SHA1()
sha256 = hashes.SHA256()

def x509_table(cert: x509) -> Table:
    from rich.table import Column
    from rich import box

    t = Table(Column(style='bold'),
                     Column(),
                     expand=True,
                     show_header=False,
                     box=box.ROUNDED)
    t.add_row('issuer', cert.issuer.rfc4514_string())
    t.add_row('subject', cert.subject.rfc4514_string())
    t.add_row('serial', '%X' % cert.serial_number)
    t.add_row('sha1', cert.fingerprint(sha1).hex(':').upper())
    t.add_row('sha256', cert.fingerprint(sha256).hex(':').upper())

    return t 
