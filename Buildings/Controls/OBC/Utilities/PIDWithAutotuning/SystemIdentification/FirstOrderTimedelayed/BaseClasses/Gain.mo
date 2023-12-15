within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses;
block Gain "Identify the gain of a first order time delayed model"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output (assuming the reference output is 0)";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output (assuming the reference output is 0)";
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Relay controller output, (measurement - setpoint)"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the on period"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the off period"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
    iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triSta
    "Relay tuning status, true if the tuning starts"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Gain"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Add Iu
    "Integral of the relay output"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset Iy(
    final k=1, final y_start=1E-3)
    "Integral of the process output"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant refRelOut(
    final k=0) "Reference value of the relay control output"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide divIyIu "Calculate the gain"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(final p=1E-3)
    "Block that avoids a divide-by-zero error"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiOnyHig(
    final k=yHig)
    "Product of tOn and yHig"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiOffyLow(
    final k=-yLow)
    "Product of tOff and yLow"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(refRelOut.y, Iy.y_reset_in) annotation (Line(points={{-38,40},{-20,40},
          {-20,62},{-12,62}}, color={0,0,127}));
  connect(Iy.trigger, triSta) annotation (Line(points={{0,58},{0,-120}},
          color={255,0,255}));
  connect(divIyIu.u1, Iy.y) annotation (Line(points={{58,6},{20,6},{20,70},{12,
          70}}, color={0,0,127}));
  connect(Iu.y, addPar.u) annotation (Line(points={{-18,-40},{18,-40}},color={0,0,127}));
  connect(addPar.y, divIyIu.u2) annotation (Line(points={{42,-40},{50,-40},{50,
          -6},{58,-6}}, color={0,0,127}));
  connect(gaiOnyHig.u, tOn) annotation (Line(points={{-82,-10},{-120,-10}},
          color={0,0,127}));
  connect(gaiOnyHig.y, Iu.u1) annotation (Line(points={{-58,-10},{-50,-10},{-50,
          -34},{-42,-34}}, color={0,0,127}));
  connect(gaiOffyLow.u, tOff)
    annotation (Line(points={{-82,-80},{-120,-80}}, color={0,0,127}));
  connect(gaiOffyLow.y, Iu.u2) annotation (Line(points={{-58,-80},{-50,-80},{-50,
          -46},{-42,-46}}, color={0,0,127}));
  connect(divIyIu.y, k)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(u, Iy.u)
    annotation (Line(points={{-120,70},{-12,70}}, color={0,0,127}));
  annotation (
        defaultComponentName = "gai",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the gain of a first-order time delayed model.</p>
<h4>Main equations</h4>
<p align=\"center\" style=\"font-style:italic;\">
k = I<sub>y</sub>/I<sub>u</sub>,
</p>
<p>
where <i>I<sub>y</sub></i> and <i>I<sub>u</sub></i> are the integral of the process
output and the integral of the relay output, respectively.
</p>
<p><i>I<sub>y</sub></i> is calculated by </p>
<p>I<sub>y</sub> = &int; -u(t) dt;</p>
<p>where <i>u</i> is the input difference of a relay controller, see details in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>
</p>
<p><i>I<sub>u</sub></i> is calculated by </p>
<p align=\"center\" style=\"font-style:italic;\">
I<sub>u</sub> = t<sub>on</sub> (y<sub>hig</sub> - y<sub>ref</sub>)+ t<sub>off</sub>(-y<sub>low</sub> - y<sub>ref</sub>),
</p>
<p>
where <i>y<sub>hig</sub></i> and <i>y<sub>low</sub></i> are the higher value
and the lower value of the relay control output, respectively.
<i>y<sub>ref</sub></i> is the reference value of the relay output.
<i>t<sub>on</sub></i> and <i>t<sub>off</sub></i> are the length of the on
period and the off period, respectively.
</p>
<p>
During an On period, the relay switch signal becomes <code>true</code>.
During an Off period, the relay switch signal becomes <code>false</code>.
</p>
<h4>References</h4>
<p>Josefin Berner (2017).
\"Automatic Controller Tuning using Relay-based Model Identification\".
Department of Automatic Control, Lund Institute of Technology, Lund University. </p>
</html>"));
end Gain;
