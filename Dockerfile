FROM ncbi/edirect as edirect
FROM ubuntu:18.04 as blast
ARG version
LABEL Description="minimal docker image for NCBI blast+" Version=${version} Maintainer=xduan7@gmail.com

USER root
WORKDIR /root/

RUN \
    # install dependencies and tools
    # reference: https://www.ncbi.nlm.nih.gov/books/NBK409171/
    echo "installing dependencies and tools ... " && \
    apt-get -y -m -q update && \
    apt-get -y -q install libidn11 libnet-perl libgomp1 liblist-moreutils-perl perl-doc wget elfutils && \
    rm -rf /var/lib/apt/lists/* && \
    # download ncbi blast+ binaries (including rpsbproc)
    echo "downloading ncbi blast+ binaries (including rpsbproc) ... " && \
    mkdir -p /root/tmp && \
    cd /root/tmp && \
    wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-linux.tar.gz && tar -xzf ncbi-blast-${version}+-x64-linux.tar.gz && \
    wget -q ftp://ftp.ncbi.nlm.nih.gov/pub/mmdb/cdd/rpsbproc/RpsbProc-x64-linux.tar.gz && tar -xzf RpsbProc-x64-linux.tar.gz && \
    # copy the binaries over to /blast
    mkdir -p /blast && \
    cp -r ncbi-blast-${version}+/* /blast && \
    cp RpsbProc-x64-linux/rpsbproc RpsbProc-x64-linux/rpsbproc.ini  /blast/bin && \
    # download the data files for rpsbproc
    echo "download the data files for rpsbproc ... " && \
	mkdir -p /blast/data && \
	cd /blast/data && \
	wget -q ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cdtrack.txt && \
	wget -q ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/bitscore_specific.txt && \
	wget -q ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/family_superfamily_links && \
	wget -q ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cddid.tbl.gz && gzip -d cddid.tbl.gz && \
	wget -q ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cddannot.dat.gz && gzip -d cddannot.dat.gz && \
	wget -q ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cddannot_generic.dat.gz && gzip -d cddannot_generic.dat.gz && \
	# clean up and finalize the blast folder
    echo "cleaning up ... " && \
	rm -rf /root/tmp/ && \
	mkdir -p /blast/db /blast/queries /blast/results && \
	apt-get -y -q remove --purge --auto-remove wget

COPY --from=edirect /usr/local/ncbi/edirect /root/edirect
ENV PATH="/blast/bin:/root/edirect:${PATH}"
WORKDIR /blast
CMD ["/bin/bash"]
