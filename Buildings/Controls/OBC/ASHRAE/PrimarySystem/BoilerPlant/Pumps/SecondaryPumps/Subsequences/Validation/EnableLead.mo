within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.Validation;
model EnableLead
    "Validate sequence for enabling lead secondary pump of boiler plants"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLead
    enaLeaSecPum
    "Enable lead hot water pump based on the status of plant and hot water requests"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=5)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=1,
    final period=10,
    final offset=0)
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

equation
  connect(pul.y, reaToInt.u)
    annotation (Line(points={{-68,-20},{-52,-20}}, color={0,0,127}));

  connect(reaToInt.y, enaLeaSecPum.supResReq) annotation (Line(points={{-28,-20},
          {-10,-20},{-10,-4},{-2,-4}}, color={255,127,0}));

  connect(booPul.y, enaLeaSecPum.uPlaEna) annotation (Line(points={{-28,20},{
          -10,20},{-10,4},{-2,4}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/SecondaryPumps/Subsequences/Validation/EnableLead.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLead\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences.EnableLead</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    August 25, 2020, by Karthik Devaprasad:<br/>
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
              points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end EnableLead;
