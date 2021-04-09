from dataclasses import dataclass
from typing import Any, Callable, List, Optional, Tuple
import pygame
import sys
import copy
import time
import random

# Constants used through the game.
# They are defined here so that any function is able to access them.
GAME_H_OFFSET = 50
CIRCLE_RADIUS = 15
RECTANGLE_WIDTH = 10
OFFSET = 10 + CIRCLE_RADIUS
DISTANCE = 100
WINNER_RADIUS = 30
PLAYER_0_BACKGROUND_COLOR = (255, 200, 200)
PLAYER_1_BACKGROUND_COLOR = (200, 200, 255)
GAME_SCREEN_X, GAME_SCREEN_Y = None, None
pygame.font.init()
FONT = pygame.font.Font('freesansbold.ttf', 32)
FONT_SMALLER = pygame.font.Font('freesansbold.ttf', 28)

# Statistics kept about the game, number of steps or computer.
stats_game_start_time = 0
stats_nodes_generated = []
stats_current_nodes_generated = 0
stats_time = []
stats_moves = [0, 0]

# State class, storing the actual state of the game.
# This class is also used in the game search tree, but 
# in that particular case, the display is set to None.
class State:

    # constructor of the class.
    def __init__(self, COL: int, LIN: int, display):
        self.LIN = LIN
        self.COL = COL
        
        # if there is a bar to the right of a point
        self.right_taken = [[False for j in range(LIN)] for i in range(COL - 1)]
        # if there is a bar below a point
        self.below_taken = [[False for j in range(LIN - 1)] for i in range(COL)]

        self.right = [[pygame.Rect(
                            OFFSET + i * DISTANCE,
                            OFFSET + j * DISTANCE - RECTANGLE_WIDTH / 2 + GAME_H_OFFSET,
                            DISTANCE,
                            RECTANGLE_WIDTH) for j in range(LIN)] for i in range(COL - 1)]

        self.below = [[pygame.Rect(
                            OFFSET + i * DISTANCE - RECTANGLE_WIDTH / 2,
                            OFFSET + j * DISTANCE - RECTANGLE_WIDTH + GAME_H_OFFSET,
                            RECTANGLE_WIDTH,
                            DISTANCE) for j in range(LIN - 1)] for i in range(COL)]

        # if a cell is taken
        self.taken = [[-1 for j in range(LIN - 1)] for i in range(COL - 1)]
        self.display = display
    
    def create_copy(self):
        '''
            Returns a deep copy of the state. Used for modifying the copy
            without changing the original object.
        '''
        s = State(self.COL, self.LIN, None)
        s.right_taken = copy.deepcopy(self.right_taken)
        s.below_taken = copy.deepcopy(self.below_taken)
        s.taken = copy.deepcopy(self.taken)
        return s

    def scores(self):
        '''
            Returns the scores of the two players, as
            a vector: [score_player_0, score_player_1]s
        '''
        ans = [0, 0]
        for i in range(self.COL - 1):
            for j in range(self.LIN - 1):
                if self.taken[i][j] != -1:
                    ans[self.taken[i][j]] += 1
        return ans

    def possible_moves(self):
        '''
            Returns all available moves.
            Only considers valid moves (ofc.).
            Goes through all edges not yet choosen, and returns them.
        '''
        ans = []
        for i in range(self.COL):
            for j in range(self.LIN):
                if i < self.COL - 1 and self.right_taken[i][j] == False:
                    ans.append((0, i, j))
                if j < self.LIN - 1 and self.below_taken[i][j] == False:
                    ans.append((1, i, j))
        random.shuffle(ans)
        return ans

    def draw(self):
        '''
            Renders the game into the display.
            This prints only the actual game, no
            additional text / background.
        '''
        for i in range(self.COL - 1):
            for j in range(self.LIN):
                color = (200, 200, 200) if not self.right_taken[i][j] else (0, 0, 0)
                pygame.draw.rect(self.display, color, self.right[i][j])
        
        for i in range(self.COL):
            for j in range(self.LIN - 1):
                color = (200, 200, 200) if not self.below_taken[i][j] else (0, 0, 0)
                pygame.draw.rect(self.display, color, self.below[i][j])

        for i in range(self.COL - 1):
            for j in range(self.LIN - 1):
                if self.taken[i][j] == -1:
                    continue
                color = (255, 0, 0) if self.taken[i][j] == 0 else (0, 0, 255)
                pygame.draw.circle(
                    self.display,
                    color,
                    (OFFSET + (i + 0.5) * DISTANCE, OFFSET + (j + 0.5) * DISTANCE + GAME_H_OFFSET),
                    WINNER_RADIUS
                )
        
        for i in range(self.COL):
            for j in range(self.LIN):
                pygame.draw.circle(
                    self.display,
                    (0, 0, 0),
                    (OFFSET + i * DISTANCE, OFFSET + j * DISTANCE + GAME_H_OFFSET),
                    CIRCLE_RADIUS
                )

        pygame.display.flip()

def game_ended(state: State):
    '''
        Returns if there are any available moves left.
    '''
    for i in range(state.COL - 1):
        for j in range(state.LIN - 1):
            if state.taken[i][j] == -1:
                return False
    return True

def alter_state(state: State, type_move: int, poz: Tuple[int, int], player) -> bool:
    '''
        Changes the state according to the pressed item.
        Returns true if the player should go again.
        type = 0 -> right 1 -> below.
        player: 0 / 1
    '''
    
    if type_move == 0:
        if state.right_taken[poz[0]][poz[1]]:
            return True
        state.right_taken[poz[0]][poz[1]] = True
    else:
        if state.below_taken[poz[0]][poz[1]]:
            return True
        state.below_taken[poz[0]][poz[1]] = True
    
    won_smth = False
    for i in range(state.COL - 1):
        for j in range(state.LIN - 1):
            if not state.below_taken[i][j] or not state.below_taken[i + 1][j]:
                continue
            if not state.right_taken[i][j] or not state.right_taken[i][j + 1]:
                continue
            if state.taken[i][j] != -1:
                continue
            won_smth = True
            state.taken[i][j] = player

    if state.display is not None:
        scor1, scor2 = state.scores()
        print(f"Atempted alteration of the state. New scores:")
        print(f"  * Player 1: {scor1}")
        print(f"  * Player 2: {scor2}")
    return won_smth

def estimate_state(state: State, estimation_type: int, player: int):
    '''
        Estimate state score for a given state.
        estimation_type = 0 -> difference between the number of cells.
        estimation_type = 1 -> difference between nr of cells + possible new captures.

        The state is estimated based on how many pieces are capured (which is what the 
        game is all about).
        Additionally, the estimation_Type can specity to also consider all pieces which have 
        3 used bordered (all of them can be captured at the same time by the player).
    '''
    estimation = 0

    def value(x):
        if x == 0:
            return 1
        if x == 1:
            return -1
        return 0

    for i in range(state.COL - 1):
        for j in range(state.LIN - 1):
            estimation += value(state.taken[i][j])
            if estimation_type == 1:
                nr_vec = (1 if state.right_taken[i][j] else 0) +\
                        (1 if state.right_taken[i][j + 1] else 0) +\
                        (1 if state.below_taken[i][j] else 0) +\
                        (1 if state.below_taken[i + 1][j] else 0)
                if nr_vec == 3:
                    estimation += 1 if player == 0 else -1
    return estimation


def min_max(state: State, player: int, depth: int, estimation_type: int) -> Tuple[int, Tuple[int, int, int]]:
    '''
        Min-Max algorithm.
    '''
    global stats_current_nodes_generated
    stats_current_nodes_generated += 1
    if depth == 0 or game_ended(state):
        return (estimate_state(state, estimation_type, player), None)

    estimate = -10**9 if player == 0 else 10**9
    action = None

    for (type_move, x, y) in state.possible_moves():
        state_copy = state.create_copy()
        new_player = player
        if not alter_state(state_copy, type_move, (x, y), new_player):
            new_player = 1 - new_player
        act, _ = min_max(state_copy, new_player, depth - 1, estimation_type)

        if (player == 0 and act > estimate) or (player == 1 and act < estimate):
            estimate = act
            action = (type_move, x, y)

    return (estimate, action)
    

def alpha_beta(state: State, player: int, alpha: int, beta: int, depth: int, estimation_type: int) -> Tuple[int, Tuple[int, int, int]]:
    '''
        alpha-beta prunning algorithm.
    '''
    global stats_current_nodes_generated
    stats_current_nodes_generated += 1
    if depth == 0 or game_ended(state):
        return (estimate_state(state, estimation_type, player), None)

    estimate = -10**9 if player == 0 else 10**9
    action = None

    for (type_move, x, y) in state.possible_moves():
        state_copy = state.create_copy()
        new_player = player
        if not alter_state(state_copy, type_move, (x, y), new_player):
            new_player = 1 - new_player
        act, _ = alpha_beta(state_copy, new_player, alpha, beta, depth - 1, estimation_type)

        if (player == 0 and act > estimate) or (player == 1 and act < estimate):
            estimate = act
            action = (type_move, x, y)

        if player == 0:
            alpha = max(alpha, act)
        else:
            beta = min(beta, act)

        if alpha >= beta:
            break

    assert(action is not None)
    return (estimate, action)

def print_title_on_display(content, display):
    '''
        Prints a given title on the display.
    '''
    text = FONT.render(content, True, (50, 50, 50))
    text_rect = text.get_rect()
    text_rect.center = (GAME_SCREEN_X // 2, GAME_H_OFFSET // 2 + 5)
    display.blit(text, text_rect)

def display_stats(state: State, player: int):
    '''
        Prints the statistics in the console.
    '''
    global stats_game_start_time, stats_nodes_generated
    global stats_current_nodes_generated, stats_time
    global stats_moves

    if len(stats_time) == 0:
        return

    status = "finished successfully" if game_ended(state) else "was stopped"
    print(f"\nStats for game which {status}:")
    print(f"  * Game duration: {time.time() - stats_game_start_time}")
    print(f"  * Number of moves made by the computer: {len(stats_time)}")
    print(f"  * Total computer thinking time: {sum(stats_time)}")
    print(f"  * Average computer thinking time: {sum(stats_time) / len(stats_time)}")
    print(f"  * Maximal computer thinking time: {max(stats_time)}")
    print(f"  * Minimal computer thinking time: {min(stats_time)}")
    stats_time = sorted(stats_time)
    print(f"  * Median computer thinking time: {stats_time[len(stats_time) // 2]}")
    print(f"  * Total number of visited nodes: {sum(stats_nodes_generated)}")
    print(f"  * Average number of visited nodes: {sum(stats_nodes_generated) / len(stats_nodes_generated)}")
    print(f"  * Maximal number of visited nodes: {max(stats_nodes_generated)}")
    print(f"  * Minimal number of visited nodes: {min(stats_nodes_generated)}")
    stats_nodes_generated = sorted(stats_nodes_generated)
    print(f"  * Median number of visited nodes: {stats_nodes_generated[len(stats_nodes_generated) // 2]}")
    print("  * Scores:")
    s1, s2 = state.scores()
    print(f"     * First player: {s1}")
    print(f"     * Second player: {s2}")
    print(f"  * Number of moves:")
    print(f"     * First player: {stats_moves[0]}")
    print(f"     * Second player: {stats_moves[1]}")

    if not game_ended(state):
        print("  * Estimated final scores (player1 - player2):")
        scor1, _ = min_max(state, player, 1, 1)
        scor2, _ = alpha_beta(state, player, -10**9, 10**9, 2, 1)
        print(f"     * Min-Max: {scor1}")
        print(f"     * Alpha-Beta: {scor2}")

def init_stats():
    '''
        Resets the status.
    '''
    global stats_game_start_time, stats_nodes_generated
    global stats_current_nodes_generated, stats_time
    global stats_moves

    stats_game_start_time = time.time()
    stats_nodes_generated = []
    stats_current_nodes_generated = 0
    stats_time = []
    stats_moves = [0, 0]

def game_loop(COL: int, LIN: int, display, players: List[Optional[Callable]], names: List[str]):
    '''
        Game loop. This will run forever until the user closes it.
    '''
    global stats_moves

    init_stats()

    # Create a new player.
    state = State(COL, LIN, display)
    player = 0
    last_move_time = time.time()

    step = False

    # Game loop.
    while True:

        # Something moved. Print statistics.
        if step:
            step = False
            
            s1, s2 = state.scores()
            print(f"     * First player: {s1}")
            print(f"     * Second player: {s2}")

            print("  * Estimated final scores (player1 - player2):")
            scor1, _ = min_max(state, player, 1, 1)
            scor2, _ = alpha_beta(state, player, -10**9, 10**9, 2, 1)
            print(f"     * Min-Max: {scor1}")
            print(f"     * Alpha-Beta: {scor2}")

        # Set proper background
        if player == 0:
            display.fill(PLAYER_0_BACKGROUND_COLOR)
        else:
            display.fill(PLAYER_1_BACKGROUND_COLOR)
        # Print text
        print_title_on_display(names[player] + "'s turn", display)
        # Render new state.
        state.draw()

        # If the game ended, then return
        if game_ended(state):
            status = estimate_state(state, 0, 0)
            if status > 0:
                display.fill(PLAYER_0_BACKGROUND_COLOR)
                print_title_on_display(names[0] + " wins!", display)
            elif status < 0:
                display.fill(PLAYER_1_BACKGROUND_COLOR)
                print_title_on_display(names[1] + " wins!", display)
            else:
                display.fill((255, 255, 255))
                print_title_on_display("Tie!", display)
            state.draw()

            display_stats(state, player)

            # Wait for game to stop
            while True:
                 for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        pygame.quit()
                        sys.exit()
                    if event.type == pygame.MOUSEBUTTONDOWN:
                        game_loop(COL, LIN, display, players, names)

        # If the player is a bot, then make it play.
        if players[player] is not None:
            type_move, x, y = players[player](state)
            if not alter_state(state, type_move, (x, y), player):
                stats_moves[player] += 1
                player = 1 - player
            last_move_time = time.time()
            step = True

        # Loop through the events of the game.
        for event in pygame.event.get():
            # Quit.
            if event.type == pygame.QUIT:
                display_stats(state, player)
                pygame.quit()
                sys.exit()
            
            # Something was pressed.
            if event.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()

                print(f"Player attempted a move. Time for the move: {time.time() - last_move_time}")
                last_move_time = time.time()
                
                # It's not a human player's turn.
                if players[player] != None:
                    continue
                
                # Check if a move was made, and if yes acknowledge it.
                for i in range(COL):
                    for j in range(LIN):
                        if i < COL - 1 and state.right[i][j].collidepoint(pos):
                            if not alter_state(state, 0, (i, j), player):
                                stats_moves[player] += 1
                                player = 1 - player
                        if j < LIN - 1 and state.below[i][j].collidepoint(pos):
                            if not alter_state(state, 1, (i, j), player):
                                stats_moves[player] += 1
                                player = 1 - player
                step = True

def ask_user_questions(question: str, answers: list, L: int, H: int, display):
    '''
        Asks the user some questions.
    '''
    display.fill((230, 255, 215))
    print_title_on_display(question, display)
    DISTANCE = 10

    X = len(answers)
    Y = len(answers[0])
    H -= GAME_H_OFFSET

    for i in range(X):
        for j in range(Y):
            rect = pygame.Rect(
                int(L / X * i) + 3,
                int(H / Y * j) + GAME_H_OFFSET + 3,
                int(L / X - 6),
                int(H / Y - 6)
            )
            pygame.draw.rect(display, (100, 100, 100), rect, width=4, border_radius=6) 

            center_x = int(L / X * i + (L / X / 2))
            center_y = GAME_H_OFFSET + int(H / Y * j + (H / Y / 2))
            text = FONT_SMALLER.render(answers[i][j], True, (20, 20, 20))
            text_rect = text.get_rect()
            text_rect.center = (center_x, center_y)
            display.blit(text, text_rect)
            
    pygame.display.flip()

    while True:
        # Loop through the events of the game.
        for event in pygame.event.get():
            # Quit.
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            
            # Something was pressed.
            if event.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                # Check if a move was made, and if yes acknowledge it.
                pos = (pos[0], pos[1] - GAME_H_OFFSET)

                choice = (int(pos[0] / (L / X)), int(pos[1] / (H / Y)))
                return choice
    

def main():
    '''
        Entry point of the application.
    '''
    global GAME_SCREEN_Y, GAME_SCREEN_X
    pygame.display.set_caption("Theodor Moroianu - Dots & Boxes")

    GAME_SCREEN_X = 800
    GAME_SCREEN_Y = 500

    # Get informations.
    ecran = pygame.display.set_mode(size=(GAME_SCREEN_X, GAME_SCREEN_Y))
    
    # Get table size.
    sizes = [[(4, 4), (5, 5)], [(7, 7), (8, 8)], [(6, 4), (10, 5)]]
    intrebari = [[str(a) + ' x ' + str(b) for a, b in x] for x in sizes]
    idx, idy = ask_user_questions("World size", intrebari, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

    COL, LIN = sizes[idx][idy]

    print("User selected a size of ", COL, LIN)

    # Choose estimation
    estimations = [["Number of pieces", "Number of pieces + captures"]]
    _, estimation = ask_user_questions("Estimation to use", estimations, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

    print(f"User choose the estimation {estimations[0][estimation]}")

    # Get first user.

    # Functions calling a-b prunning / min-max.
    def choose_a_b(steps, player):
        def eval(state):
            global stats_nodes_generated, stats_current_nodes_generated, stats_time
            stats_current_nodes_generated = 0
            time_before = time.time()
            est, mov = alpha_beta(state, player, -10**9, 10**9, steps, estimation)
            time_after = time.time()
            stats_time.append(time_after - time_before)
            stats_nodes_generated.append(stats_current_nodes_generated)
            print(f"Computer moved in {time_after - time_before} sec. New estimation: {est}, moves: {stats_current_nodes_generated}")
            return mov
        return eval
    def choose_min_max(steps, player):
        def eval(state):
            global stats_nodes_generated, stats_current_nodes_generated, stats_time
            stats_current_nodes_generated = 0
            time_before = time.time()
            est, mov = min_max(state, player, steps, estimation)
            time_after = time.time()
            stats_time.append(time_after - time_before)
            stats_nodes_generated.append(stats_current_nodes_generated)
            print(f"Computer moved in {time_after - time_before} sec. New estimation: {est}, moves: {stats_current_nodes_generated}")
            return mov
        return eval

    bots = [[None, choose_min_max(1, 0), choose_min_max(2, 0)],
             [choose_min_max(3, 0), choose_min_max(4, 0), choose_a_b(2, 0)],
             [choose_a_b(3, 0), choose_a_b(4, 0), choose_a_b(5, 0)]]
    questions = [["Human", "Easy MM", "Medium MM"],
                ["Hard MM", "Expert MM", "Easy AB"],
                ["Medium AB", "Hard AB", "Expert AB"]]
    idx, idy = ask_user_questions("First Player", questions, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

    player_1 = bots[idx][idy]
    name_1 = questions[idx][idy]

    print(f"The user choose the first user as {name_1}")

    bots = [[None, choose_min_max(1, 1), choose_min_max(2, 1)],
             [choose_min_max(3, 1), choose_min_max(4, 1), choose_a_b(2, 1)],
             [choose_a_b(3, 1), choose_a_b(4, 1), choose_a_b(5, 1)]]
    questions = [["Human", "Easy MM", "Medium MM"],
                ["Hard MM", "Expert MM", "Easy AB"],
                ["Medium AB", "Hard AB", "Expert AB"]]
    idx, idy = ask_user_questions("Second Player", questions, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

    player_2 = bots[idx][idy]
    name_2 = questions[idx][idy]

    print(f"The user choose the second user as {name_2}")

    GAME_SCREEN_X = (COL - 1) * DISTANCE + 2 * OFFSET
    GAME_SCREEN_Y = (LIN - 1) * DISTANCE + 2 * OFFSET + GAME_H_OFFSET
    ecran = pygame.display.set_mode(size=(GAME_SCREEN_X, GAME_SCREEN_Y))
              
    # Starting the game.
    print("Starting game loop....")
    game_loop(COL, LIN, ecran, [player_1, player_2], [name_1, name_2])
    

if __name__ == '__main__':
    main()

