within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed;
block ControlProcessModel
  "Identify the parameters of a first-order time delayed model for the control process"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output";
  parameter Real deaBan(min=0) = 0.5
    "Deadband for holding the output value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the On period"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the Off period"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Normalized time delay"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Output of a relay controller"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triSta
    "Relay tuning status, true if the tuning starts"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={-74,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triEnd
    "Relay tuning status, true if the tuning ends"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={80,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Gain"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1)
    "Block that calculates the difference between 1 and the normalized time delay"
    annotation (Placement(transformation(extent={{-8,-70},{12,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "The output of samtau divided by that of addPar"
    annotation (Placement(transformation(extent={{12,-30},{32,-10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain gain(
    final yHig=yHig,
    final yLow=yLow)
    "Block that calculates the gain"
    annotation (Placement(transformation(extent={{-84,10},{-64,30}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.TimeConstantDelay
    timConDel(
    final yHig=yHig,
    final yLow=yLow,
    deaBan=deaBan)
    "Block that calculate the time constant and the time delay"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(
    final y_start=1)
    "Block that samples the gain when the tuning period ends"
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samL(
    final y_start=1)
    "Block that samples the time delay when the tuning period ends"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samtOn(
    final y_start=1)
    "Block that samples the length of the on period when the tuning period ends"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samT(
    final y_start=1)
    "Block that samples the time constant when the tuning period ends"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samtau(final y_start=0.5)
    "Block that samples the normalized time delay when the tuning period ends"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=-1)
    "Product of the normalized time delay and -1"
    annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));

equation
  connect(gain.u, u) annotation (Line(points={{-86,28},{-88,28},{-88,80},{-120,
          80}},
        color={0,0,127}));
  connect(gain.tOn, tOn) annotation (Line(points={{-86,20},{-94,20},{-94,40},{
          -120,40}}, color={0,0,127}));
  connect(gain.tOff, tOff) annotation (Line(points={{-86,12},{-94,12},{-94,-20},
          {-120,-20}}, color={0,0,127}));
  connect(gain.triSta, triSta) annotation (Line(points={{-74,8},{-74,-120}},
         color={255,0,255}));
  connect(timConDel.T, samT.u)
    annotation (Line(points={{22,26},{60,26},{60,20},{68,20}},
         color={0,0,127}));
  connect(samT.y, T)
    annotation (Line(points={{92,20},{120,20}},
         color={0,0,127}));
  connect(samT.trigger, triEnd) annotation (Line(points={{80,8},{80,-120}},
         color={255,0,255}));
  connect(L, samL.y)
    annotation (Line(points={{120,-60},{72,-60}}, color={0,0,127}));
  connect(samL.u, timConDel.L) annotation (Line(points={{48,-60},{44,-60},{44,14},
          {22,14}}, color={0,0,127}));
  connect(samL.trigger, triEnd) annotation (Line(points={{60,-72},{60,-90},{80,
          -90},{80,-120}},color={255,0,255}));
  connect(samk.y, timConDel.k)
    annotation (Line(points={{-32,20},{-2,20}},
         color={0,0,127}));
  connect(samk.trigger, triEnd) annotation (Line(points={{-44,8},{-44,-90},{80,
          -90},{80,-120}}, color={255,0,255}));
  connect(gain.k, samk.u)
    annotacolor={0,0,127}));
  connect(samk.y, k) annotation (Line(points={{-32,20},{-20,20},{-20,70},{120,
          70}},
        color={0,0,127}));
  connect(timConDel.tOn, samtOn.y) annotation (Line(points={{-2,26},{-28,26},{
          -28,60},{-48,60}},color={0,0,127}));
  connect(samtOn.u, tOn)
    annotation (Line(points={{-72,60},{-94,60},{-94,40},{-120,40}},
        color={0,0,127}));
  connect(samtOn.trigger, triEnd) annotation (Line(points={{-60,48},{-60,-20},{
          -44,-20},{-44,-90},{80,-90},{80,-120}},
         color={255,0,255}));
  connect(gai.y, addPar.u)
    annotation (Line(points={{-14,-60},{-10,-60}}, color={0,0,127}));
  connect(tau, samtau.u)
    annotation (Line(points={{-120,-60},{-72,-60}}, color={0,0,127}));
  connect(samtau.y, gai.u)
    annotation (Line(points={{-48,-60},{-38,-60}}, color={0,0,127}));
  connect(samtau.y, div.u1) annotation (Line(points={{-48,-60},{-40,-60},{-40,
          -14},{10,-14}}, color={0,0,127}));
  connect(triEnd, samtau.trigger) annotation (Line(points={{80,-120},{80,-90},{
          -60,-90},{-60,-72}}, color={255,0,255}));
  connect(addPar.y, div.u2) annotation (Line(points={{14,-60},{20,-60},{20,-40},
          {6,-40},{6,-26},{10,-26}}, color={0,0,127}));
  connect(div.y, timConDel.ratioLT) annotation (Line(points={{34,-20},{36,-20},
          {36,0},{-12,0},{-12,14},{-2,14}}, color={0,0,127}));
  annotation (
        defaultComponentName = "conProMod",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Polygon(
          points={{-68,76},{-76,54},{-60,54},{-68,76}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,-74},{58,-66},{58,-82},{80,-74}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-68,54},{-68,-94}}, color={28,108,200}),
        Line(points={{58,-74},{-90,-74}}, color={28,108,200}),
        Line(points={{-52,-74},{-46,-48},{-26,-14},{0,10},{28,28},{48,34},{62,
              34}}, color={28,108,200}),
        Line(points={{-58,36},{82,36}}, color={28,108,200},
          pattern=LinePattern.Dash)}),
                                  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the model parameters of a first-order time delayed model.
Specifically, it employs <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain</a> and <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.TimeConstantDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.TimeConstantDelay</a>
to identify the gain and the time constant/the time delay, respectively.</p>
<p>This block is inactive by default and is active once the tuning period starts, i.e., <code>triSta</code> becomes true;
It then calculates the model parameters at the time when the tuning period ends, i.e., <code>triEnd</code> becomes true.
</p>
<p>
Refer to <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a> for detailed explanation of the parameters <code>yHig</code>, <code>yLow</code>, and <code>deaBan</code>.
</p>
</html>"));
end ControlProcessModel;
