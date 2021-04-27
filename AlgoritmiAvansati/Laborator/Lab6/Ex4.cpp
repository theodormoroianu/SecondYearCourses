#include <bits/stdc++.h>
#include "points.hpp"
using namespace std;

/**
 * Returns if one of the edges AC or BD is illegal.
 * Whatever that means.
 */
bool CheckIllegal(Point A, Point B, Point C, Point D)
{
    cout << "IdK WhAt A IlLeGaL EdGe MeAnS ;(";
    assert(0);
}

// Exercise 4.
int main()
{
    auto read_point = []() -> Point {
        double x, y;
        cin >> x >> y;
        return Point({ x, y });
    };

    cout << "Introduceti cele 4 puncte:\n";
    Point A = read_point(), B = read_point(),
          C = read_point(), D = read_point();
   
    cout << "Angle is " << Angle(A, B, C) << '\n';
    return 0;

    if (CheckIllegal(A, B, C, D))
        return cout << "NIII NOOO NIII NOOO vine politia\n", 0;
    cout << "Poligonul nu conduce activiati ilegale!\n";
    return 0;
}
