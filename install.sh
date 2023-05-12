
# conda create -f environment.yaml


## Make sure that mytax env is activated first!
# # Install kraken1
# rm -rf $CONDA_PREFIX/lib/kraken1
# git clone https://github.com/DerrickWood/kraken.git $CONDA_PREFIX/lib/kraken1
# cd $CONDA_PREFIX/lib/kraken1
# echo $PWD
# bash install_kraken.sh $CONDA_PREFIX/bin

# find envs -name "*.yml" -exec conda create -f {} \;

#If you have a Mac, make sure Xcode is updated and installed. If windows, use cygwin or install in a docker container
git clone https://github.com/infphilo/centrifuge centrifuge && \
make -C centrifuge && \
make install -C centrifuge prefix=$CONDA_PREFIX || # catch
cp centrifuge/centrifuge-* /usr/local/bin/ && chmod +x /usr/local/bin/centrifuge*


git clone https://github.com/DerrickWood/kraken2.git kraken2

KRAKEN2_DIR=/usr/local/bin
cd kraken2
bash install_kraken2.sh $KRAKEN2_DIR

cd ..

# try


