within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
block OpenLoop
  extends
    Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.PartialController(
    final typ=Buildings.Templates.HeatingPlants.HotWater.Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Boi[nBoi](
    each table=[0,0; 1,1; 2,0],
    each timeScale=1000,
    each period=2000) "Boiler Enable signal"
    annotation (Placement(transformation(extent={{-120,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    y(final unit="K", displayUnit="degC"),
    k=Buildings.Templates.Data.Defaults.THeaWatSup)
    "HW supply temperature set point"
    annotation (Placement(transformation(extent={{-120,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPri[
    nPumHeaWatPri](
    table=y1Boi.table,
    timeScale=y1Boi.timeScale,
    period=y1Boi.period)
    "Primary HW pump Enable signal"
    annotation (Placement(transformation(extent={{-120,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumHeaWatPri(y(final
        unit="1"), k=1) "Primary HW pump speed signal"
    annotation (Placement(transformation(extent={{-120,10},{-140,30}})));
equation
  connect(y1Boi.y[1], bus.y1Boi) annotation (Line(points={{-142,140},{-200,140},{-200,
          0},{-260,0}}, color={255,0,255}));
  connect(THeaWatSupSet.y, bus.THeaWatSupSet) annotation (Line(points={{-142,100},
          {-192,100},{-192,0},{-260,0}}, color={0,0,127}));
  connect(y1PumHeaWatPri.y[1], busPumHeaWatPri.y1)
    annotation (Line(points={{-142,60},{-240,60}}, color={255,0,255}));
  connect(yPumHeaWatPri.y, busPumHeaWatPri.y)
    annotation (Line(points={{-142,20},{-240,20},{-240,60}}, color={0,0,127}));
  annotation (
  defaultComponentName="ctl",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
