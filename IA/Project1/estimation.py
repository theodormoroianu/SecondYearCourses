import state
from typing import Callable, List, Tuple

def TrivialEstimation(position: state.UserState) -> int:
    """
        Trivial estimation, always returns 0.
    """
    return 0

def DistanceToFinishEstimation(position: state.UserState) -> int:
    """
        Distance estimation, returns distance to starting point.
    """
    return sum([abs(state.start_position[i] - position.position[i]) for i in range(2)])

def DistanceToObstaclesEstimation(position: state.UserState) -> int:
    if position.has_stone:
        return DistanceToFinishEstimation(position)
    return sum([abs(state.start_position[i] - state.stone_position[i]) for i in range(2)]) +\
           sum([abs(position.position[i] - state.stone_position[i]) for i in range(2)])

def BadEstimation(position: state.UserState) -> int:
    return 20000 * state.N * state.M - DistanceToObstaclesEstimation(position) + \
        1000000 if position.position[0] == 0 else 0

estimations: List[Tuple[Callable,str]] = [
    (TrivialEstimation, "Trivial Estimation"),
    (DistanceToFinishEstimation, "Distance to end position"),
    (DistanceToObstaclesEstimation, "Distance to end passing by the stone"),
    (BadEstimation, "Bad estimation"),
]
