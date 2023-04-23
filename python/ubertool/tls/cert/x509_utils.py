from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.x509.oid import ExtensionOID ,AuthorityInformationAccessOID, NameOID
from dataclasses import dataclass
from json import JSONEncoder
from typing import Self, Optional
import logging

logger = logging.getLogger(__name__)

class CertificateEncoder(JSONEncoder):
    sha1 = hashes.SHA1()
    sha256 = hashes.SHA256()

    def default(self, cert: x509):
        return dict(issuer=cert.issuer.rfc4514_string(),
                    subject=cert.subject.rfc4514_string(),
                    serial='%X' % cert.serial_number,
                    sha1=cert.fingerprint(self.sha1).hex(':').upper(),
                    sha256=cert.fingerprint(self.sha256).hex(':').upper())


def is_root(cert: x509) -> bool:

    """
    Checks whether the certificate is a root
    """
    return cert.subject == cert.issuer


def is_ca(cert: x509) -> bool:

    """
    Checks whether the Certificate Authority bit has been set
    """
    try:
        ext = cert.extensions.get_extension_for_oid(ExtensionOID.BASIC_CONSTRAINTS)
        return True if ext.value.ca else False
    except x509.extensions.ExtensionNotFound:
        pass

    return False


def resolve_parent_cert(cert: x509) -> Optional[x509]:

    """
    Resolves the parent parent/issuer of this cert. 
    """
    import urllib3

    infoAccessUrl = ca_issuer_access_url(cert)
    if not infoAccessUrl:
        return None

    http = urllib3.PoolManager()
    resp = http.request('GET', infoAccessUrl)
    if resp.status >= 400:
        logger.warn(f'Could not resolve parent certificate at {infoAccessUrl}: {resp.status}')
        return None

    return x509.load_der_x509_certificate(resp.data)


def resolve_cert_chain(cert: x509) -> list[x509]:
    """
    Resolves the entire chain by resolving each certificate 
    up to the last parent.
    """
    chain = [cert]
    parent = resolve_parent_cert(cert)

    while parent:
        chain.append(parent)
        parent = resolve_parent_cert(parent)

    return list(reversed(chain))


def ca_issuer_access_url(cert: x509) -> Optional[str]:
    
    """
    Gets the URL that contains the CA issuer certificate for 
    this certificate.
    """
    access_location = None
    try:
        aias = cert.extensions.get_extension_for_oid(ExtensionOID.AUTHORITY_INFORMATION_ACCESS)
        for aia in aias.value:
            if AuthorityInformationAccessOID.CA_ISSUERS == aia.access_method:
                access_location = aia.access_location.value
                logging.debug('access location: %s', access_location)
    except x509.extensions.ExtensionNotFound:
        pass

    return access_location


def common_name(cert: x509) -> Optional[str]:
    for attr in cert.subject.get_attributes_for_oid(NameOID.COMMON_NAME):
        return attr.value

 
def subject_alternative_names(cert: x509)-> list[str]:
    """
    Extracted x509 Extensions 
    """
    names = []
    try:
        ext = cert.extensions.get_extension_for_oid(ExtensionOID.SUBJECT_ALTERNATIVE_NAME)
        names = ext.value.get_values_for_type(x509.DNSName)
    except x509.extensions.ExtensionNotFound:
        pass

    return name
