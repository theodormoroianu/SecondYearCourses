#include <complex>


typedef std::complex<double> Point;
#define x real
#define y imag

double Cross(Point a, Point b)
{
    return (std::conj(a) * b).y();
}

double Dot(Point a, Point b)
{
    return (std::conj(a) * b).x();
}

double Dist(Point a, Point b)
{
    return std::abs(b - a);
}

/**
 * Returns the intersection point of two lines.
 * Indefined behaviour if the two lines don't intersect.
 */
Point Intersection(Point A, Point B, Point C, Point D)
{
    /**
     * Intersection is I = t * A + (1 - t) * B
     * (I - C) x (D - C) = 0
     * (t * A + (1 - t) * B - C) x (D - C) = 0
     * (t * (A - B) + (B - C)) x (D - C) = 0
     * t * (A - B) x (D - C) = -(B - C) x (D - C)
     * t = (C - B) x (D - C) / (A - B) / (D - C)
     */
    double t = Cross(C - B, D - C) / Cross(A - B, D - C);
    return t * A + (1 - t) * B;
}

/**
 * Checks if a point is on a segment.
 */
bool IsOnSegment(Point A, Point B, Point check)
{
    if (check.x() < std::min(A.x(), B.x()) || check.x() > std::max(A.x(), B.x())
            || check.y() < std::min(A.y(), B.y()) || check.y() > std::max(A.y(), B.y()))
        return false;
    return std::abs(Cross(check - A, B - A)) < 1e-5;
}

/**
 * checks if two lines intersect.
 * @return 0 if paralel, 1 if they intersect within the segments and 2 otherwise.
 */
int CheckIntersection(Point A, Point B, Point C, Point D)
{
    /**
     * Try to get intersection.
     * If attempting division by 0 stop, and return they are paralel.
     * Afterwards, check if the intersection is inside the segments.
     */
    double nom = Cross(C - B, D - C);
    double denom = Cross(A - B, D - C);

    if (std::abs(denom) < 1e-5)
        return 0;

    double t = nom / denom;
    Point intersect = t * A + (1 - t) * B;

    if (IsOnSegment(A, B, intersect) && IsOnSegment(C, D, intersect))
        return 1;
    return 2;
}