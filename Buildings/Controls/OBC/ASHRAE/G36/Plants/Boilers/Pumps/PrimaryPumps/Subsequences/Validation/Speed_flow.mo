within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Subsequences.Validation;
model Speed_flow
  "Validate sequence of controlling hot water pump speed for primary-secondary plants with flowrate sensors"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Subsequences.Speed_flow
    hotPumSpe(
    use_priSecSen=true,
    nPum=2,
    minFlo=1.5)
    "Scenario testing speed control using flowrate sensors in primary and secondary circuits"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Subsequences.Speed_flow
    hotPumSpe1(
    use_priSecSen=false,
    nPum=2,
    minFlo=1.5)
    "Scenario testing speed control using flowrate sensor in decoupler"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pumSta[2](
    width=fill(0.95, 2),
    period=fill(10, 2),
    shift=fill(1, 2))
    "Pump status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant secFloSen(
    k=8.5)
    "Flowrate sensor reading from secondary circuit"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin priFloSen(
    offset=8.5,
    freqHz=1/10,
    amplitude=1.5)
    "Flowrate sensor reading from primary circuit"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin decFloSen(
    offset=0,
    freqHz=1/10,
    amplitude=0.5)
    "Flowrate sensor reading from decoupler"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

equation
  connect(pumSta.y, hotPumSpe.uHotWatPum) annotation (Line(points={{-58,40},{-50,
          40},{-50,6},{-42,6}}, color={255,0,255}));
  connect(priFloSen.y, hotPumSpe.VHotWatPri_flow)
    annotation (Line(points={{-58,0},{-50,0},{-50,2},{-42,2}},
                                               color={0,0,127}));
  connect(secFloSen.y, hotPumSpe.VHotWatSec_flow) annotation (Line(points={{-58,-40},
          {-50,-40},{-50,-2},{-42,-2}},      color={0,0,127}));
  connect(pumSta.y, hotPumSpe1.uHotWatPum) annotation (Line(points={{-58,40},{30,
          40},{30,6},{38,6}}, color={255,0,255}));
  connect(decFloSen.y, hotPumSpe1.VHotWatDec_flow)
    annotation (Line(points={{22,-40},{30,-40},{30,-6},{38,-6}},
                                                             color={0,0,127}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Pumps/PrimaryPumps/Subsequences/Validation/Speed_flow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Subsequences.Speed_flow\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Subsequences.Speed_flow</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Karthik Devaprasad:<br/>
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
end Speed_flow;
