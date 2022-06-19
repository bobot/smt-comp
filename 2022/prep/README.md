# Preparing the SMT-COMP spaces

## Generate a list of benchmarks and spaces

Download SMT-LIB repositories.  Make three subdirectories:

1. `non-incremental` where you checkout the repositories from
    https://clc-gitlab.cs.uiowa.edu:2443/SMT-LIB-benchmarks/
2. `incremental` where you checkout the repositories from
    https://clc-gitlab.cs.uiowa.edu:2443/SMT-LIB-benchmarks-inc/
3. checkout the repository
    https://clc-gitlab.cs.uiowa.edu:2443/SMT-LIB-benchmarks-tmp/pending-2022
   to `pending-2022`. This year, this repository seems to be empty, though.
   I worked around by filtering new benchmarks by family names,
   see `./find_new_benchmarks.sh`

You also need to checkout the scrambler repository in the same directory
as the smt-comp repository and build the scrambler with `make`.

Then run `./find_benchmarks.sh` on this directory. 

## Downloading the space XML files from starexec.

Go to the space for the current SMT-LIB release on Starexec.  For each
of the two subspaces choose `download space xml`.  Don't include benchmarks
attributes.  Extract the xml files from the downloaded zip file and put
them into this directory as `incremental.xml` and 
`non-incremental.xml`.

## Creating divisions.

To ensure the logics match those of SMT-LIB, we now create the division
files from the list of benchmarks.  The script `./create_divisions.sh`
does this.  You need to supply a regex for every division to match the
logics in this division.  The script will check that the logics are 
partitioned into the divisions and report any logic that is missing or
that was assigned to two divisions.