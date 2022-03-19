#!/usr/bin/env python

# #####################################################################################
#
# This script converts the five common *.fastq files or *.fasta/*.qual 
# combined with base quality file(only Pred score supported) to standard 
# Sanger/Illumina 1.8+ format.
# 
# #####################################################################################

import random
import sys
import gzip
import re 
import os
import string
from optparse import OptionParser

#=============== mode1: fq to standard fastq format ==============#



def countLines(fh):
    """ count the lines of large files very quickly """
    count = 0
    while 1:
        temp = fh.read(8192*1024) # read 8192*1024 chars per one time, if less then get the rest of it
        if not temp: break
        count += temp.count('\n')
    return count 

def writeRandomRecords(fq, outDir, N=10000):
    """ get N random headers from a fastq file without reading the
    whole thing into memory"""

    pattern = re.compile(r'\.gz$')
    if pattern.findall(fq):
        fh = gzip.open(fq)
    else:
        fh = open(fq)
    count = countLines(fh)
    records = count / 4 
    print >>sys.stderr, "The input file contains " + str(records) + " sequences."
    fh.close()
    #print count, records

    rand_records = sorted(random.sample(range(0, min(N,records)),min(N,records))) #get unreplicated random int 
    if pattern.findall(fq):
        fh = gzip.open(fq, 'r')
    else:
        fh = open(fq, 'r')

    sub = open(outDir + "/" + os.path.basename(fq) + ".subset10Kreads", "w")
    flag = 0
    for rr in rand_records:
        #print >>sys.stderr, rr 
        while flag < rr:
            flag += 1       
            for i in range(4): fh.readline() #skip these records 
        for i in range(3): fh.readline()
        sub.write(fh.readline()) # only write the rr base quality line
        flag += 1 # one record written, addself
    ## print >>sys.stderr, "wrote to %s" % (sub.name)
    fh.close()
    sub.close()



def detectFormat(fq, outDir):
    fqSub = open(outDir + "/" + os.path.basename(fq) + ".subset10Kreads", "r").read()
    fqFormat = ''
    if fqSub.find('`') + 1:
        if fqSub.find('@') + 1:
            if fqSub.find(';' and '<' and '=' and '>' and '?') + 1:
                fqFormat = 'Solexa'
                print >>sys.stderr, "The input file is in format version Solexa"
            else:
                fqFormat = 'Illumina 1.3+'
                print >>sys.stderr, "The input file is in format version Illumina 1.3+"
        else:
            fqFormat = 'Illumina 1.5+'
            print >>sys.stderr, "The input file is in format version Illumina 1.5+"
    else:
        if fqSub.find('J') + 1:
            fqFormat = 'Illumina 1.8+'
            print >>sys.stderr, "The input file is in format version Illumina 1.8+"
        else:
            fqFormat = 'Sanger'
            print >>sys.stderr, "The input file is in format version Sanger"
    return fqFormat


def writeFASTQstd(fq, outDir, fqFormat, ifGzip='Y'):
    pattern = re.compile(r'\.gz$')
    if pattern.findall(fq):
        fh = gzip.open(fq, 'r')
    else:
        fh = open(fq, 'r')

    #determine the output file should be compressed or not 
    if(ifGzip == 'Y'):
        fqStdName = outDir + '/' + re.sub('.fastq|.fq|.gz', '',os.path.basename(fq)) + '.std.fastq.gz'
        fqStd = gzip.open(fqStdName, 'w')
    elif(ifGzip == 'N'):
        fqStdName = outDir + '/' + re.sub('.fastq|.fq|.gz', '',os.path.basename(fq)) + '.std.fastq'
        fqStd = open(fqStdName, 'w')
    else:
        print >>sys.stderr, "Output Argument Error: Please check if the output \
                file needs to be compressed..."
        sys.exit(1)

    #convert fq format to standard fq 
    if fqFormat == 'Illumina 1.8+' or fqFormat == 'Sanger':
        print >>sys.stderr, "No convert needed."
        os.system("rm %s" %(fqStdName))
        #sys.exit(1)
    elif fqFormat == 'Illumina 1.3+' or fqFormat == 'Illumina 1.5+':   
        patternQual = string.maketrans(r"@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghi", \
                r"!" + r'"' + r"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ")
        flag = 0 
        for line in fh:
            flag += 1
            if flag % 4 == 3:
                fqStd.write("+\n")
            elif flag % 4 == 0:
                fqStd.write(line.translate(patternQual))
            else:
                fqStd.write(line)
        print >>sys.stderr, "Format converted to version Sanger/Illumina 1.8+ sucessfully."
    elif fqFormat == 'Solexa':   
        patternQual = string.maketrans(r";<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghi", \
                r"!!!!!!" + r'"' + r"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ")
        flag = 0 
        for line in fh:
            flag += 1
            if flag % 4 == 3:
                fqStd.write("+\n")
            elif flag % 4 == 0:
                fqStd.write(line.translate(patternQual))
            else:
                fqStd.write(line)
        print >>sys.stderr, "Format converted to version Sanger/Illumina 1.8+ sucessfully."
    else:
        print >>sys.stderr, fqFormat + "Error: format not identified, please recheck..."
        sys.exit(1)
    fh.close()
    fqStd.close()

def fq2stdFASTQ(fq, ifGzip, outDir):
    writeRandomRecords(fq, outDir, N=10000)
    fqFormat = detectFormat(fq, outDir)
    writeFASTQstd(fq, outDir, fqFormat, ifGzip)

    fqSub = outDir + "/" + os.path.basename(fq) + ".subset10Kreads"
    os.system("rm %s" %(fqSub)) # remove the subset fq file 
    

#============= mode2: fasta & qual files to standard fastq format ===========#

def readFile(infile):
    pattern = re.compile(r'\.gz$')
    if pattern.findall(infile):
        fr = gzip.open(infile, 'r')
    else:
        fr = open(infile, 'r')
    return fr 

def writeFile(infile, ifGzip, outDir):
    outfile = outDir + '/' + re.sub('.fasta|.fa|.gz', '',os.path.basename(infile)) + '.std.fastq'
    if ifGzip == 'Y':
        fw = gzip.open(outfile + '.gz', 'w')
    else:
        fw = open(outfile, 'w')
    return fw 

def faQual2stdFASTQ(fa, qual, ifGzip='Y', outDir='./'):
    frFa = readFile(fa); frQual = readFile(qual)
    fw = writeFile(fa, ifGzip, outDir)
    faHead = ''
    faSeq = []; qualSeq = [] 
    faFlag = 0; qualFlag = 0
    subHead = string.maketrans('>\t _', '@:::')

    for faLine in frFa: # fa loop 
        if faLine.startswith('>'):
            if faFlag: 
                fw.writelines([faHead, ''.join(faSeq), '\n+\n'])
                faSeq = []
                for qualLine in frQual: #qual loop
                    if qualLine.startswith('>'):
                        if qualFlag: 
                            fw.writelines([''.join(qualSeq),'\n'])
                            qualSeq = []
                            break 
                        continue
                    else:
                        qualFlag = 1 
                        tempList = qualLine.strip('\n').split()
                        qualSeq.extend([chr(int(x) + 33) for x in tempList])
            
            faHead = faLine.translate(subHead)
        else:
            faFlag = 1
            faSeq.append(faLine.strip('\n'))
    if not frFa.readline(): # add the last record specifically
        fw.writelines([faHead, ''.join(faSeq), '\n+\n']) # add the last fa record
        for qualLine in frQual:
            tempList = qualLine.strip('\n').split()
            qualSeq.extend([chr(int(x) + 33) for x in tempList])
        fw.writelines([''.join(qualSeq),'\n']) # add the last qual record 
	print >>sys.stderr, "Format converted to version Sanger/Illumina 1.8+ sucessfully."
    frFa.close(); frQual.close(); fw.close()


#============================= main part ===============================#

def main():
    usage = "usage: python %prog [options] \n" + \
"""
Example: python %prog -s input.fastq -c Y -o ./ 
         python %prog -f input.fasta -q input.qual -c N -o ./ 
        
Author:     Xiao Luo // luoxiao@genomics.cn
Version:    1.1
Date:       2015-08-30
"""

    parser = OptionParser(usage)
    parser.add_option("-s", "--fastq", dest="fastq", action="store",
            help="from fastq to standard fastq format (Illumina 1.8+)")
    parser.add_option("-f", "--fasta", dest="fasta", action="store",
            help="from fasta and quality info to standard fastq format (Illumina 1.8+)")
    parser.add_option("-q", "--quality", dest="quality", action="store",
            help="used with -f at the same time, only support Phred score")
    parser.add_option("-c", "--compress", dest="compress", action="store",
            help="output file should be compressed or not, default Y")
    parser.add_option("-o", "--outDirectory", dest="outDir", action="store",
            help="assign the output directory, default ./")
    (options, args) = parser.parse_args()
    
    #select one mode: fastq / (fasta + qual)
    if(options.fastq):
        (fq, ifGzip, outDir) = (options.fastq, options.compress, options.outDir)
        if(not ifGzip): ifGzip = 'Y'
        if(not outDir): outDir = './'
        fq2stdFASTQ(fq, ifGzip, outDir)
    elif(options.fasta):
        (fa, qual, ifGzip, outDir) = (options.fasta, options.quality, options.compress, options.outDir)
        if(not ifGzip): ifGzip = 'Y'
        if(not outDir): outDir = './'
        faQual2stdFASTQ(fa, qual, ifGzip, outDir)
    else:
        parser.error("Error: fastq/fasta input file should be assigned...")
        sys.exit(1)

    print >>sys.stderr, "Finished."


if __name__ == "__main__":
    main()

