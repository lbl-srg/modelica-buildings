within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
block OpenLoop
  extends Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController;


  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Boi(
    table=[0,1; 1,1],
    timeScale=3600,
    period=3600) "Boiler Enable signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
