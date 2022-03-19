#!/usr/bin/python3

#values
nContigs=304766
nARG=4
nMGE=50
nPAT=1367
nARG_MGE=0
nARG_MGE_PAT=0

result=[nContigs, nARG, nMGE, nPAT, nARG_MGE, nARG_MGE_PAT]
output=" ".join(map(str, result))

print(output + "\n" + "LL")

with open("./write_test.txt", "a") as f:
    f.write(output)

