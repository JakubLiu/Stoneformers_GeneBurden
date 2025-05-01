#!/usr/bin/env nextflow

/*
tutorial link: https://www.youtube.com/watch?v=zJP7cUYPEbA&t=1s
In this code a second process in introduced
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

// this is  the new process
process convertToUpper {

    publishDir 'results/upper', mode: 'copy'  // a new publishdir (subdir of the results dir) is created

    input:
    path input_file // the meaning of this will be clear the the workflow{} block
    
    output:
    path "UPPER-${input_file}.txt"

    script:
    """
    cat $input_file | tr '[a-z]' '[A-Z]' > UPPER-${input_file}.txt
    """

}

 params.greeting = "greetings_file.csv"

workflow {

    /*
        Here we just pass the output of the sayHello() process (sayHello.out) as the input
        to the next process in the workflow.
    */
    greeting_ch = Channel.fromPath(params.greeting)
                                                  .splitCsv()
                                                  .map{row -> row[0]}
    sayHello(greeting_ch)

    convertToUpper(sayHello.out)
}
