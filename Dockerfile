FROM ncbi/edirect as edirect
FROM ubuntu:18.04 as blast
ARG version
LABEL Description="minimal docker image for NCBI blast+" Version=${version} Maintainer=xduan7@gmail.com

USER root
WORKDIR /root/

RUN \
    # install dependencies and tools
    # reference: https://www.ncbi.nlm.nih.gov/books/NBK409171/
    apt-get -y -m -q update && \
    apt-get -y -q install libidn11 libnet-perl libgomp1 liblist-moreutils-perl perl-doc curl elfutils && \
    rm -rf /var/lib/apt/lists/* && \
    # download ncbi blast+ binaries (including rpsbproc)
    mkdir -p /root/tmp && \
    cd /root/tmp && \
    curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}/ncbi-blast-${version}+-x64-linux.tar.gz | tar xzf -  && \
    curl -s ftp://ftp.ncbi.nlm.nih.gov/pub/mmdb/cdd/rpsbproc/RpsbProc-x64-linux.tar.gz | tar xzf - && \
    # copy the binaries over to /blast
    mkdir -p /blast && \
    cp -r ncbi-blast-${version}+/* /blast && \
    cp RpsbProc-x64-linux/rpsbproc RpsbProc-x64-linux/rpsbproc.ini  /blast/bin && \
    # download the data files for rpsbproc
	mkdir -p /blast/data && \
	cd /blast/data && \
	curl -s ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cdtrack.txt -o cdtrack.txt && \
	curl -s ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/bitscore_specific.txt -o bitscore_specific.txt && \
	curl -s ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/family_superfamily_links -o family_superfamily_links && \
	curl -s ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cddid.tbl.gz -o cddid.tbl.gz && gzip -d cddid.tbl.gz && \
	curl -s ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cddannot.dat.gz -o cddannot.dat.gz && gzip -d cddannot.dat.gz && \
	curl -s ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/cddannot_generic.dat.gz -o cddannot_generic.dat.gz && gzip -d cddannot_generic.dat.gz && \
	# clean up and finalize the balast folder
	rm -rf /root/tmp/ && \
	mkdir -p /blast/db /blast/queries /blast/results && \
	apt-get -y -q remove --purge --auto-remove curl

COPY --from=edirect /usr/local/ncbi/edirect /root/edirect
ENV PATH="/blast/bin:/root/edirect:${PATH}"
WORKDIR /blast
CMD ["/bin/bash"]
