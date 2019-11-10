#################################################
FROM dschartman/miniconda_base as base

#################################################
FROM base as staging

# RUN 

#################################################
FROM base

ENV PYTHONDONTWRITEBYTECODE true