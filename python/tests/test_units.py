import numpy as np

from scphasedcn.names import parse_name
from scphasedcn.bins import Tiling, merge_intervals, in_intervals, overlap_bp


def test_parse_name():
    cb, rid, p, n, s = parse_name("TTGTTCCTCCCGCAAT_#97e7e0ae-4945-4cf6-bbf4-be87b7e3f675_+1of1")
    assert cb == "TTGTTCCTCCCGCAAT" and (p, n, s) == (1, 1, 1)
    assert rid == int("97e7e0ae49454cf6", 16)
    cb2, rid2, p2, n2, s2 = parse_name("-_#97e7e0ae-4945-4cf6-bbf4-be87b7e3f675_-3of3")
    assert cb2 == "-" and rid2 == rid and (p2, n2, s2) == (3, 3, -1)
    cb3, rid3, p3, n3, s3 = parse_name("plainread")
    assert (p3, n3, s3) == (1, 1, 0)


def test_regular_tiling():
    t = Tiling.regular_grid("chr1", 250_000, 100_000)
    assert len(t) == 3 and t.ends[-1] == 250_000
    assert t.bin_of(np.array([0, 99_999, 100_000, 249_999, 250_000, -1])).tolist() == [0, 0, 1, 2, -1, -1]
    fi, bi = t.bins_overlapping(np.array([99_950, 10]), np.array([200_150, 20]))
    assert fi.tolist() == [0, 0, 0, 1] and bi.tolist() == [0, 1, 2, 0]


def test_bundled_centromeres_cover_chrx():
    from scphasedcn.bins import read_centromere
    from scphasedcn.config import RESOURCES
    p = str(RESOURCES / "centromeres_hg38.tsv")
    assert read_centromere(p, "chrX") == (58605579, 62412542)   # Battenberg names chrX chr23
    assert read_centromere(p, "chr1") == (122026459, 125184587)


def test_intervals():
    s, e = merge_intervals(np.array([10, 0, 5, 50]), np.array([20, 6, 12, 60]))
    assert s.tolist() == [0, 50] and e.tolist() == [20, 60]
    assert in_intervals(np.array([0, 19, 20, 55, 60]), s, e).tolist() == [True, True, False, True, False]
    t = Tiling.regular_grid("chr1", 100, 25)
    assert overlap_bp(t, s, e).tolist() == [20, 0, 10, 0]


def test_translate_barcodes(tmp_path):
    from scphasedcn.config import translate_barcodes
    m = tmp_path / "map.tsv"
    m.write_text("index\tatac_barcode\trna_barcode\n1\tAAAA\tCCCC\n2\tGGGG\tTTTT\n")
    assert translate_barcodes(["CCCC", "TTTT", "NNNN"], str(m)) == (["AAAA", "GGGG"], "rna->atac")
    assert translate_barcodes(["AAAA", "GGGG"], str(m)) == (["AAAA", "GGGG"], "atac")
    assert translate_barcodes(["AAAA"], None) == (["AAAA"], "atac")
