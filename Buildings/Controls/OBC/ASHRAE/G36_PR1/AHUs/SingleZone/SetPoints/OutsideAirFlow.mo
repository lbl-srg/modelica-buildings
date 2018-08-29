within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints;
block OutsideAirFlow
  "Output the minimum outdoor airflow rate setpoint for systems with a single zone"

  parameter Real outAirPerAre(final unit="m3/(s.m2)") = 3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer = 2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Area AFlo
    "Floor area"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean have_occSen
    "Set to true if zones have occupancy sensor";
  parameter Real occDen(final unit="1/m2") = 0.05
    "Default number of person in unit area";
  parameter Real zonDisEffHea(final unit="1") = 0.8
    "Zone air distribution effectiveness during heating";
  parameter Real zonDisEffCoo(final unit="1") = 1.0
    "Zone air distribution effectiveness during cooling";
  parameter Real uLow(final unit="K",
    quantity="ThermodynamicTemperature") = -0.5
    "If zone space temperature minus supply air temperature is less than uLow,
     then it should use heating supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));
  parameter Real uHig(final unit="K",
    quantity="ThermodynamicTemperature") = 0.5
    "If zone space temperature minus supply air temperature is more than uHig,
     then it should use cooling supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1")
    "Number of occupants"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    quantity="ThermodynamicTemperature") "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    quantity="ThermodynamicTemperature") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
    iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status, true if on, false if off"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinSet_flow(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Add breZon "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=+1, final k2=-1)
    "Zone space temperature minus supply air temperature"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=outAirPerPer)
    "Outdoor airflow rate per person"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch for enabling occupancy sensor input"
    annotation (Placement(transformation(extent={{-60,38},{-40,58}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch between cooling or heating distribution effectiveness"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Division zonOutAirRate
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "If window is open or it is not in occupied mode, the required outdoor
    airflow rate should be zero"
    annotation (Placement(transformation(extent={{80,20},{100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "If supply fan is off, then outdoor airflow rate should be zero."
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=uLow,
    uHigh=uHig,
    pre_y_start=true)
    "Check if cooling or heating air distribution effectiveness should be applied, with 1 degC deadband"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen(
    final k=have_occSen)
    "Boolean constant to indicate if there is occupancy sensor"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOutAir(
    final k=0)
    "Zero required outdoor airflow rate when window open or zone is not in occupied mode"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffHea(
    final k=zonDisEffHea)
    "Zone distribution effectiveness during heating"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffCoo(
    final k=zonDisEffCoo)
    "Zone distribution effectiveness for cooling"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonAre(
    final k=outAirPerAre*AFlo)
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonPop(
    final k=outAirPerPer*AFlo*occDen)
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));

equation
  connect(breZonAre.y, breZon.u1)
    annotation (Line(points={{-39,100},{-30,100},{-30,86},{-22,86}},
      color={0,0,127}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{-139,160},{-70,160},{-70,56},{-62,56}},
      color={0,0,127}));
  connect(breZonPop.y, swi.u3)
    annotation (Line(points={{-79,30},{-70,30},{-70,40},{-62,40}},
      color={0,0,127}));
  connect(swi.y, breZon.u2)
    annotation (Line(points={{-39,48},{-30,48},{-30,74},{-22,74}},
      color={0,0,127}));
  connect(disEffCoo.y, swi1.u1)
    annotation (Line(points={{-79,-20},{-60,-20},{-60,-52},{-42,-52}},
      color={0,0,127}));
  connect(disEffHea.y, swi1.u3)
    annotation (Line(points={{-79,-90},{-60,-90},{-60,-68},{-42,-68}},
      color={0,0,127}));
  connect(breZon.y, zonOutAirRate.u1)
    annotation (Line(points={{1,80},{10,80},{10,36},{18,36}},
      color={0,0,127}));
  connect(swi1.y, zonOutAirRate.u2)
    annotation (Line(points={{-19,-60},{10,-60},{10,24},{18,24}},
      color={0,0,127}));
  connect(uWin, swi2.u2)
    annotation (Line(points={{-220,10},{-190,10},{78,10}}, color={255,0,255}));
  connect(zerOutAir.y, swi2.u1)
    annotation (Line(points={{41,-30},{60,-30},{60,2},{78,2}},
      color={0,0,127}));
  connect(zonOutAirRate.y, swi2.u3)
    annotation (Line(points={{41,30},{60,30},{60,18},{78,18}},
      color={0,0,127}));
  connect(swi.u2, occSen.y)
    annotation (Line(points={{-62,48},{-76,48},{-76,50},{-139,50}},
      color={255,0,255}));
  connect(nOcc, gai.u)
    annotation (Line(points={{-220,160},{-162,160}}, color={0,0,127}));
  connect(swi3.y, VOutMinSet_flow)
    annotation (Line(points={{161,10},{180,10},{180,0},{220,0}}, color={0,0,127}));
  connect(TZon, add2.u1)
    annotation (Line(points={{-220,-40},{-200,-40},{-180,-40},{-180,-54},
      {-162,-54}}, color={0,0,127}));
  connect(TDis, add2.u2)
    annotation (Line(points={{-220,-80},{-180,-80},{-180,-66}, {-162,-66}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-139,-60},{-102,-60},{-102,-60}},
        color={0,0,127}));
  connect(hys.y, swi1.u2)
    annotation (Line(points={{-79,-60},{-42,-60},{-42,-60}},
        color={255,0,255}));
  connect(swi2.y, swi3.u3)
    annotation (Line(points={{101,10},{120,10},{120,2},{138,2}}, color={0,0,127}));
  connect(zerOutAir.y, swi3.u1)
    annotation (Line(points={{41,-30},{110,-30},{110,18},{138,18}}, color={0,0,127}));
  connect(and1.y, not1.u)
    annotation (Line(points={{-39,-120},{-30.5,-120},{-22,-120}}, color={255,0,255}));
  connect(not1.y, swi3.u2)
    annotation (Line(points={{1,-120},{130,-120},{130,10},{138,10}}, color={255,0,255}));
  connect(uSupFan, and1.u1)
    annotation (Line(points={{-220,-120},{-142,-120},{-142,-120},{-62,-120}}, color={255,0,255}));
  connect(intEqu1.y, and1.u2)
    annotation (Line(points={{-119,-150},{-90,-150},{-90,-128},{-62,-128}}, color={255,0,255}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-220,-150},{-142,-150},{-142,-150}}, color={255,127,0}));
  connect(occMod.y, intEqu1.u2)
    annotation (Line(points={{-159,-170},{-150,-170},{-150,-158},{-142,-158}}, color={255,127,0}));
 annotation (
defaultComponentName="outAirSetPoi",
Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-84,78},{92,-72}},
          lineColor={0,0,0},
          textString="VOutMinSet_flow"),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-200,-200},{200,200}},
        initialScale=0.05)),
 Documentation(info="<html>
<p>
This atomic sequence sets the minimum outdoor airflow setpoint for compliance
with the ventilation rate procedure of ASHRAE 62.1-2013. The implementation
is according to ASHRAE Guidline 36 (G36), PART5.P.4.b, PART5.B.2.b, PART3.1-D.2.a.
</p>

<h4>Step 1: Minimum breathing zone outdoor airflow required <code>breZon</code></h4>
<ul>
<li>The area component of the breathing zone outdoor airflow:
<code>breZonAre = AFlo*outAirPerAre</code>.
</li>
<li>The population component of the breathing zone outdoor airflow:
<code>breZonPop = occCou*outAirPerPer</code>.
</li>
</ul>
<p>
The number of occupant <code>occCou</code> could be retrieved
directly from occupancy sensor <code>nOcc</code> if the sensor exists
(<code>have_occSen=true</code>), or using the default occupant density
<code>occDen</code> to find it <code>AFlo*occDen</code>. The occupant
density can be found from Table 6.2.2.1 in ASHRAE Standard 62.1-2013.
</p>

<h4>Step 2: Zone air-distribution effectiveness <code>zonDisEff</code></h4>
<p>
Table 6.2.2.2 in ASHRAE 62.1-2013 lists some typical values for setting the
effectiveness. Depending on difference between zone space temperature
<code>TZon</code> and supply air temperature <code>TDis</code>, Warm-air
effectiveness <code>zonDisEffHea</code> or Cool-air effectiveness
<code>zonDisEffCoo</code> should be applied.
</p>

<h4>Step 3: Minimum required zone outdoor airflow <code>zonOutAirRate</code></h4>
<p>
For each zone in any mode other than occupied mode and for zones that have
window switches and the window is open, <code>zonOutAirRate</code> shall be
zero.
Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code>
shall be calculated as follows:
</p>
<i>If the zone is populated, or if there is no occupancy sensor:</i>
<ul>
<li>If discharge air temperature at the terminal unit is less than or equal to
zone space temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code>.
</li>
<li>
If discharge air temperature at the terminal unit is greater than zone space
temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code>
</li>
</ul>
<i>If the zone has an occupancy sensor and is unpopulated:</i>
<ul>
<li>If discharge air temperature at the terminal unit is less than or equal to
zone space temperature: <code>zonOutAirRate = breZonAre/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone
space temperature: <code>zonOutAirRate = breZonAre/disEffHea</code></li>
</ul>

<p>
For the single zone system, the required minimum outdoor airflow setpoint
<code>VOutMinSet_flow</code> equals to the <code>zonOutAirRate</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 6, 2017, by Jianjun Hu:<br/>
Replaced <code>cooCtrlSig</code> input with <code>TZon</code> and <code>TDis</code>
inputs to check if cool or warm air distribution effectiveness should be applied.
Applied hysteresis to avoid rapid change.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutsideAirFlow;
