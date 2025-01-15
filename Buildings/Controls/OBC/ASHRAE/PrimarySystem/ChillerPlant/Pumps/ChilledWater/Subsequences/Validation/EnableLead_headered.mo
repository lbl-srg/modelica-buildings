within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.Validation;
model EnableLead_headered
  "Validate sequence for enabling lead pump of plants with headered primary chilled water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered
    enaLeaChiPum(final nChi=2, have_WSE=true)
    "Enable lead chilled water pump based on the status of chilled water isolation valves"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp isoVal1(
    duration=3000,
    startTime=300)
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp isoVal2(
    duration=3000,
    startTime=900)
    "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wse(k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(isoVal1.y, enaLeaChiPum.uChiWatIsoVal[1]) annotation (Line(points={{-18,
          20},{0,20},{0,-0.5},{18,-0.5}}, color={0,0,127}));
  connect(isoVal2.y, enaLeaChiPum.uChiWatIsoVal[2]) annotation (Line(points={{-18,
          -20},{0,-20},{0,0.5},{18,0.5}}, color={0,0,127}));
  connect(wse.y, enaLeaChiPum.uWse) annotation (Line(points={{-18,-60},{10,-60},
          {10,-6},{18,-6}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Subsequences/Validation/EnableLead_headered.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences.EnableLead_headered</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Arpil 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
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
end EnableLead_headered;
