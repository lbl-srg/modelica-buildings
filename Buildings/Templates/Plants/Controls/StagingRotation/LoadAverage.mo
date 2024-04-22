within Buildings.Templates.Plants.Controls.StagingRotation;
block LoadAverage
  "Compute the rolling average of the load on a system"
  parameter Real cp_default(
    final min=0,
    final unit="J/(kg.K)")
    "Default specific heat capacity used to compute required capacity";
  parameter Real rho_default(
    final min=0,
    final unit="kg/m3")
    "Default fluid density used to compute required capacity";
  parameter Real dtMea(
    final min=0,
    final unit="s")=300
    "Duration used to compute the moving average of required capacity";
  Buildings.Controls.OBC.CDL.Reals.Subtract delT(y(final unit="K"))
    "Compute ∆T"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs absDelT(y(final unit="K"))
    "Compute absolute value of ∆T"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter capFlo(y(final unit="W/K"),
      final k=rho_default*cp_default)
    "Compute capacity flow rate"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply capReq
    "Compute required capacity"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movAve(delta=dtMea)
    "Compute moving average"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(final unit="K",
      displayUnit="degC") "Return temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(final unit="K",
      displayUnit="degC")
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(final unit="m3/s")
    "Volume flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QReq_flow(final unit="W")
    "Load" annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(delT.y,absDelT. u)
    annotation (Line(points={{-48,0},{-32,0}},      color={0,0,127}));
  connect(absDelT.y,capReq. u1)
    annotation (Line(points={{-8,0},{0,0},{0,6},{8,6}},                   color={0,0,127}));
  connect(capFlo.y,capReq. u2)
    annotation (Line(points={{-8,-40},{0,-40},{0,-6},{8,-6}},
      color={0,0,127}));
  connect(TSupSet,delT. u1) annotation (Line(points={{-120,40},{-80,40},{-80,6},
          {-72,6}},              color={0,0,127}));
  connect(TRet,delT. u2) annotation (Line(points={{-120,0},{-80,0},{-80,-6},{-72,
          -6}},             color={0,0,127}));
  connect(V_flow,capFlo. u) annotation (Line(points={{-120,-40},{-32,-40}},
                                   color={0,0,127}));
  connect(capReq.y,movAve. u)
    annotation (Line(points={{32,0},{48,0}},       color={0,0,127}));
  connect(movAve.y, QReq_flow)
    annotation (Line(points={{72,0},{88,0},{88,0},{120,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="loa",
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
    Documentation(info="<html>
<p>
This block computes the load on a system based on the return temperature, 
active supply temperature setpoint and measured flow through the associated 
circuit flow meter.
The output load <code>QReq_flow</code> is the rolling average over a period 
of <code>dtMea</code>.
It is always positive by convention.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end LoadAverage;
