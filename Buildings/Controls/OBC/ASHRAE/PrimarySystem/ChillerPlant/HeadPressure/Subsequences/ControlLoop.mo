within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block ControlLoop
  "Sequence to generate head pressure control signal if it is not available from the chiller controller"
  parameter Real minChiLif(
    final min=1e-5,
    final unit="K",
    final quantity="TemperatureDifference") = 10
      "Minimum allowable lift at minimum load for chiller";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
      annotation (Dialog(group="PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreCon(
    final unit="1",
    final min=0,
    final max=1) "Chiller head pressure control loop output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=0,
    final y_reset=0) "Generate head pressure control signal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=1/minChiLif)
    "Normalized by minimum allowable lift at minimum load for chiller"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

equation
  connect(TConWatRet, sub1.u1)
    annotation (Line(points={{-120,-20},{-80,-20},{-80,-14},{-72,-14}},
                                                    color={0,0,127}));
  connect(con.y, conPID.u_s)
    annotation (Line(points={{-18,60},{18,60}}, color={0,0,127}));
  connect(conPID.y, yHeaPreCon)
    annotation (Line(points={{42,60},{60,60},{60,0},{120,0}}, color={0,0,127}));
  connect(sub1.y, gai.u)
    annotation (Line(points={{-48,-20},{-22,-20}}, color={0,0,127}));
  connect(gai.y, conPID.u_m)
    annotation (Line(points={{2,-20},{30,-20},{30,48}}, color={0,0,127}));
  connect(uHeaPreEna, conPID.trigger)
    annotation (Line(points={{-120,20},{24,20},{24,48}}, color={255,0,255}));

  connect(TChiWatSup, sub1.u2) annotation (Line(points={{-120,-80},{-80,-80},{
          -80,-26},{-72,-26}}, color={0,0,127}));
annotation (
  defaultComponentName= "chiHeaPreLoo",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={170,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Line(points={{-90,0},{82,0}},     color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
    Line(origin = {-1.939,-1.816},
        points={{61.939,7.816},{37.939,15.816},{11.939,-80.184},{-29.966,113.485},
              {-65.374,-61.217},{-78.061,-78.184}},
        color = {0,0,127},
        smooth = Smooth.Bezier)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that generates chiller head pressure control loop signal when the signal
is not available from chiller controller,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.10 Head pressure control, part 5.2.10.1 and 5.2.10.2.
</p>
<p>
1. When head pressure control loop is enabled, a reverse acting PID loop shall
maintain the temperature differential between the chiller condenser water
return (condenser leaving) temperature <code>TConWatRet</code> and chilled water supply temperature
<code>TChiWatSup</code> at minimum allowable lift <code>minChiLif</code> (chiller lift
equals to <code>TConWatRet</code> minus <code>TChiWatSup</code>)
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
