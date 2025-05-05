#!/usr/bin/env nextflow

/*
tutorial link: https://www.youtube.com/watch?v=zJP7cUYPEbA&t=1s
In this code a process that takes on multiple input files and outputs
one single file is introduced.
*/

process sayHello {

    publishDir 'results', mode: 'copy'

    input:
    val greeting
    
    output:
    path "$greeting-output.txt"

    script:
    """
    echo '$greeting' > $greeting-output.txt
    """

}


process convertToUpper {

    publishDir 'results/upper', mode: 'copy'

    input:
    path input_file
    
    output:
    path "UPPER-${input_file}.txt"

    script:
    """
    cat $input_file | tr '[a-z]' '[A-Z]' > UPPER-${input_file}.txt
    """

}


// this process takes as input multiple files and outputs a single one
process collectGreetings{

    publishDir 'results/collected_greetings', mode: 'copy'

    input:
    path multiple_input_files   // this process will take multiple input files
    
    output:
    path "COLLECTED-greetings.txt"

    script:
    """
    cat $multiple_input_files > "COLLECTED-greetings.txt"
    """

}

 params.greeting = "greetings_file.csv"

workflow {

    /*
        Notice the .collect() operator, this is needed if we want to get a single
        output from multiple inputs.
    */
    greeting_ch = Channel.fromPath(params.greeting)
                                                  .splitCsv()
                                                  .map{row -> row[0]}
    sayHello(greeting_ch)

    convertToUpper(sayHello.out)

    collectGreetings(convertToUpper.out.collect())
}
