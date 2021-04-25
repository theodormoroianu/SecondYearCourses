#include <bits/stdc++.h>
#include "points.hpp"
using namespace std;


pair <Point, double> CircumscribedCircle(Point A, Point B, Point C)
{
    /**
     * Center of circumscribed circle is the intersection of the perpendicular bisectors.
     * Bisector of AB is the line containing (A + B) / 2 and having the direction ((B-A).y(), -(B-A).x())
     * Same goes for AC.
     * The intersection of the two lines yields the center of the circle.
     */
    Point centerAB = (A + B) / 2.;
    Point centerAC = (A + C) / 2.;
    Point dir_bis_AB = Point({ (B - A).y(), (A - B).x() });
    Point dir_bis_AC = Point({ (C - A).y(), (A - C).x() });
    
    Point center = Intersection(centerAB, centerAB + dir_bis_AB, centerAC, centerAC + dir_bis_AC);

    // radius of the circle.
    double radius = Dist(center, A);

    // Verify it is indeed the center.
    assert(abs(Dist(center, B) - radius) < 1e-5);
    assert(abs(Dist(center, C) - radius) < 1e-5);

    return { center, radius };
}

// Exercise 3.
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

    auto [center, radius] = CircumscribedCircle(A, B, C);
    
    double dist = Dist(D, center);

    if (abs(dist - radius) < 1e-5)
        return cout << "Punctul este pe cerc!!\n", 0;
    
    if (dist < radius)
        return cout << "Punctul este in cerc!!\n", 0;

    cout << "Punctul este inafara cercului!!\n";
    return 0;
}