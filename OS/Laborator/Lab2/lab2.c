/**
 * Author: Moroianu Theodor (234)
 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// Prints message to stdout.
// If an error occurs, it tries to write a warning
// to stderr, and returns the error status.
int WriteMessage(char* message)
{
    // Length of the message to be printed.
    int len = strlen(message);
    // Nr of printed characters.
    int written = 0, d;
    
    // Still need to print some stuff.
    while ((d = write(1, message + written, len - written)) > 0) {
        written += d;
    }
    if (d < 0) {
        int error_id = errno;
        // Print error to stderr.
        char error[] = "An error occured while printing to stdout!\n";
        write(2, error, strlen(error));
        return error_id;
    }
    return 0;
}

// Copies on file to another.
// If an error occurs, it prints a warning to stdout
// and returns the status message.
int CopyFile(char* from, char* to)
{
    // Open input file, in read-only mode.
    int file_to_read = open(from, O_RDONLY);
    if (file_to_read == -1) {
        int error = errno;
        WriteMessage("Unable to open input file!\n");
        return errno;
    }

    // Create and open write file, in R/W mode.
    // The file is allowed to execute, used to instance for
    // copying executables.
    int file_to_write = open(to, O_WRONLY | O_CREAT, S_IRWXU);
    if (file_to_write == -1) {
        int error = errno;
        WriteMessage("Unable to open input file!\n");
        return errno;
    }

    // Buffer for read/write.
    const int DMAX = 1024;
    char buffer[DMAX];

    int d;
    while ((d = read(file_to_read, buffer, DMAX)) > 0) {
        int written = 0, act;
        while ((act = write(file_to_write, buffer + written, d - written)) > 0)
            written += act;
        // Error while writing stuff to output file.
        if (act == -1) {
            int error = errno;
            WriteMessage("Unable to write in output file!\n");
            return error;
        }
    }
    // Error while reading stuff from input file.
    if (d == -1) {
        int error = errno;
        WriteMessage("Unable to read from input file!\n");
        return error;
    }
}

int PrintError(char* message, int err_number)
{
    // If we try to catch exceptions here it becomes an infinite
    // loop (this function displays errors), so we won't try to
    // detect any error codes.
    write(2, message, strlen(message));
    
    char error_code[1000];
    int l = 0;
    while (err_number) {
        error_code[l++] = err_number % 10 + '0';
        err_number /= 10;
    }

    write(2, "Error code: ", strlen("Error code: "));
    
    while (l > 0) {
        l--;
        write(2, error_code + l, 1);
    }
    
    write(2, "\n\n", 2);
}

int main(int argc, char* arg[])
{
    // Cerinta 1: Afiseaza Hello World.
    // Daca intervine o eroare, afiseaza la stdout ca a aparut o problema,
    // si err_hello_world contine id-ul acelei erori.
    int err_hello_world = WriteMessage("Hello World!\n");
    if (err_hello_world)
        PrintError("Error while printing Hello World!\n", err_hello_world);   
    

    // Cerinta 2: Copiaza doua fisiere.
    // Se presupune ca utilizatorul isi asuma ca poate
    // sa suprascrie alte fisiere.
    int err_copy_file;
    // Fisierele sunt pasate ca parametrii.
    if (argc == 3)
        err_copy_file = CopyFile(arg[1], arg[2]);
    else {
        // Trebuie sa citim cele doua fisiere.
        const int DMAX = 1000;
        char input_file[DMAX];
        char output_file[DMAX];
        memset(input_file, 0, sizeof(input_file));
        memset(input_file, 0, sizeof(output_file));

        WriteMessage("Input File: ");
        read(0, input_file, DMAX);
        WriteMessage("Output File: ");
        read(0, output_file, DMAX);
        
        // Remove '\n' from end of strings
        input_file[strlen(input_file) - 1] = output_file[strlen(output_file) - 1] = 0;

        err_copy_file = CopyFile(input_file, output_file);
    }
    if (err_copy_file)
        PrintError("Error while copying files!\n", err_copy_file);

    return 0;
}
