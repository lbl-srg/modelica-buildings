within Buildings.Templates.Plants.Controls.MinimumFlow;
block Setpoint "Minimum flow setpoint calculation"
  parameter Integer nEqu(
    final min=1)=0
    "Number of plant equipment"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  parameter Real V_flow_nominal[:](
    each final unit="m3/s")
    "Design flow rate – Each unit";
  parameter Real V_flow_min[:](
    each final unit="m3/s")
    "Minimum flow rate – Each unit";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nEqu]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPriSet_flow(
    final unit="m3/s")
    "Primary flow setpoint"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant floMin[nEqu](
    final k=V_flow_min)
    "Minimum flow rate"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nEqu](
    each final realTrue=1,
    each final realFalse=0)
    "Convert to real signal"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply floMinEna[nEqu]
    "Minimum flow for enabled equipment"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide ratFloMinEna[nEqu]
    "Minimum flow ratio for enabled equipment"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant floDes[nEqu](
    final k=V_flow_nominal)
    "Design flow rate"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax maxRatFloMinEna(
    nin=nEqu)
    "Maximum of minimum flow ratio for enabled equipment"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply floDesEqu[nEqu]
    "Design flow for enabled equipment"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum sumFloDesEna(
    nin=nEqu)
    "Sum of design flow for enabled equipment"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply floMinSet
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(u1, booToRea.u)
    annotation (Line(points={{-120,0},{-92,0}},color={255,0,255}));
  connect(booToRea.y, floMinEna.u2)
    annotation (Line(points={{-68,0},{-60,0},{-60,-6},{-52,-6}},color={0,0,127}));
  connect(floMin.y, floMinEna.u1)
    annotation (Line(points={{-68,60},{-60,60},{-60,6},{-52,6}},color={0,0,127}));
  connect(floDes.y, ratFloMinEna.u2)
    annotation (Line(points={{-68,-60},{-20,-60},{-20,-6},{-10,-6}},color={0,0,127}));
  connect(floMinEna.y, ratFloMinEna.u1)
    annotation (Line(points={{-28,0},{-20,0},{-20,6},{-10,6}},color={0,0,127}));
  connect(ratFloMinEna.y, maxRatFloMinEna.u)
    annotation (Line(points={{14,0},{28,0}},color={0,0,127}));
  connect(booToRea.y, floDesEqu.u1)
    annotation (Line(points={{-68,0},{-60,0},{-60,-34},{-52,-34}},color={0,0,127}));
  connect(floDes.y, floDesEqu.u2)
    annotation (Line(points={{-68,-60},{-60,-60},{-60,-46},{-52,-46}},color={0,0,127}));
  connect(maxRatFloMinEna.y, floMinSet.u1)
    annotation (Line(points={{52,0},{60,0},{60,6},{68,6}},color={0,0,127}));
  connect(floMinSet.y, VPriSet_flow)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(floDesEqu.y, sumFloDesEna.u)
    annotation (Line(points={{-28,-40},{28,-40}},color={0,0,127}));
  connect(sumFloDesEna.y, floMinSet.u2)
    annotation (Line(points={{52,-40},{60,-40},{60,-6},{68,-6}},color={0,0,127}));
  annotation (
    defaultComponentName="setFloMin",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
The minimum flow setpoint is determined as follows, to provide minimum flow 
through all operating units.
</p>
<ol>
<li>
For the units commanded on in the stage, calculate 
the highest ratio of minimum flow rate to design flow rate.
</li>
<li>
Calculate the minimum flow setpoint as the highest minimum flow ratio 
multiplied by the sum of the design flow rates for the operating equipment.
</li>
</ol>
<h4>Details</h4>
<p>
For plants consisting of identical units, the minimum flow setpoint is
the minimum flow of each unit multiplied by the number of units 
enabled in the stage. 
</p>
<p>
If the units have different minimum flow to design flow ratios, just maintaining 
the sum of the minimum flows will not satisfy the equipment with the highest 
relative minimum flows. 
Note that this also requires that equipment be balanced to distribute flow 
proportional to their design flow.
</p>
</html>"));
end Setpoint;
