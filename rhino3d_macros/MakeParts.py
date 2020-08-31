# Turn all selected items into parts. 

import rhinoscriptsyntax as rs
import Rhino.RhinoApp as app
from System.Drawing import Color
import sys
import time

objects = rs.SelectedObjects()  

if not objects: 
    objects = rs.GetObjects("Select objects")

objects = rs.SelectedObjects()  
for object_id in objects:
    if rs.IsCurve(object_id):
        rs.ObjectLayer(object_id, "PARTS")

rs.FlashObject(objects, style=True)
rs.UnselectObjects(objects)
app.Wait()
time.sleep(1)
rs.SelectObjects(objects)

print "Made parts"

success = False


