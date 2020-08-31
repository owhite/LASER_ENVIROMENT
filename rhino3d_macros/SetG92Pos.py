import rhinoscriptsyntax as rs

# user clicks on point where G92 will be set in nc file
#  if none found toolpath.py will use 0,0

objs = rs.ObjectsByType(8192)
if (objs):
    for obj in objs:
        item = rs.TextDotText( obj )
        if (item.lower() == 'G92'): 
            rs.DeleteObject( obj ) # remove old point if it exists

pt = rs.GetPoint("Select point")
if pt: 
    rs.AddTextDot("G92",pt) # boink
            
