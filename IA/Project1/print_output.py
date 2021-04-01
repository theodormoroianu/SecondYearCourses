from typing import List
import state
import os

def CreateDirectory(dir: str):
    """
        Creates an output directory if it doesn't already exist.
        @param dir: directory to create.
    """
    if os.path.exists(dir):
        return
    os.mkdir(dir)

def PrintSolutions(states: List[state.UserState], status: dict, file: str):
    """
        Prints a solution of a search algoritm to a file.
        @param states: list of final states.
        @param status: dictionary with search results.
        @param file: file to write into.
    """

    # Open the output file.
    # If the file can't be opened the error will propagate
    # to the main try/catch block.
    with open(file, "w") as fout:

        # Empty states -> Timeout / no solutions.
        if states == []:
            fout.write("No solutions were found!\n")
            fout.write("The file didn't admit a solution, or the search ended due to timeout.\n")
            return
        
        # Print the number of solutions.
        fout.write("Found %d solutions:\n" % len(states))

        # For each solution, print it in a different block.
        for id, final_state in enumerate(states):
            fout.write("Solution #%d:\n" % (id + 1))
            total_history = final_state.GetPath()

            # For each step of the solution display it.
            for step, i in enumerate(total_history):
                fout.write(" * Step #%d:\n" % step)
                fout.write("    * Actions:\n")
                for s in i.history:
                    fout.write("       * " + s + "\n")
                fout.write("    * State Summary:\n")
                fout.write("       * New position: (%d, %d)\n" % (i.position[0], i.position[1]))
                fout.write("       * Has the magic stone: %s\n" % str(i.has_stone))
                fout.write("       * Color and usage of wearing shoes: %c, used %d times\n" % (i.shoes[0], i.shoes[1]))
                fout.write("       * Has shoes in the backapck: %s\n" % str(i.backpack is not None))
                if (i.backpack is not None):
                    fout.write("       * Color and usage of backpack shoes: %c, used %d times\n" % (i.backpack[0], i.backpack[1]))
            
            # Display a search summary for the given path.
            fout.write(" * Search Summary:\n")
            fout.write("    * Search time: %f seconds\n" % round(status["TimeToSolutions"][id], 4))
            fout.write("    * Total distance of path: %d\n" % (len(total_history) - 1))
            fout.write("    * Visited nodes until the solution: %d\n" % status["VisitedNodes"][id])
            fout.write("    * Computed nodes until the solution: %d\n" % status["AllNodes"][id])
            fout.write("    * Algorithm used for computing the answer: %s\n" % status["UsedAlgorithm"])
            fout.write("\n")