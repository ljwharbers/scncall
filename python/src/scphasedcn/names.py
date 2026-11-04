"""Read-name conventions of the SPLONGGET DNA BAMs: `<CB>_#<uuid>_<sign><piece>of<npieces>`."""
from __future__ import annotations

import hashlib
import re

_NAME = re.compile(r"^([^_]*)_#([0-9a-fA-F-]{36})_([+-])(\d+)of(\d+)$")


def _name_id(name: str) -> int:
    """Stable 64-bit id of a read name (blake2b; unlike hash(), the same in every process)."""
    return int.from_bytes(hashlib.blake2b(name.encode(), digest_size=8).digest(), "big")


def parse_name(name: str) -> tuple[str, int, int, int, int]:
    """Return (cb_prefix, read_id, piece, n_pieces, sign) where read_id is the first 64 bits of the raw-read uuid.

    Pieces of one raw read share the uuid (same `read_id`), so two fragments with equal read_id come from the same
    raw read. Unparseable names get read_id = a stable 64-bit digest of the whole name, piece 1 of 1, sign 0.
    """
    m = _NAME.match(name)
    if m is None:
        return name, _name_id(name), 1, 1, 0
    cb, u, sign, p, n = m.groups()
    rid = int(u[0:8] + u[9:13] + u[14:18], 16)
    return cb, rid, int(p), int(n), (1 if sign == "+" else -1)
