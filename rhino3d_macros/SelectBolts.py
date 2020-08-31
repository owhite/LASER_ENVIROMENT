import rhinoscriptsyntax as rs

# Asks user for where they'd like a hole bolt a template,
#  place that hole

rs.UnselectAllObjects()

bolts = {2: 0.096, 4: 0.121, 6: 0.146, 8: 0.175}

pt = rs.GetPoint("Select point")

if pt:
    choice = rs.ListBox(sorted(list(bolts.keys())), "select bolt")
    if choice:
        print ("placing bolt hole: %lf") % bolts[int(choice)]
        c = rs.AddCircle(pt, bolts[int(choice)] / 2)

