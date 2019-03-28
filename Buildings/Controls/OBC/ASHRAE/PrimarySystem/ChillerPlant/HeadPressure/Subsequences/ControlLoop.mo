within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block ControlLoop
  "Sequence to generate head pressure control signal if it is not available from the chiller controller"

  parameter Modelica.SIunits.TemperatureDifference minChiLif
    "Minimum allowable lift at minimum load for chiller";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreCon(
    final unit="1",
    final min=0,
    final max=1) "Chiller head pressure control loop output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=0,
    final reverseAction=true,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0) "Generate head pressure control signal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=minChiLif)
    "Minimum allowable lift at minimum load for chiller"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(TConWatRet, feedback.u1)
    annotation (Line(points={{-120,-20},{-72,-20}}, color={0,0,127}));
  connect(TChiWatSup, feedback.u2)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,-32}}, color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{-19,60},{18,60}}, color={0,0,127}));
  connect(feedback.y, conPID.u_m)
    annotation (Line(points={{-49,-20},{30,-20},{30,48}}, color={0,0,127}));
  connect(uHeaPreEna, not1.u)
    annotation (Line(points={{-120,20},{-42,20}}, color={255,0,255}));
  connect(not1.y, conPID.trigger)
    annotation (Line(points={{-19,20},{22,20},{22,48}}, color={255,0,255}));
  connect(conPID.y, yHeaPreCon)
    annotation (Line(points={{41,60},{60,60},{60,0},{110,0}}, color={0,0,127}));

annotation (
  defaultComponentName= "chiHeaPreLoo",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={170,255,255},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={170,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that generates chiller head pressure control loop signal when the signal 
is not available from chiller controller, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.10 Head pressure control, part 5.2.10.1 and 5.2.10.2.
</p>
<p>
1. When head pressure control loop is enabled, reverse acting PID loop shall 
maintain the temperature differential between the chiller condenser water 
return temperature <code>TConWatRet</code> and chilled water supply temperature 
<code>TChiWatSup</code> at minimum allowable lift <code>minChiLif</code>.
</p>
<p>
2. Each operating chiller shall have its own head pressure control loop.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 30, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlLoop;
