within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block OutdoorAirFlowSetpoint_SingleZone
  "Output the minimum outdoor airflow rate setpoint for systems with a single zone"

  parameter Real outAirPerAre(final unit="m3/(s.m2)") = 3e-4
    "Area outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer = 2.5e-3
    "People outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Area zonAre
    "Area of each zone"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean occSen = true
    "Set to true if zones have occupancy sensor";
  parameter Real occDen(unit="1") = 0.05
    "Default number of person in unit area";
  parameter Real zonDisEffHea(unit="1") = 0.8
    "Zone air distribution effectiveness during heating";
  parameter Real zonDisEffCoo(unit="1") = 1.0
    "Zone air distribution effectiveness during cooling";

  CDL.Interfaces.RealInput nOcc(final unit="1") "Number of occupants"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,140},{-200,180}})));

  CDL.Interfaces.RealInput cooCtrSig(
    min=0,
    max=1,
    final unit="1") "Cooling control signal"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-240,60},{-200,100}})));
  CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status, true if on, false if off"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
      iconTransformation(extent={{-240,-180},{-200,-140}})));
  CDL.Interfaces.BooleanInput uWindow
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
      iconTransformation(extent={{-240,-100},{-200,-60}})));
  CDL.Interfaces.RealOutput VOutMinSet_flow(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{200,-20},{240,20}})));

  CDL.Continuous.Add breZon "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  CDL.Continuous.Gain gai(final k=outAirPerPer)
    "Outdoor airflow rate per person"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  CDL.Logical.Switch swi
    "Switch for enabling occupancy sensor input"
    annotation (Placement(transformation(extent={{-60,38},{-40,58}})));
  CDL.Logical.Switch swi1
    "Switch between cooling or heating distribution effectiveness"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  CDL.Continuous.Division zonOutAirRate
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Logical.GreaterThreshold greThr
    "Check whether or not the cooling signal is on"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  CDL.Logical.Switch swi2
    "If window is open or it is not in occupied mode, the required outdoor 
    airflow rate should be zero"
    annotation (Placement(transformation(extent={{80,20},{100,0}})));
  CDL.Logical.Switch swi3
    "If supply fan is off, then outdoor airflow rate should be zero."
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

protected
  CDL.Logical.Constant occSenor(final k=occSen) "If there is occupancy sensor"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  CDL.Continuous.Constant zerOutAir(final k=0)
    "Zero required outdoor airflow rate when window open or zone is not in occupied mode"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Continuous.Constant disEffHea(final k=zonDisEffHea)
    "Zone distribution effectiveness during heating"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  CDL.Continuous.Constant disEffCoo(final k=zonDisEffCoo)
    "Zone distribution effectiveness for cooling"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  CDL.Continuous.Constant breZonAre(final k=outAirPerAre*zonAre)
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  CDL.Continuous.Constant breZonPop(final k=outAirPerPer*zonAre*occDen)
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

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
  connect(greThr.y, swi1.u2)
    annotation (Line(points={{-79,-60},{-42,-60}},
      color={255,0,255}));
  connect(uWindow, swi2.u2)
    annotation (Line(points={{-220,-60},{-190,-60},{-190,10},{78,10}},
      color={255,0,255}));
  connect(zerOutAir.y, swi2.u1)
    annotation (Line(points={{41,-30},{60,-30},{60,2},{78,2}},
      color={0,0,127}));
  connect(zonOutAirRate.y, swi2.u3)
    annotation (Line(points={{41,30},{60,30},{60,18},{78,18}},
      color={0,0,127}));
  connect(swi.u2, occSenor.y)
    annotation (Line(points={{-62,48},{-76,48},{-76,50},{-139,50}},
                                                  color={255,0,255}));
  connect(cooCtrSig, greThr.u)
    annotation (Line(points={{-220,80},{-180,80},{-180,-60},{-102,-60}},
                                                            color={0,0,127}));
  connect(nOcc, gai.u) annotation (Line(points={{-220,160},{-162,160}},
        color={0,0,127}));
  connect(swi3.y, VOutMinSet_flow)
    annotation (Line(points={{161,0},{220,0}},   color={0,0,127}));
  connect(zerOutAir.y, swi3.u3)
    annotation (Line(points={{41,-30},{128,-30},{128,-8},{138,-8}},
                                                color={0,0,127}));
  connect(swi2.y, swi3.u1)
    annotation (Line(points={{101,10},{108,10},{108,8},{138,8}},
                          color={0,0,127}));
  connect(uSupFan, swi3.u2)
    annotation (Line(points={{-220,-160},{120,-160},{120,0},{138,0}},
      color={255,0,255}));
 annotation (
defaultComponentName="OutAirSetPoi",
Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}},
        initialScale=0.05),
     graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid), Text(
          extent={{-142,116},{146,-96}},
          lineColor={0,0,0},
          textString="minOATsp"),
        Text(
          extent={{-102,234},{96,212}},
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

<ol> 
<li>Calculate the required zone outdoor airflow <code>zonOutAirRate</code> 
as follows:
<ul>
<li>If discharge air temperature at the terminal unit is less than zone space 
temperature, then <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code>.
</li>
<li>If discharge air temperature at the terminal unit is greater than zone space 
temperature, then <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code>.
</li>
</ul>
</li>

<li>Calculate the area component <code>zonOutAirRateAre</code> of the required 
zone outdoor airflow as follows:
<ul>
<li>If discharge air temperature at the terminal unit is less than zone space 
temperature, then <code>zonOutAirRateAre = breZonAre/disEffCoo</code>.
</li>
<li>If discharge air temperature at the terminal unit is greater than zone space 
temperature, then <code>zonOutAirRateAre = breZonAre/disEffHea</code>.
</li>
</ul>
</li>

<li>While the zone is in Occupied Mode, the minimum outdoor air setpoint 
<code>yVVOutMinSet_flow</code> shall be reset based on the zone CO2 control loop 
signal from <code>zonOutAirRateAre</code> at <code>0%</code> signal 
to <code>zonOutAirRate</code> at <code>100%</code> signal.</li>
<li>If the zone has an occupancy sensor, <code>yVVOutMinSet_flow</code> shall equal
<code>zonOutAirRateAre</code> when the zone is unpopulated.</li>
<li>If the zone has a window switch, <code>yVVOutMinSet_flow</code> shall be zero 
when the window is open.</li>
<li>When the zone is in other than Occupied Mode, <code>yVVOutMinSet_flow</code> 
shall be zero.</li>
</ol>
<h4>References</h4>
<p>
fixme: It is not clear what BSR below stands for.
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC 
systems</i>. First Public Review Draft (June 2016)</a>
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorAirFlowSetpoint_SingleZone;
