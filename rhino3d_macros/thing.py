# @author: Sam Korman
# https://www.diywalkers.com/python-linkage-simulator.html
# NOTE: to animate the plot run "%matplotlib qt"

import math
import rhinoscriptsyntax as rs
import sys
import Rhino.RhinoApp as app
from System.Drawing import Color

class kinematics:
    def __init__(self):

        self.dots = ('J0', 'J1', 'J2', 'J3')
        self.joints = {}
        l  = []
        objs = rs.ObjectsByType(8192) # get all the text dots
        if (objs):
            for obj in objs:
                l.append(rs.TextDotText(obj))
                # points gets loaded into self.joints
                self.joints[rs.TextDotText(obj)] = rs.TextDotPoint(obj)

        for d in self.dots:
            if d not in l: # missing one!
                sys.exit("cant find annotation dot %s in drawing" % d)

        self.lengths = {}
        self.lengths['B0'] = rs.Distance(self.joints['J0'], self.joints['J1'])
        self.lengths['B1'] = rs.Distance(self.joints['J1'], self.joints['J3'])
        self.lengths['B2'] = rs.Distance(self.joints['J2'], self.joints['J3'])

        self.angles = {}

    def circIntersection(self, jointA, barA, jointB, barB, intersectionNum):

        xPos_a = self.joints[jointA][0]
        yPos_a = self.joints[jointA][1]
        xPos_b = self.joints[jointB][0]
        yPos_b = self.joints[jointB][1]

        Lc = math.sqrt(((xPos_a - xPos_b) ** 2) + ((yPos_a - yPos_b) ** 2))
        bb = ((self.lengths[barB] ** 2) - (self.lengths[barA] ** 2) + (Lc ** 2)) / (Lc * 2)

        h = math.sqrt(abs((((self.lengths[barB]) ** 2) - (bb ** 2))))
        Xp = xPos_b + ((bb * (xPos_a - xPos_b)) / Lc)
        Yp = yPos_b + ((bb * (yPos_a - yPos_b)) / Lc)
        Xsolution1 = Xp + ((h * (yPos_b - yPos_a)) / Lc)
        Ysolution1 = Yp - ((h * (xPos_b - xPos_a)) / Lc)
        Xsolution2 = Xp - ((h * (yPos_b - yPos_a)) / Lc)
        Ysolution2 = Yp + ((h * (xPos_b - xPos_a)) / Lc)
        solution1 = [Xsolution1, Ysolution1, 0]
        solution2 = [Xsolution2, Ysolution2, 0]
        if intersectionNum == 0 :
            if (Ysolution1 > Ysolution2):
                return solution1
            else:
                return solution2
        elif intersectionNum == 1:
            if (Ysolution1 < Ysolution2):
                return solution1
            else:
                return solution2
        elif intersectionNum == 2:
            if (Xsolution1 < Xsolution2):
                return solution1
            else:
                return solution2
        else:
            if (Xsolution1 > Xsolution2):
                return solution1
            else:
                return

    #This function finds the joint that is in a straight line from jointA to jointB,
    # with the length of the bar Lb.
    # if Lb extends directly away from line AB, then angle = 180
    def lineExtensionAngle(self, jointA, jointB, Lb, angle):
        xPos_a = self.joints[jointA][0]
        yPos_a = self.joints[jointA][1]
        xPos_b = self.joints[jointB][0]
        yPos_b = self.joints[jointB][1]
        theta = math.atan2((yPos_b - yPos_a) , (xPos_b - xPos_a))
        X3 = (xPos_b + (Lb * math.cos(theta)))
        Y3 = (yPos_b + (Lb * math.sin(theta)))
        solution = [X3, Y3]

        pt = rs.AddPoint((X3,Y3,0))

        print ("%lf %lf :: %lf %lf") % (xPos_a, yPos_a, xPos_b, yPos_b)
        print ("bar: %lf :: %lf") % (Lb, angle)

        angle = math.radians((180 - angle) * -1)
        
        # rs.RotateObject(pt, (xPos_b, yPos_b, 0), angle)
        # rs.DeleteObject(pt)

        X3 = xPos_b + math.cos(angle) * (X3 - xPos_b) - math.sin(angle) * (Y3 - yPos_b)
        Y3 = yPos_b + math.sin(angle) * (X3 - xPos_b) + math.cos(angle) * (Y3 - yPos_b)

        return (X3, Y3)
    
    def lineExtension(self, jointA, jointB, Lb):
        xPos_a = self.joints[jointA][0]
        yPos_a = self.joints[jointA][1]
        xPos_b = self.joints[jointB][0]
        yPos_b = self.joints[jointB][1]
        theta = math.atan2((yPos_b - yPos_a) , (xPos_b - xPos_a))
        X3 = (xPos_b + (Lb * math.cos(theta)))
        Y3 = (yPos_b + (Lb * math.sin(theta)))
        solution = [X3, Y3]

        return solution

    def MakeLine(self, line, layer):
        id = rs.AddPolyline(line)
        rs.ObjectLayer(id, layer)

    # knowing the original positions of four bars defined by
    #  crank origin: C0, end of crank C1
    #  cross piece: C1, E1
    #  effector origin: C0, end of effector: C1
    # if you know rotation of crank, return position effector end, E1
    # this works great if you know the starting positions of crank
    #  and effector
    def fourBarPostion(self, C0, C1, E0, E1, angle):
        # bar length
        self.lengths['B_len'] = rs.Distance(self.joints[C1], self.joints[E1])
        # Effector length
        self.lengths['E_len'] = rs.Distance(self.joints[E0], self.joints[E1])

        # first calculate the position of C1 after it is rotated
        # gotta load pt into the structure to make it findable
        self.joints['FB_PT'] = self.rotate(self.joints[C0], self.joints[C1], angle)

        # E1 is determined by
        #  the intersection of a circle created by the bar
        #  and the circle created by the effector

        return self.circIntersection('FB_PT' , 'B_len', E0, 'E_len', 0)


    def rotate(self, origin, point, angle):
        angle = math.radians(angle)
        ox, oy = origin[0], origin[1]
        px, py = point[0], point[1]

        qx = ox + math.cos(angle) * (px - ox) - math.sin(angle) * (py - oy)
        qy = oy + math.sin(angle) * (px - ox) + math.cos(angle) * (py - oy)
        return qx, qy, 0 # confined to 2D space

    def findAngle(self, p0, p1, center):

        p0c = math.sqrt(math.pow(center[0]-p0[0],2) + math.pow(center[1]-p0[1],2))

        p1c = math.sqrt(math.pow(center[0]-p1[0],2) + math.pow(center[1]-p1[1],2))

        p0p1 = math.sqrt(math.pow(p1[0]-p0[0],2) + math.pow(p1[1]-p0[1],2))

        return math.degrees(math.acos((p1c*p1c+p0c*p0c-p0p1*p0p1)/(2*p1c*p0c)))

if __name__ == '__main__':

    new_angle = 270

    k = kinematics()

    k.fourBarPostion('J0', 'J1', 'J2', 'J3', new_angle)


