import java.io.PrintStream;
import java.util.ArrayList;

interface DS {
    public void update(int val);
    public int query(int val);
}

class St implements DS {
    ArrayList <Integer> arr;
    
    St() {
        arr = new ArrayList<Integer>();
    }

    public void update(int val) {
        arr.add(val);
    }

    public int query(int val) {
        int ans = arr.get(val);
        return ans;
    }
}

abstract class Idk {
    abstract public int Tell();
}

class Idk2 extends Idk {
    public int Tell() {
        return 10;
    }
}


public class Code {
    public static void main(String[] args) {
        DS a = new St();
        for (int i = 0; i < 10; i++)
            a.update(i);
        
        System.out.println(a.query(3));

        Idk ab = new Idk2();
        
        System.out.println(ab.Tell());
    }
}