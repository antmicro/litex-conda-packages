#!/bin/bash

source .travis/common.sh
set -e

# Close the after_success fold travis has created already.
travis_fold end after_success

if [[ $UPLOAD == "no-upload" ]]; then
    echo "Job without upload..."
elif [[ $UPLOAD == "storage" ]]; then
    echo "Job with storage upload..."
    git clone $STORAGE_URL storage
    cd storage
    rm $OS_PACKAGE*
    cp $CONDA_OUT $FULL_PACKAGE_NAME
    git add .
    git commit -m "Travis: Savepoint $FULL_PACKAGE_NAME"
    # TODO: change credentials!!!
    git push -f https://kowalewskijan:$STORAGE_TOKEN@github.com/antmicro/travis-temp-storage.git
else
    echo "Job with Conda upload..."

    start_section "package.contents" "${GREEN}Package contents...${NC}"
    tar -jtf $CONDA_OUT | sort
    end_section "package.contents"

    $SPACER

    start_section "package.upload" "${GREEN}Package uploading...${NC}"
    anaconda -t $ANACONDA_TOKEN upload --user $ANACONDA_USER --label main $CONDA_OUT
    end_section "package.upload"

    $SPACER
fi

start_section "success.tail" "${GREEN}Success output...${NC}"
echo "Log is $(wc -l /tmp/output.log) lines long."
echo "Displaying last 1000 lines"
echo
tail -n 1000 /tmp/output.log
end_section "success.tail"
