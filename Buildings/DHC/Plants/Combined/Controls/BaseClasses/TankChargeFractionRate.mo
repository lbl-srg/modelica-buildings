within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block TankChargeFractionRate
  "Rate of change of the tank charge fraction"
  parameter Real timPer[5](
    final quantity=fill("Time",5),
    final unit=fill("s",5))={10,30,120,240,360} * 60
    "Time periods";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChaFra(
    final unit="1")
    "Tank charge fraction"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nTimPer](
    final unit=fill("1/h",nTimPer))
    "Tank charge fraction"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.DHC.Plants.Combined.Controls.BaseClasses.Delay del[nTimPer](final
      delayTime=timPer)
    "Delay charge fractions"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nTimPer)
    "Replicate input"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub[nTimPer]
    "Find difference"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nTimPer](
    final k=timPer)
    "Time periods"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nTimPer](
    final k=fill(3600, nTimPer)) "Gain factor"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1[nTimPer]
    "Find the fraction rates"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  parameter Integer nTimPer=size(timPer,1)
    "Number of time periods";

equation
  connect(uChaFra, reaScaRep.u)
    annotation (Line(points={{-120,40},{-82,40}}, color={0,0,127}));
  connect(reaScaRep.y, sub.u1) annotation (Line(points={{-58,40},{-50,40},{-50,46},
          {-2,46}}, color={0,0,127}));
  connect(del.y, sub.u2) annotation (Line(points={{-18,20},{-10,20},{-10,34},{-2,
          34}}, color={0,0,127}));
  connect(reaScaRep.y, del.u) annotation (Line(points={{-58,40},{-50,40},{-50,20},
          {-42,20}}, color={0,0,127}));
  connect(sub.y, gai.u)
    annotation (Line(points={{22,40},{38,40}}, color={0,0,127}));
  connect(con.y, div1.u2) annotation (Line(points={{22,-20},{40,-20},{40,-6},{58,
          -6}}, color={0,0,127}));
  connect(gai.y, div1.u1) annotation (Line(points={{62,40},{70,40},{70,20},{50,20},
          {50,6},{58,6}}, color={0,0,127}));
  connect(div1.y, y)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));

annotation (defaultComponentName="tanChaFraRat",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
The rate of change of the tank charge fraction <code>y</code> is computed
over several time periods (<i>10</i>, <i>30</i>, <i>120</i>, <i>240</i>
and <i>360&nbsp;</i>min) as:
<i>uChaFra(&Delta;t) = (uChaFra(t) - uChaFra(t - &Delta;t)) / &Delta;t * 3600</i>,
where <i>&Delta;t</i> is the time period in seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TankChargeFractionRate;
