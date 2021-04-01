from typing import Tuple, List, Union, Optional

map_colors: List[List[str]] = None
map_bonus: List[List[str]] = None
start_position = None
stone_position = None
N, M = None, None

def Initialize(colors: List[List[str]], bonuses: List[List[str]]):
    global map_colors, map_bonus, start_position, N, M, stone_position
    N = len(colors)
    M = len(colors[0])

    map_colors = colors
    map_bonus = bonuses

    start_position = None
    stone_position = None
    
    for i in range(N):
        if len(map_colors[i]) != M or len(map_colors[i]) != M:
            raise IOError("Invalid input file!")

    for i in range(N):
        for j in range(M):
            if bonuses[i][j] == '*':
                if start_position is not None:
                    raise IOError("Two start positions!")
                start_position = (i, j)
            if bonuses[i][j] == '@':
                if stone_position is not None:
                    raise IOError("Two stones!")
                stone_position = (i, j)

    if start_position is None:
        raise IOError("No start position!")
    if stone_position is None:
        raise IOError("No stone position!")

class UserState:
    def __init__(self, position: Tuple[int, int], previous_state: "UserState",
            distance: int, shoes: Tuple[str, int], backpack: Tuple[str, int],
            has_stone: bool, history: List[str]):
        """
            position: position of player \\
            previous_state: former UserState the player is comming from \\
            shoes: color of the shoes (0) and number of times they were used (1) \\
            backpack: color of the shoes in the backpack (0) and nr of times they were used (1) \\
            has_stone: true if the player managed to get the stone \\
            history: log with all the moves made so far\\
        """
        self.distance = distance
        self.position = position
        self.previous_state = previous_state
        self.shoes = shoes
        self.backpack = backpack
        self.has_stone = has_stone
        self.history = history

    def IsFinalNode(self) -> bool:
        """
            Returns true if the player has the stone.
        """
        return self.position == start_position and self.has_stone

    def EncodeState(self) -> Tuple:
        """
            Encodes the current state into a list, for easier
            equality checking. The encoding DOES NOT include the distance.
        """
        return tuple([self.position, self.shoes, self.backpack, self.has_stone])

    def TryToMove(self, new_position: Tuple[int, int]) -> "List[UserState]":
        """
            Tries to move to a new position.
            This assumes the new position is next to the current position.
        """
        if new_position[0] < 0 or new_position[1] < 0 or new_position[0] >= N\
                or new_position[1] >= M:
            return []
        next_color = map_colors[new_position[0]][new_position[1]]

        posible_states_before_pickup: List[UserState] = []

        # Use shoes i'm wearing
        if self.shoes[0] == next_color and self.shoes[1] < 3:
            new_state = UserState(
                new_position,
                self,
                self.distance + 1,
                (self.shoes[0], self.shoes[1] + 1),
                self.backpack,
                self.has_stone,
                ["Moved from " + str(self.position) + " to " + str(new_position)]
            )
            posible_states_before_pickup.append(new_state)

        # Change shoes
        if self.backpack is not None and self.backpack[0] == next_color and self.backpack[1] < 3:
            # Don't change shoes if same color unless completly used
            if self.backpack[0] != self.shoes[0] or self.shoes[1] == 3:
                new_state = UserState(
                    new_position,
                    self,
                    self.distance + 1,
                    (self.backpack[0], 1 + self.backpack[1]),
                    self.shoes,
                    self.has_stone,
                    ["Moved from " + str(self.position) + " to " + str(new_position) + " after changing shoes with the backpack"]
                )
                posible_states_before_pickup.append(new_state)
        
        ans = []

        for new_state in posible_states_before_pickup:
            new_state.CleanUp()
            bonus = map_bonus[new_position[0]][new_position[1]]
            if bonus == '@' and new_state.has_stone == False:
                new_state.has_stone = True
                new_state.history.append("Took the magic stone")
                ans.append(new_state)
                continue
            
            if bonus == '0' or bonus == '*':
                ans.append(new_state)
                continue

            if new_state.backpack is None:
                new_state.backpack = (bonus, 0)
                new_state.history.append("Took shoes of color " + bonus + " and put them in the backpack")
                ans.append(new_state)
                continue
            
            # Ignore bonus - only if backpack is different.
            if new_state.backpack[0] != bonus:
                ans.append(new_state)

            # Replace backpack -- only if different.
            if new_state.backpack[0] != bonus or new_state.backpack[1] != 0:
                state_with_new_backpack = UserState(
                    new_state.position,
                    new_state.previous_state,
                    new_state.distance,
                    new_state.shoes,
                    (bonus, 0),
                    new_state.has_stone,
                    new_state.history + ["Replaced backpack with the new " + bonus + " shoes"]
                )
                ans.append(state_with_new_backpack)

            if bonus == next_color:
                state_with_new_shoes_same_backpack = UserState(
                    new_state.position,
                    new_state.previous_state,
                    new_state.distance,
                    (bonus, 0),
                    new_state.backpack,
                    new_state.has_stone,
                    new_state.history + ["Replaced shoes i'm wearing with the new " + bonus + " shoes, and threw the previous ones"]
                )
                ans.append(state_with_new_shoes_same_backpack)

                if new_state.backpack[0] != new_state.shoes[0]:
                    state_with_new_shoes_diff_backpack = UserState(
                        new_state.position,
                        new_state.previous_state,
                        new_state.distance,
                        (bonus, 0),
                        new_state.shoes,
                        new_state.has_stone,
                        new_state.history + ["Replaced shoes i'm wearing with the new " +
                                            bonus +
                                            " shoes, placed current shoes in backpack, and threw shoes from backpack"]
                    )
                    ans.append(state_with_new_shoes_diff_backpack)
        
        for new_state in ans:
            new_state.CleanUp()
        return ans

    def CleanUp(self):
        """
            Remove item from backpack if finished.
        """
        if self.backpack is not None and self.backpack[1] == 3:
            self.backpack = None
            self.history.append("Removed shoes from the backpack as they are completly used")

    def GenerateSuccessors(self) -> "List[UserState]":
        """
            Returns all the possible successors of a position.
        """
        ans = []
        for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            new_position = self.TryToMove((self.position[0] + dx, self.position[1] + dy))
            ans += new_position
        return ans

    def GetPath(self) -> "List[UserState]":
        """
            Generates all the path from the root of the 
            search tree all the way to the current node.
        """
        ans = []
        act = self

        while act is not None:
            ans.append(act)
            act = act.previous_state
        
        return ans[::-1]

    def IsInPath(self, state: "UserState") -> bool:
        """
            Returns if the UserState `state` is already included in the path.
        """
        for i in self.GetPath():
            if i.EncodeState() == state.EncodeState():
                return True
        return False
