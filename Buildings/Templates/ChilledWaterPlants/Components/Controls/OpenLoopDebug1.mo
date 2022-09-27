within Buildings.Templates.ChilledWaterPlants.Components.Controls;
block OpenLoopDebug1 "Open loop controller (output signals only)"
  extends Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoopDebug;

  parameter Integer nChi(start=1);

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0,0; 1.2,0; 1.2,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Chiller, CW pumps and primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

equation
  connect(y1Chi.y[1], busChi.y1)
    annotation (Line(points={{12,20},{60,20},{60,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="ctr",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoopDebug1;
