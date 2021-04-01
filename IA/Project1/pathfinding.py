from collections import OrderedDict, defaultdict
from typing import Callable, List, Tuple, final
import state
import time

def OptimizedAStar(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.UserState], dict]:
    """
        A* Algoritm using open and closed lists.
        Only returns the first path found.
        @param estimation: estimation function.
        @timeout: timeout in seconds.
        @return: list of final states and a dictionary storing the additional informations.
    """
    opened = [state.UserState(
            state.start_position,
            None,
            0,
            (state.map_colors[state.start_position[0]][state.start_position[1]], 1),
            None,
            False,
            ["Added start position to A*"]
    )]
    closed: List[state.UserState] = []

    time_start = time.time()
    
    def ElapsedTime() -> float:
        return time.time() - time_start

    def IsInClosed(userstate: state.UserState) -> bool:
        for el in closed:
            if el.EncodeState() == userstate.EncodeState():
                return True
        return False

    def EstimateTotalDistance(userstate: state.UserState) -> int:
        return userstate.distance + estimation(userstate)
    
    def FindAndUpdateInOpen(userstate: state.UserState) -> bool:
        for i in range(len(opened)):
            if opened[i].EncodeState() == userstate.EncodeState():
                if opened[i].distance > userstate.distance:
                    opened[i] = userstate
                return True
        return False

    while opened != []:
        if ElapsedTime() > timeout:
            return [], {
                    "TimeToSolutions": [],
                    "VisitedNodes": [len(closed)],
                    "AllNodes": [len(opened) + len(closed)],
                    "UsedAlgorithm": "Optimized A*"
                }

        opened.sort(key=EstimateTotalDistance)

        userstate = opened[0]
        opened.pop(0)
        closed.append(userstate)

        for urm in userstate.GenerateSuccessors():
            if urm.IsFinalNode():
                return [urm], {
                    "TimeToSolutions": [ElapsedTime()],
                    "VisitedNodes": [len(closed)],
                    "AllNodes": [len(opened) + len(closed)],
                    "UsedAlgorithm": "Optimized A*"
                }
            if IsInClosed(urm):
                continue
            if not FindAndUpdateInOpen(urm):
                opened.append(urm)
        
    return [], { }

def UCS(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.UserState], dict]:
    """
        UCS Algoritm.
        @param estimation: estimation function.
        @timeout: timeout in seconds.
        @return: list of final states and a dictionary storing the additional informations.
    """
    states = [state.UserState(
            state.start_position,
            None,
            0,
            (state.map_colors[state.start_position[0]][state.start_position[1]], 1),
            None,
            False,
            ["Added start position to UCS"]
    )]

    time_start = time.time()
    
    def ElapsedTime() -> float:
        return time.time() - time_start

    ans = []
    infos =  {
        "TimeToSolutions": [],
        "VisitedNodes": [],
        "AllNodes": [],
        "UsedAlgorithm": "UCS"
    }

    visited_nodes = 0

    while states != [] and len(ans) < nr_solutions:
        if ElapsedTime() > timeout:
            break

        # no need to sort, distance increases by 1
        # states.sort(key=EstimateTotalDistance)

        userstate = states[0]
        states.pop(0)
        visited_nodes += 1

        for urm in userstate.GenerateSuccessors():
            if urm.IsFinalNode():
                ans.append(urm)
                infos["TimeToSolutions"].append(ElapsedTime())
                infos["VisitedNodes"].append(visited_nodes)
                infos["AllNodes"].append(visited_nodes + len(states))

            if not userstate.IsInPath(urm):
                states.append(urm)

    return ans, infos


def SlowAStar(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.UserState], dict]:
    """
        Slow A* Algoritm.
        @param estimation: estimation function.
        @timeout: timeout in seconds.
        @return: list of final states and a dictionary storing the additional informations.
    """
    states = [state.UserState(
            state.start_position,
            None,
            0,
            (state.map_colors[state.start_position[0]][state.start_position[1]], 1),
            None,
            False,
            ["Added start position to slow A*"]
    )]

    time_start = time.time()
    
    def ElapsedTime() -> float:
        return time.time() - time_start

    def EstimateTotalDistance(userstate: state.UserState) -> int:
        return userstate.distance + estimation(userstate)

    ans = []
    infos =  {
        "TimeToSolutions": [],
        "VisitedNodes": [],
        "AllNodes": [],
        "UsedAlgorithm": "Slow A*"
    }

    visited_nodes = 0

    while states != [] and len(ans) < nr_solutions:
        if ElapsedTime() > timeout:
            break

        states.sort(key=EstimateTotalDistance)

        userstate = states[0]
        states.pop(0)
        visited_nodes += 1

        for urm in userstate.GenerateSuccessors():
            if urm.IsFinalNode():
                ans.append(urm)
                infos["TimeToSolutions"].append(ElapsedTime())
                infos["VisitedNodes"].append(visited_nodes)
                infos["AllNodes"].append(visited_nodes + len(states))

            if not userstate.IsInPath(urm):
                states.append(urm)
    
    return ans, infos
    

def IDAStar(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.UserState], dict]:
    """
        IDA* Algoritm.
        @param estimation: estimation function.
        @timeout: timeout in seconds.
        @return: list of final states and a dictionary storing the additional informations.
    """

    start_node = state.UserState(
        state.start_position,
        None,
        0,
        (state.map_colors[state.start_position[0]][state.start_position[1]], 1),
        None,
        False,
        ["Added start position to slow A*"]
    )

    time_start = time.time()
    
    def ElapsedTime() -> float:
        return time.time() - time_start

    def EstimateTotalDistance(userstate: state.UserState) -> int:
        return userstate.distance + estimation(userstate)


    visited_nodes = 0
    total_nodes = 0

    def SearchForPath(node: state.UserState, max_distance: int):
        nonlocal visited_nodes, total_nodes, ElapsedTime, timeout

        if ElapsedTime() > timeout:
            return None, float("inf")

        visited_nodes += 1

        if EstimateTotalDistance(node) > max_distance:
            return None, EstimateTotalDistance(node)
        
        if node.IsFinalNode():
            return node, node.distance
            
        min_cost = float('inf')

        for urm in node.GenerateSuccessors():
            total_nodes += 1
            if node.IsInPath(urm):
                continue
            
            final_node, best_est = SearchForPath(urm, max_distance)

            if final_node is not None:
                return final_node, best_est

            min_cost = min(min_cost, best_est)
        
        return None, min_cost

    ans = []
    infos =  {
        "TimeToSolutions": [],
        "VisitedNodes": [],
        "AllNodes": [],
        "UsedAlgorithm": "Slow A*"
    }

    visited_nodes = 0
    current_estimation = 0

    while True:
        if ElapsedTime() > timeout:
            break
        
        final_node, current_estimation = SearchForPath(start_node, current_estimation)
        total_nodes += 1

        if final_node is not None:
            infos["TimeToSolutions"].append(ElapsedTime())
            infos["VisitedNodes"].append(visited_nodes)
            infos["AllNodes"].append(total_nodes)
            ans.append(final_node)
            break

    return ans, infos


def BFS(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.UserState], dict]:
    """
        BFS algoritm for finding the destination.
        Only returns the first occurence.
        @param estimation: estimation function.
        @timeout: timeout in seconds.
        @return: list of final states and a dictionary storing the additional informations.
    """
    queue = [state.UserState(
            state.start_position,
            None,
            0,
            (state.map_colors[state.start_position[0]][state.start_position[1]], 1),
            None,
            False,
            ["Added start position to BFS"]
    )]

    visited = OrderedDict()
    visited[queue[0].EncodeState()] = True

    time_start = time.time()
    
    def ElapsedTime() -> float:
        return time.time() - time_start

    ans = []
    infos =  {
        "TimeToSolutions": [],
        "VisitedNodes": [],
        "AllNodes": [],
        "UsedAlgorithm": "BFS"

    }

    visited_nodes = 0

    while queue != []:
        if ElapsedTime() > timeout:
            return ans, infos

        userstate = queue[0]
        queue.pop(0)
        visited_nodes += 1

        for urm in userstate.GenerateSuccessors():
            if urm.IsFinalNode():
                ans.append(urm)
                infos["TimeToSolutions"].append(ElapsedTime())
                infos["VisitedNodes"].append(visited_nodes)
                infos["AllNodes"].append(visited_nodes + len(queue))
                return ans, infos

            if urm.EncodeState() not in visited:
                queue.append(urm)
                visited[urm.EncodeState()] = True
    
    return ans, infos
    



pathfindings: List[Tuple[Callable, str]] = [
    (OptimizedAStar, "Optimized A*"),
    (SlowAStar, "Normal A*"),
    (UCS, "UCS"),
    (BFS, "BFS"),
    (IDAStar, "IDA*"),
]