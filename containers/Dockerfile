# scphasedcn (R package + Python extractor) in one image (R, Python, htslib tools). Built by .github/workflows/container.yaml and pushed to
# ghcr.io/<owner>/scphasedcn:<tag>. Apptainer / Singularity users: apptainer pull docker://ghcr.io/<owner>/scphasedcn:<tag>
#   apptainer exec scphasedcn_<tag>.sif scphasedcn run --help
#   apptainer exec scphasedcn_<tag>.sif call_scn.R --help
# Phasing tools (Clair3, longphase) are not included; use their own images (see vignette "scphasedcn-inputs").
FROM mambaorg/micromamba:1.5.10

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml
RUN micromamba install -y -n base -f /tmp/environment.yml && micromamba clean --all --yes

ARG MAMBA_DOCKERFILE_ACTIVATE=1
COPY --chown=$MAMBA_USER:$MAMBA_USER . /tmp/scphasedcn
RUN pip install --no-deps --no-cache-dir /tmp/scphasedcn/python \
 && R CMD INSTALL --no-docs --no-multiarch /tmp/scphasedcn \
 && install -m 0755 /tmp/scphasedcn/inst/scripts/call_scn.R /opt/conda/bin/call_scn.R \
 && rm -rf /tmp/scphasedcn \
 && scphasedcn --version \
 && Rscript -e 'library(scphasedcn); cat(as.character(packageVersion("scphasedcn")), "\n")'

# apptainer exec does not run the micromamba entrypoint: put the environment on the PATH directly
ENV PATH=/opt/conda/bin:$PATH OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["bash"]
