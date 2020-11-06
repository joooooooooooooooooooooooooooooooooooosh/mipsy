#!/bin/zsh

EXCEPTIONS_FILE="/home/zac/uni/teach/comp1521/20T2/work/spim-simulator/CPU/exceptions.s";

for test_file in test_files/*; do
    printf "Checking $test_file... ";

    if `echo $test_file | grep -q 'broken'`;
    then
        echo 'Skipping broken file';
        continue;
    fi

    rspim_out=`echo "Loaded: $EXCEPTIONS_FILE" && 
              yes 3 | ./target/debug/rspim "$test_file" 2>&1`;
    spim_out=`yes 3 | spim -f "$test_file" 2>&1`;

    if diff <(echo "$rspim_out") <(echo "$spim_out") >/dev/null;
    then
        echo "passed!"
    else
        echo "FAILED";
        echo "    rspim_output: `echo $rspim_out   | sed -E "s/Loaded: .+//"`";
        echo "\n    spim_output:  `echo $spim_out  | sed -E "s/Loaded: .+//"`";
        echo '';
    fi
done
