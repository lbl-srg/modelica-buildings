within Buildings.Templates.AHUs.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends Interfaces.Controller;
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU
    annotation (Placement(transformation(extent={{-40,-64},{40,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[numZon]
    "Zone level calculation of the minimum outdoor airflow set point"
    annotation (Placement(transformation(extent={{160,-10},{140,10}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(numZon=numZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
