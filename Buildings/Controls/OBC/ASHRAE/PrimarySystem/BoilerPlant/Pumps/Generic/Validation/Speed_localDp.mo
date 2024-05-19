within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Validation;
model Speed_localDp
  "Validate sequence of controlling hot water pump speed for plants with local DP sensor hardwired to the plant controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp
    hotPumSpe(
    final nSen=2,
    final nPum=2)
    "Hot water pump speed control based on local pressure difference sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    final width=fill(0.95, 2),
    final period=fill(10, 2),
    final shift=fill(1, 2))
    "Pump status"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine remPreSen1(
    final offset=8.5*6894.75,
    final freqHz=1/10,
    final amplitude=1.5*6894.75)
    "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/10,
    final startTime=2,
    final amplitude=1*6894.75)
    "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine locPreSen(
    final freqHz=1/5,
    final amplitude=1*6894.75,
    final offset=8.5*6894.75)
    "Local pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

equation
  connect(locPreSen.y,hotPumSpe.dpHotWat_local)
    annotation (Line(points={{-38,80},{0,80},{0,8},{18,8}},
      color={0,0,127}));

  connect(remPreSen1.y,hotPumSpe. dpHotWat_remote[1]) annotation (Line(points={
          {-38,0},{-20,0},{-20,-5},{18,-5}}, color={0,0,127}));

  connect(remPreSen2.y,hotPumSpe. dpHotWat_remote[2]) annotation (Line(points={
          {-38,-40},{-20,-40},{-20,-3},{18,-3}}, color={0,0,127}));

  connect(difPreSet.y,hotPumSpe.dpHotWatSet)
    annotation (Line(points={{-38,-80},{0,-80},{0,-8},{18,-8}},
      color={0,0,127}));

  connect(pumSta.y,hotPumSpe.uHotWatPum)
    annotation (Line(points={{-38,40},{-20,40},{-20,4},{18,4}},
      color={255,0,255}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/Generic/Validation/Speed_localDp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic.Speed_localDp</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 3, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Speed_localDp;
