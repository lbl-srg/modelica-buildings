import buildingspy.development.refactor as r

path = "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs."

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone",
	"Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.VAV")

# r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone",
# 	"Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone1")

# r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone1",
# 	"Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV")

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.VAV",
	"Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV")

# r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone",
# 	"Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone1")

# r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone1",
# 	"Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV")
