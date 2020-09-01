within Buildings.Examples.VAVReheat.Controls;
block EconomizerTemperatureControl
  "Controller for economizer mixed air temperature"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Boolean have_reset = false
    "Set to true to use an input signal for controller reset";
  Buildings.Controls.Continuous.LimPID con(
    k=k,
    Ti=Ti,
    yMax=0.995,
    yMin=0.005,
    Td=60,
    final reset=if have_reset then Buildings.Types.Reset.Parameter else
      Buildings.Types.Reset.Disabled)
    "Controller for mixed air temperature"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti "Time constant of integrator block";
  Modelica.Blocks.Logical.Switch swi1
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Logical.Switch swi2
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRes if have_reset
    "Signal for controller reset"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
       iconTransformation(extent={{-180,40},{-100,120}})));
  Modelica.Blocks.Interfaces.RealOutput yOA
    "Control signal for outside air damper"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealInput TRet "Return air temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TOut "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TMix "Mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TMixSet
    "Setpoint for mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Logical.Hysteresis hysConGai(uLow=-0.1, uHigh=0.1)
    "Hysteresis for control gain"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
equation
  connect(swi1.y, con.u_s)    annotation (Line(
      points={{21,6.10623e-16},{30,0},{40,1.27676e-15},{40,6.66134e-16},{58,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi2.y, con.u_m)    annotation (Line(
      points={{21,-40},{70,-40},{70,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, yOA)    annotation (Line(
      points={{81,6.10623e-16},{90.5,6.10623e-16},{90.5,0},{120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi1.u1, TMix) annotation (Line(
      points={{-2,8},{-80,8},{-80,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi2.u3, TMix) annotation (Line(
      points={{-2,-48},{-80,-48},{-80,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi1.u3, TMixSet) annotation (Line(
      points={{-2,-8},{-60,-8},{-60,-80},{-120,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi2.u1, TMixSet) annotation (Line(
      points={{-2,-32},{-60,-32},{-60,-80},{-120,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.u1, TRet) annotation (Line(points={{-68,60},{-68,60},{-88,60},
          {-88,40},{-120,40}}, color={0,0,127}));
  connect(TOut, feedback.u2)
    annotation (Line(points={{-120,0},{-60,0},{-60,52}},   color={0,0,127}));
  connect(feedback.y, hysConGai.u) annotation (Line(points={{-51,60},{-48,60},{
          -46,60},{-42,60}}, color={0,0,127}));
  connect(hysConGai.y, swi2.u2) annotation (Line(points={{-19,60},{-12,60},{-12,
          -40},{-2,-40}}, color={255,0,255}));
  connect(hysConGai.y, swi1.u2) annotation (Line(points={{-19,60},{-12,60},{-12,
          0},{-2,0}}, color={255,0,255}));
  connect(uRes, con.trigger) annotation (Line(points={{-120,80},{40,80},{40,-20},
          {62,-20},{62,-12}}, color={255,0,255}));
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-92,78},{-66,50}},
          lineColor={0,0,127},
          textString="TRet"),
        Text(
          extent={{-88,34},{-62,6}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-86,-6},{-60,-34}},
          lineColor={0,0,127},
          textString="TMix"),
        Text(
          extent={{-84,-46},{-58,-74}},
          lineColor={0,0,127},
          textString="TMixSet"),
        Text(
          extent={{64,14},{90,-14}},
          lineColor={0,0,127},
          textString="yOA")}), Documentation(info="<html>
<p>
This controller outputs the control signal for the outside
air damper in order to regulate the mixed air temperature
<code>TMix</code>.
</p>
<h4>Implementation</h4>
<p>
If the control error <i>T<sub>mix,set</sub> - T<sub>mix</sub> &lt; 0</i>,
then more outside air is needed provided that <i>T<sub>out</sub> &lt; T<sub>ret</sub></i>,
where
<i>T<sub>out</sub></i> is the outside air temperature and
<i>T<sub>ret</sub></i> is the return air temperature.
However, if <i>T<sub>out</sub> &ge; T<sub>ret</sub></i>,
then less outside air is needed.
Hence, the control gain need to switch sign depending on this difference.
This is accomplished by taking the difference between these signals,
and then switching the input of the controller.
A hysteresis is used to avoid chattering, for example if
<code>TRet</code> has numerical noise in the simulation, or
measurement error in a real application.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Added optional reset signal.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
April 1, 2016, by Michael Wetter:<br/>
Added hysteresis to avoid too many events that stall the simulation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/502\">#502</a>.
</li>
<li>
March 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerTemperatureControl;
