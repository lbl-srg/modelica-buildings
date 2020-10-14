within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model DDSPset
  "This model simulates DDSPset"

 parameter Real minDDSPset(
   min=0,
   final unit="Pa",
   final displayUnit="bar",
   final quantity="PressureDifference")=125
  "Minimum down duct static pressure reset value"
  annotation (Dialog(group="DDSP range"));

 parameter Real maxDDSPset(
   min=0,
   final unit="Pa",
   final displayUnit="bar",
   final quantity="PressureDifference")=500
  "Maximum down duct static pressure reset value"
  annotation (Dialog(group="DDSP range"));

 parameter Real DamSet(
   min=0,
   max=1,
   final unit="1")=0.9
   "DDSP terminal damper percent open set point";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine mostOpenDamGen(
    amplitude=0.15,
    freqHz=1/4120,
    offset=0.85)
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset DDSPset
    annotation (Placement(transformation(extent={{34,-8},{54,12}})));
equation
  connect(mostOpenDamGen.y, DDSPset.mostOpenDam)
    annotation (Line(points={{-22,0},{32,0}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=5760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/FDE/PackagedRTUs/Validation/DDSPset.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset</a>.
</p>
</html>", revisions="<html>
<ul>
<li>August 21, 2020, by Henry Nickels:<br/>
Built simulation script.</li>
<li>August 16, 2020, by Henry Nickels:<br/>
Added 'experiment' annotation.</li>
<li>July 28, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>
"));
end DDSPset;
