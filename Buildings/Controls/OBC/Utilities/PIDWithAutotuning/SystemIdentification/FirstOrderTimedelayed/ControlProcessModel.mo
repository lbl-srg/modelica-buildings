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
    "Length for the on period"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the off period"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Normalized time delay"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Output of a relay controller"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triSta
    "Relay tuning status, true if the tuning starts"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={-110,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triEnd
    "Relay tuning status, true if the tuning ends"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90, origin={130,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Gain"
    annotation (Placement(transformation(extent={{160,50},{200,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
protected
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1)
    "Block that calculates the difference between 1 and the normalized time delay"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div
    "The output of samtau divided by that of addPar"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain gain(
    final yHig=yHig,
    final yLow=yLow)
    "Block that calculates the gain"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.TimeConstantDelay
    timConDel(
    final yHig=yHig,
    final yLow=yLow,
    deaBan=deaBan)
    "Block that calculate the time constant and the time delay"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(
    final y_start=1)
    "Block that samples the gain when the tuning period ends"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samL(
    final y_start=1)
    "Block that samples the time delay when the tuning period ends"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samtOn(
    final y_start=1)
    "Block that samples the length of the on period when the tuning period ends"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samT(
    final y_start=1)
    "Block that samples the time constant when the tuning period ends"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samtau(
    final y_start=0.5)
    "Block that samples the normalized time delay when the tuning period ends"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=-1)
    "Product of the normalized time delay and -1"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(gain.u, u) annotation (Line(points={{-122,28},{-140,28},{-140,80},{-180,
          80}},  color={0,0,127}));
  connect(gain.tOn, tOn) annotation (Line(points={{-122,20},{-150,20},{-150,40},
          {-180,40}},color={0,0,127}));
  connect(gain.tOff, tOff) annotation (Line(points={{-122,12},{-150,12},{-150,-20},
          {-180,-20}}, color={0,0,127}));
  connect(gain.triSta, triSta) annotation (Line(points={{-110,8},{-110,-120}},
         color={255,0,255}));
  connect(timConDel.T, samT.u)
    annotation (Line(points={{82,26},{100,26},{100,20},{118,20}}, color={0,0,127}));
  connect(samT.y, T)
    annotation (Line(points={{142,20},{180,20}}, color={0,0,127}));
  connect(samT.trigger, triEnd) annotation (Line(points={{130,8},{130,-120}},
         color={255,0,255}));
  connect(L, samL.y)
    annotation (Line(points={{180,-60},{122,-60}},color={0,0,127}));
  connect(samL.u, timConDel.L) annotation (Line(points={{98,-60},{90,-60},{90,14},
          {82,14}}, color={0,0,127}));
  connect(samL.trigger, triEnd) annotation (Line(points={{110,-72},{110,-90},{130,
          -90},{130,-120}},  color={255,0,255}));
  connect(samk.y, timConDel.k)
    annotation (Line(points={{-38,20},{58,20}},
         color={0,0,127}));
  connect(samk.trigger, triEnd) annotation (Line(points={{-50,8},{-50,-90},{130,
          -90},{130,-120}},color={255,0,255}));
  connect(samk.y, k) annotation (Line(points={{-38,20},{40,20},{40,70},{180,70}},
                color={0,0,127}));
  connect(timConDel.tOn, samtOn.y) annotation (Line(points={{58,26},{20,26},{20,
          60},{2,60}},  color={0,0,127}));
  connect(samtOn.u, tOn)
    annotation (Line(points={{-22,60},{-150,60},{-150,40},{-180,40}},
        color={0,0,127}));
  connect(samtOn.trigger, triEnd) annotation (Line(points={{-10,48},{-10,-90},{130,
          -90},{130,-120}}, color={255,0,255}));
  connect(gai.y, addPar.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(tau, samtau.u)
    annotation (Line(points={{-180,-60},{-142,-60}},color={0,0,127}));
  connect(samtau.y, gai.u)
    annotation (Line(points={{-118,-60},{-82,-60}},color={0,0,127}));
  connect(samtau.y, div.u1) annotation (Line(points={{-118,-60},{-100,-60},{-100,
          -14},{18,-14}}, color={0,0,127}));
  connect(triEnd, samtau.trigger) annotation (Line(points={{130,-120},{130,-90},
          {-130,-90},{-130,-72}}, color={255,0,255}));
  connect(addPar.y, div.u2) annotation (Line(points={{-18,-60},{0,-60},{0,-26},{
          18,-26}}, color={0,0,127}));
  connect(div.y, timConDel.rat) annotation (Line(points={{42,-20},{50,-20},{50,14},
          {58,14}}, color={0,0,127}));
  connect(gain.k, samk.u)
    annotation (Line(points={{-98,20},{-62,20}}, color={0,0,127}));
annotation (
        defaultComponentName = "conProMod",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                       graphics={
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the model parameters of a first-order time delayed model.
Specifically, it employs
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.Gain</a>
and
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.TimeConstantDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses.TimeConstantDelay</a>
to identify the gain, the time constant and the time delay, respectively.
</p>
<p>
The calculations are disabled by default. They will be enabled once the tuning period starts,
i.e., <code>triSta</code> becomes <code>true</code>.
It then calculates the model parameters at the time when the tuning period ends,
i.e., <code>triEnd</code> becomes <code>true</code>.
</p>
<p>
Refer to <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a> for detailed explanation
of the parameters <code>yHig</code>, <code>yLow</code>, and <code>deaBan</code>.
</p>
</html>"));
end ControlProcessModel;
