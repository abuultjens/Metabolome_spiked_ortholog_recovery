# Metabolome_spiked_ortholog_recovery

# Author
Andrew Buultjens

# Synopsis
Metabolome_spiked_ortholog_recovery - generating results for an ARC grant

1. generate simulated data (this uses Torsten's mockery.pl script)
```
% sh data-simulator.sh SPIKE_LIST.txt
```

# 2. run the SVC
```
% python2.7 0.05_SVC_RUNNER.py
```

# 3. run the SVC
```
% python2.7 0.05_SVC_RUNNER.py
```

# 4. report the rankings of the 20 spiked orthologs
```
% sh RANK-REPORTER.sh 0.05
```



