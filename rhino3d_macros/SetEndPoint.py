import rhinoscriptsyntax as rs

# user clicks on point where the CNC for the final move of laser
#  if none found toolpath.py will use 0,0

objs = rs.ObjectsByType(8192)
if (objs):
    for obj in objs:
        item = rs.TextDotText( obj )
        if (item.lower() == 'end'): 
            rs.DeleteObject( obj ) # remove old end point if it exists

pt = rs.GetPoint("Select point")
if pt: 
    rs.AddTextDot("END",pt) # boink
            
