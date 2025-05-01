#!/usr/bin/env nextflow

/*
tutorial link: https://www.youtube.com/watch?v=lJ41WMMm44M&list=PLPZ8WHdZGxmXiHf8B26oB_fTfoKQdhlik&index=3
In this code a channel which can read data from a file is introduced (Channel.fromPath)
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

 params.greeting = "greetings_file.csv"

workflow {

    /*
        - Here we use the Channel.fromPath() where we can pass the contents of a file to our process.
        - params.greeting is set to the relative path of the file.
        - Our file is a 2D csv file, thereofre we need to use .splitCsv()
        - .splitCsv() converts each row into a 1D array
        - we are interested only in the 1st element of each row
        - therefore we use the .map{} operator which applies an operation to each element of the iterable
        - here our iterable is a row and for each row we take its 1st element
    */
    greeting_ch = Channel.fromPath(params.greeting)
                                                  .splitCsv()
                                                  .map{row -> row[0]}
    sayHello(greeting_ch)
}
