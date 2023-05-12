FROM  ubuntu:18.04

WORKDIR /opt/software


# Make RUN commands use `bash --login` (always source ~/.bashrc on each RUN)
SHELL ["/bin/bash", "--login", "-c"]

# install apt dependencies and update conda
RUN apt-get  --allow-releaseinfo-change  update && apt-get install git -y \
    && apt-get install -y apt-transport-https ca-certificates wget unzip python3-pip make gawk  bzip2 libfontconfig1 \
    && update-ca-certificates \
    && apt-get -qq -y remove curl \
    && apt-get install -y g++ gcc \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log 
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.9.2-Linux-$(uname -m).sh
RUN bash Miniconda3-py37_4.9.2-Linux-$(uname -m).sh -b -p /opt/miniconda3

# Set up conda environment
ENV PATH /opt/miniconda3/bin:$PATH
RUN conda config --set ssl_verify no
COPY ./environmentDocker.yml /opt/environment.yml
# Install Centrifuge
# RUN which conda
RUN conda env create -f /opt/environment.yml
# RUN conda install -y  -c conda-forge  anytree pip  openblas=0.3.18 numpy
# RUN conda install -c conda-forge pandas
# COPY ./install.sh /opt/install.sh 
# RUN bash /opt/install.sh
 

SHELL ["conda", "run", "-n", "mytax", "/bin/bash", "-c"]




# Define databases that are shipped with the image
# COPY databases /opt/databases

# WORKDIR /opt/databases

# RUN mkdir -p /opt/databases && \
#     wget ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz -O /opt/databases/minikraken2.tar.gz && \
#     tar -xvzf minikraken2.tar.gz && rm -rf /opt/databases/minikraken2.tar.gz

WORKDIR /opt/software/mytax
COPY src/*.sh /opt/software/mytax/
RUN find . -name "*.sh" | while read fn; do ln -s $PWD/$fn /usr/local/bin; done 
# # Define Flukraken by building from source with jellyfish 
# RUN  bash /opt/software/mytax/build_flukraken.sh -k /opt/databases/flukraken2

## Get Centrifuge database
# RUN wget https://genome-idx.s3.amazonaws.com/centrifuge/p_compressed%2Bh%2Bv.tar.gz -O /opt/databases/centrifuge.tgz && \
#     mkdir -p /opt/databases/centrifuge && tar -xvzf /opt/databases/centrifuge.tgz --directory /opt/databases/centrifuge/





COPY src/*.py /opt/software/mytax/ 

COPY sunburst /opt/software/mytax/sunburst
RUN python3 /opt/software/mytax/generate_hierarchy.py -o /taxdump -download --report sample.report
RUN rm -rf /tmp/*
WORKDIR /opt/software/mytax/

ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "mytax"]


