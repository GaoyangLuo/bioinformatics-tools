set -e
true
true
/home/jinsong/software/SPAdes-3.15.3-Linux/bin/spades-hammer /home/zhangpeijun/lize/spades_assembly/output/corrected/configs/config.info
/usr/bin/python /home/jinsong/software/SPAdes-3.15.3-Linux/share/spades/spades_pipeline/scripts/compress_all.py --input_file /home/zhangpeijun/lize/spades_assembly/output/corrected/corrected.yaml --ext_python_modules_home /home/jinsong/software/SPAdes-3.15.3-Linux/share/spades --max_threads 16 --output_dir /home/zhangpeijun/lize/spades_assembly/output/corrected --gzip_output
true
true
/home/jinsong/software/SPAdes-3.15.3-Linux/bin/spades-core /home/zhangpeijun/lize/spades_assembly/output/K21/configs/config.info
/home/jinsong/software/SPAdes-3.15.3-Linux/bin/spades-core /home/zhangpeijun/lize/spades_assembly/output/K33/configs/config.info
/home/jinsong/software/SPAdes-3.15.3-Linux/bin/spades-core /home/zhangpeijun/lize/spades_assembly/output/K55/configs/config.info
/home/jinsong/software/SPAdes-3.15.3-Linux/bin/spades-core /home/zhangpeijun/lize/spades_assembly/output/K77/configs/config.info
/usr/bin/python /home/jinsong/software/SPAdes-3.15.3-Linux/share/spades/spades_pipeline/scripts/copy_files.py /home/zhangpeijun/lize/spades_assembly/output/K77/before_rr.fasta /home/zhangpeijun/lize/spades_assembly/output/before_rr.fasta /home/zhangpeijun/lize/spades_assembly/output/K77/assembly_graph_after_simplification.gfa /home/zhangpeijun/lize/spades_assembly/output/assembly_graph_after_simplification.gfa /home/zhangpeijun/lize/spades_assembly/output/K77/final_contigs.fasta /home/zhangpeijun/lize/spades_assembly/output/contigs.fasta /home/zhangpeijun/lize/spades_assembly/output/K77/first_pe_contigs.fasta /home/zhangpeijun/lize/spades_assembly/output/first_pe_contigs.fasta /home/zhangpeijun/lize/spades_assembly/output/K77/strain_graph.gfa /home/zhangpeijun/lize/spades_assembly/output/strain_graph.gfa /home/zhangpeijun/lize/spades_assembly/output/K77/scaffolds.fasta /home/zhangpeijun/lize/spades_assembly/output/scaffolds.fasta /home/zhangpeijun/lize/spades_assembly/output/K77/scaffolds.paths /home/zhangpeijun/lize/spades_assembly/output/scaffolds.paths /home/zhangpeijun/lize/spades_assembly/output/K77/assembly_graph_with_scaffolds.gfa /home/zhangpeijun/lize/spades_assembly/output/assembly_graph_with_scaffolds.gfa /home/zhangpeijun/lize/spades_assembly/output/K77/assembly_graph.fastg /home/zhangpeijun/lize/spades_assembly/output/assembly_graph.fastg /home/zhangpeijun/lize/spades_assembly/output/K77/final_contigs.paths /home/zhangpeijun/lize/spades_assembly/output/contigs.paths
true
/usr/bin/python /home/jinsong/software/SPAdes-3.15.3-Linux/share/spades/spades_pipeline/scripts/breaking_scaffolds_script.py --result_scaffolds_filename /home/zhangpeijun/lize/spades_assembly/output/scaffolds.fasta --misc_dir /home/zhangpeijun/lize/spades_assembly/output/misc --threshold_for_breaking_scaffolds 3
true
