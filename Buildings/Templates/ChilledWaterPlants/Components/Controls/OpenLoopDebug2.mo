within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoopDebug2 "Open loop controller (output signals only)"
  extends Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoopDebug;

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1Chi[nChi](each k=true)
    "Chiller Start/Stop signal"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

equation
  connect(y1Chi.y, busChi.y1)
    annotation (Line(points={{12,20},{60,20},{60,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoopDebug2;
