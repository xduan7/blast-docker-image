# Minimal Docker Image for NCBI Blat+ (with RpsbProc)

This is a minimal docker image based on the [official NCBI blast docker](https://github.com/ncbi/docker.git), which is **36.8% smaller** compared to the official one.

```
>>>
docker images --format='table {{.Repository}}\t{{.Tag}}\t{{.Size}}' 
<<<
REPOSITORY             TAG                 SIZE
xduan7/blast           2.9.0               935MB
xduan7/blast           2.8.1               932MB
xduan7/blast           2.10.0              860MB
xduan7/blast           2.10.1              867MB
xduan7/blast           latest              867MB
ncbi/blast             2.10.1              1.34GB
```

There are two major modifications over the original version:
- use ready-to-run blast+ binaries instead of compiling from the source code
- add [RpsbProc](ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/rpsbproc/) program for pose-rpsblast processing 

---
## Getting Started

You can either pull the docker image directly from [DockerHub](https://hub.docker.com/repository/docker/xduan7/blast) like this:
```commandline
docker pull xduan7/blast:latest     # or some other pre-build tag (blast+ version)
```
Or build your own image with your own preferred blast+ version like this:
```commandline
chmod +x build.sh
./build.sh -u <dockerhub_username> -v <blast+ version (e.g. 2.10.1)>
```

---
## Docker Image Details

On top of Ubuntu 18.04 image, a folder '/blast' is created and all the binaries are there. 
The structure of '/blast' is shown below.

```
$tree /blast
.
|-- ChangeLog
|-- LICENSE
|-- README
|-- bin                                 # blast+ binaries and rpsbproc
|   |-- blast_formatter
|   |-- blastdb_aliastool
|   |-- blastdbcheck
|   |-- blastdbcmd
|   |-- blastn
|   |-- blastp
|   |-- blastx
|   |-- cleanup-blastdb-volumes.py
|   |-- convert2blastmask
|   |-- deltablast
|   |-- dustmasker
|   |-- get_species_taxids.sh
|   |-- legacy_blast.pl
|   |-- makeblastdb
|   |-- makembindex
|   |-- makeprofiledb
|   |-- psiblast
|   |-- rpsblast
|   |-- rpsbproc
|   |-- rpsbproc.ini
|   |-- rpstblastn
|   |-- segmasker
|   |-- tblastn
|   |-- tblastx
|   |-- update_blastdb.pl
|   `-- windowmasker
|-- data                                # meta data of CDD for rpsbproc
|   |-- bitscore_specific.txt
|   |-- cddannot.dat
|   |-- cddannot_generic.dat
|   |-- cddid.tbl
|   |-- cdtrack.txt
|   `-- family_superfamily_links
|-- db                                  # databse directory for docker run
|-- doc
|   `-- README.txt
|-- ncbi_package_info
|-- queries                             # query directory for docker run
`-- results                             # result directory for docker run
```


---
## Future Tasks
- [ ] usage example(s) in README.md
- [ ] automated test(s) for blast+ binaries and rpsbproc like [this](https://github.com/ncbi/docker/blob/master/blast/test.sh)
- [ ] add download options NCBI databases that are commonly used with blast+


---
## Authors
* Xiaotian Duan (Email: xduan7 at gmail.com)


---
## License
This project is licensed under the MIT License - check the [LICENSE](LICENSE.md) file for more details.
