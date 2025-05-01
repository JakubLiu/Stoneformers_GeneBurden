#!/usr/bin/env nextflow

/*
tutorial link: https://www.youtube.com/watch?v=lJ41WMMm44M&list=PLPZ8WHdZGxmXiHf8B26oB_fTfoKQdhlik&index=3
In this code the simplest channel (Channel.of) is introduced.
*/
process sayHello {

    publishDir 'results', mode: 'copy'

    input:
    val greeting
    
    output:
    path "$greeting-output.txt"  // here we need double brackets "" to enable variable expansion

    script:
    """
    echo '$greeting' > $greeting-output.txt
    """

}

 params.greeting = "Hello"

workflow {

    /*
    By using a channel we can pass not just a single value to a process, but an array of values.
    This process will then get run for all the elements in the array.
    The array needs to get flattened to be interpreted as an array and not a a literal string '[]'.
    We need to modigy the proces{} itself so that each element in the array produces an output file
    with a different name, so nothig gets overwritten (look at the process above at how this is done).
    */
    greetings_array = ["Dzień_dobry", "Guten_Tag", "Dla_kogo_dobry_dla_tego_dobry"]
    greeting_ch = Channel.of(greetings_array).flatten()
    sayHello(greeting_ch)
}

/*

# run with the default greeting parameter

    nextflow run part1_hello-world.nf

# run with a specific greeting parameter

    nextflow run part1_hello-world.nf --greeting "Siemano"

*/