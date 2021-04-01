import read_input
import estimation
import pathfinding
import state
import print_output
from typing import Callable, Tuple, List

def process(alg: Callable, est: Callable, nr_sol: int, timeout: float, file: str):
    """
        Starts a search algoritm, with an aproximation and a timeout.
        @param alg: Algorithm function to use.
        @param est: Estimation function to use.
        @param nr_sol: Number of solutions to generate.
        @param timeout: timeout in seconds for the algorithm.
        @param file: File to write the solution into.
    """

    # Run algoritm.
    results = alg(est, nr_sol, timeout)

    # Print results into the output file.
    print_output.PrintSolutions(results[0], results[1], file)

    # Display to the cli that the file was succesfully saved.
    print("Saved results in file \"%s\"!\n" % file)

def main():
    """
        Entry point of the program.
    """

    # Folder to load samples from.
    folder = input("In which folder are the input files?\n $ ")
    try:
        files_in_folder = read_input.ReadFolder(folder)
    except:
        print("The folder specified was not found. Stopping...")
        return

    # Folder to save files to.
    output_folder = input("In which folder should we save the output files?\n $ ")
    try:
        print_output.CreateDirectory(output_folder)
    except:
        print("Unable to create output folder. Stopping...")
        return

    # Read number of solutions.
    nr_solutions = int(input("How many paths should the algorithm compute (Note that A*/BFS/IDA* only compute the first one)?\n $ "))
    if nr_solutions <= 0:
        raise IOError("Invalid number of solutions")
    
    # Read choosen estimation.
    print("Available estimations:")
    for id, (_, description) in enumerate(estimation.estimations):
        print("  %d. %s" % (id + 1, description))
    estimation_id = int(input("Which estimation should the algoritm consider?\n $ "))
    estimation_fn = estimation.estimations[estimation_id - 1][0]


    # Read choosen algorithm.
    print("Available search algoritms:")
    for id, (_, description) in enumerate(pathfinding.pathfindings):
        print("  %d. %s" % (id + 1, description))
    search_alg_id = int(input("Which searching algorithm should we use?\n $ "))
    search_alg_fn = pathfinding.pathfindings[search_alg_id - 1][0]


    # Read choosen timeout.
    timeout = float(input("What timeout should the algoritm have (in seconds)?\n $ "))



    # Iterate over each input file.
    for file in files_in_folder:

        # If something goes wrong during the evaluation of the file
        # then this try block will catch it.
        try:

            # Read data from the file.
            print("Proccessing input from file \"%s\" ... " % file, end='')
            try:
                read_input.ReadFile(folder + "/" + file)
            except:
                print("Input file is corrupted (the data is not valid)! Skipping test...")
                continue

            # Display a brief overview of the file.
            print("Successfully loaded sample.")
            print("Usable space has a dimension of %dx%d, start position is at (%d, %d) and stone at (%d, %d)." %
                    (state.N, state.M, state.start_position[0], state.start_position[1],
                     state.stone_position[0], state.stone_position[1]))
            
            
            # Process file.
            process(search_alg_fn, estimation_fn, nr_solutions, timeout, output_folder + "/" + file)

        # Something went wrong.
        # Just blame the user and keep going.
        except Exception as exp:
            print(exp.args)
            print(("Something went wrong while processing input from file \"%s\"." +
                    "Please check if the file is valid and try again. Skipping test...") % file)

if __name__ == "__main__":
    main()