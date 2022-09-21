within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlDemandLevel "Controller that outputs the demand level"
  parameter Real k = 2 "Gain for control error";
  parameter Real Ti=120 "Time constant of integrator block";

  Controls.OBC.CDL.Interfaces.RealInput u_s "Set point" annotation (Placement(
        transformation(extent={{-140,30},{-100,70}}), iconTransformation(extent=
           {{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.RealInput u_m "Measurement signal" annotation (
      Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Controls.OBC.CDL.Interfaces.IntegerOutput y "Demand level"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Continuous.PID conPID(
    final k=k,
    final Ti=Ti,
    final yMax=2,
    final yMin=-1,
    reverseActing=false)
                   annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

protected
  Controls.OBC.CDL.Integers.SequenceBinary seqBin(
    nSta=2,
    minStaOn=10,
    h=0.02) annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(p=1)
    "Shift the output signal to 0...3"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=1/3)
    "Convert the signal to 0...1"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(seqBin.y, y)
    annotation (Line(points={{82,0},{120,0}}, color={255,127,0}));
  connect(conPID.u_s, u_s) annotation (Line(points={{-62,0},{-80,0},{-80,50},{
          -120,50}}, color={0,0,127}));
  connect(conPID.u_m, u_m) annotation (Line(points={{-50,-12},{-50,-50},{-120,
          -50}}, color={0,0,127}));
  connect(conPID.y, addPar.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={0,0,127}));
  connect(seqBin.u, gai.y)
    annotation (Line(points={{58,0},{42,0}}, color={0,0,127}));
  connect(gai.u, addPar.y)
    annotation (Line(points={{18,0},{2,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="ctrDemLev",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-154,152},{146,112}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{52,14},{96,-12}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=1)))}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Block that converts a control error into a demand level signal.
This block uses a PI controller to integrate the control error,
and then converts the result into a demand level using
<a href=\\\"modelica://Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels\\\">
Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels</a>.
</p>
<p>
If the control error is negative or a small positive number, then the output signal
indicates that there is no demand.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlDemandLevel;
