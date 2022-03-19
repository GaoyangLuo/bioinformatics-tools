import sys
f1 = sys.argv[1]
f2 = sys.argv[2]
num = 0
with open(f1) as fn1:
    with open(f2, 'wt') as fn2:
        for line in fn1:
            if line[0] == ">":
                lst = ">" + f1.split('.')[0]+'_'+str(num)
                num = num +1
                fn2.write(lst +"\n")
            else:
                fn2.write(line.strip()+"\n")
