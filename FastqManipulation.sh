#replace all C with T in read line of fastq file
zcat input.fastq.gz | awk '/^@/{print; getline; gsub("C", "T"); print; getline; print; getline; print}' | gzip > modified_file.fastq.gz
