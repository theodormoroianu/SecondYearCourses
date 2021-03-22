import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Football
{
    static void IncreaseByX(Map <String, Integer> mp, String id, int val)
    {
        if (mp.containsKey(id))
            mp.put(id, mp.get(id) + val);
        else
            mp.put(id, val);
    }

    public static void main(String[] args) {
        
        // Map storing tuples (team, points).
        Map <String, Integer> points = new HashMap<>();
        Map <String, Integer> scored_goals = new HashMap<>();
        Map <String, Integer> received_goals = new HashMap<>();
        
        // Open scanner.
        Scanner fin = new Scanner(System.in);

        // Ignore the number of teams.
        fin.nextInt();
        
        // Read the number of matches.
        int number_of_matches = fin.nextInt();

        // Read matches.
        for (int i = 0; i < number_of_matches; i++) {
            String team1, team2;
            int score1, score2;

            // read one match.
            team1 = fin.next();
            score1 = fin.nextInt();
            fin.next();
            score2 = fin.nextInt();
            team2 = fin.next();

            // Update entries.
            IncreaseByX(scored_goals, team1, score1);
            IncreaseByX(received_goals, team1, score2);
            IncreaseByX(scored_goals, team2, score2);
            IncreaseByX(received_goals, team2, score1);

            // Update winning teams.
            if (score1 > score2) {
                IncreaseByX(points, team1, 3);
                IncreaseByX(points, team2, 0);
            }
            else if (score1 < score2) {
                IncreaseByX(points, team2, 3);
                IncreaseByX(points, team1, 0);
            }
            else {
                IncreaseByX(points, team1, 1);
                IncreaseByX(points, team2, 1);
            }
        }

        // Array to store teams into.
        ArrayList <String> teams = new ArrayList<>();

        // Extracting teams from the map.
        for (Map.Entry<String, Integer> it : points.entrySet())
            teams.add(it.getKey());

        // Sorting the teams according to the number of points.
        teams.sort((t1, t2) -> (points.get(t1) < points.get(t2) ? 1 : -1));

        // Printing the teams.
        for (String team : teams) {
            System.out.print(team + " ");
            System.out.print(points.get(team) + " ");
            System.out.print(scored_goals.get(team) + " ");
            System.out.print(received_goals.get(team) + "\n");
        }

        fin.close();
    }
}