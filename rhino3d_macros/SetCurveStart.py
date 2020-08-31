import rhinoscriptsyntax as rs

# user clicks on cuts and it
#  assigns which is the starting point of the line

def kill_tags(layer):
    objs = rs.ObjectsByLayer("PARTS")
    if (objs):
        for obj in objs:
            type = rs.IsUserText(obj)
            # remove old ones
            if type==1: rs.GetUserText( obj, "start_location")


kill_tags("PARTS")
kill_tags("CUTS")
        
objs = rs.SelectedObjects() 
if len(objs) == 0:
    objs = rs.GetObjects("Select things")


if (objs):
    count = 1;
    rs.UnselectAllObjects()

    for obj in objs:
        if rs.IsCurve(obj):
            if rs.IsCurveClosed(obj):
                print "closed, skipping..."
                break
            else:
                rs.SelectObject(obj)
                pt = rs.GetPointOnCurve(obj, "Point on curve")
                if pt:
                    while (pt != rs.CurveStartPoint(obj) and
                           pt != rs.CurveEndPoint(obj)):
                        pt = rs.GetPointOnCurve(obj, "Pick again, on curve")

                    if pt == rs.CurveStartPoint(obj):
                        rs.SetUserText( obj, "start_location", "START" )
                        print "SET: %d START" % count

                    if pt == rs.CurveEndPoint(obj):
                        rs.SetUserText( obj, "start_location", "END" )
                        print "SET: %d END" % count

                    rs.UnselectObjects((obj))
                    count += 1


