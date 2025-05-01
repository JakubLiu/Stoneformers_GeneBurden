#!/usr/bin/env nextflow

// tutorial link: https://www.youtube.com/watch?v=lJ41WMMm44M&list=PLPZ8WHdZGxmXiHf8B26oB_fTfoKQdhlik&index=3

process sayHello {

    publishDir 'results', mode: 'copy'  // create a results directory and copy all the contents from the work directory into it

    input:
    val greeting   // this will be the parameter (flag) we will run this pipeline with
    

    output:
    path 'output.txt'

    script:
    """
    echo '$greeting' > output.txt
    """

}

 params.greeting = "Hello" // set the default value for the greeting parameter

workflow {

    sayHello(params.greeting) // run the process with the given parameter
}

/*

# run with the default greeting parameter

    nextflow run part1_hello-world.nf

# run with a specific greeting parameter

    nextflow run part1_hello-world.nf --greeting "Siemano"

*/