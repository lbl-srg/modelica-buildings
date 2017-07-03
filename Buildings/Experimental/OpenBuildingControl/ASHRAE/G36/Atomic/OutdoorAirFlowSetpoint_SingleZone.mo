within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block OutdoorAirFlowSetpoint_SingleZone
  "Find out the minimum outdoor airflow rate setpoint: single zone AHU"

  parameter Modelica.SIunits.VolumeFlowRate outAirPerAre = 3e-4
    "Area outdoor air rate Ra, m3/s per unit area"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer = 2.5e-3
    "People outdoor air rate Rp, m3/s per person"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.Area zonAre = 40
    "Area of each zone"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Boolean occSen = true
    "Indicate if the zones have occupancy sensor, true or false";

  parameter Real occDen(unit="1") = 0.05
    "Default number of person in unit area";

  parameter Real zonDisEffHea(unit="1") = 0.8
    "Zone air distribution effectiveness (heating supply), 
     if no value scheduled";
  parameter Real zonDisEffCoo(unit="1") = 1.0
    "Zone air distribution effectiveness (cooling supply), 
    if no value scheduled";

  CDL.Continuous.Constant breZonAre(k=outAirPerAre*zonAre)
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  CDL.Continuous.Constant breZonPop(k=outAirPerPer*zonAre*occDen)
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  CDL.Interfaces.RealInput occCou(unit="1") "Number of human counts"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
        iconTransformation(extent={{-120,50},{-100,70}})));

  CDL.Continuous.Add breZon "Breathing zone airflow"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));

  CDL.Continuous.Gain gai(k=outAirPerPer) "Outdoor airflow rate per person"
                                             annotation (Placement(transformation(extent={{-80,150},
            {-60,170}})));
  CDL.Logical.Switch swi
    "If there is occupancy sensor, then using the real time occupant; otherwise, using the default occupant "
                            annotation (Placement(transformation(extent={{-40,120},
            {-20,140}})));
  CDL.Logical.Switch swi1
    "Switch between cooling or heating distribution effectiveness"
                             annotation (Placement(transformation(extent={{-20,10},
            {0,30}})));
  CDL.Continuous.Constant disEffHea(k=zonDisEffHea)
    "Zone distribution effectiveness: Heating"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant disEffCoo(k=zonDisEffCoo)
    "Zone distribution effectiveness: Cooling"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  CDL.Interfaces.RealInput uCoo(min=0, max=1, unit="1")
    "Cooling control signal."
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.Division zonOutAirRate
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  CDL.Logical.GreaterThreshold greThr
    "Whether or not the cooling signal is on (greater than 0)"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Continuous.Constant zerOutAir(k=0)
    "Zero required outdoor airflow rate when window open 
    or is not in occupied mode."
    annotation (Placement(transformation(extent={{40,42},{60,62}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.BooleanInput uWindow "Window status, On or Off"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Logical.Switch swi2
    "If window is open or it is not in occupied mode, the required outdoor airflow rate should be zero"
                             annotation (Placement(transformation(extent={{100,90},
            {120,70}})));
  CDL.Logical.Switch swi3
    "If supply fan is off, then outdoor airflow rate should be zero."
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  CDL.Interfaces.RealOutput yVOutMinSet(min=0, unit="m3/s")
    "Effective minimum outdoor airflow setpoint"
    annotation (
      Placement(transformation(extent={{180,40},{220,80}}), iconTransformation(
          extent={{100,-10},{120,10}})));

  CDL.Logical.Constant occSenor(k=occSen) "If there is occupancy sensor"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

equation
  connect(breZonAre.y, breZon.u1)
    annotation (Line(points={{-19,180},{-10,180},{-10,166},{-2,166}},
      color={0,0,127}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{-59,160},{-50,160},{-50,138},{-42,138}},
      color={0,0,127}));
  connect(breZonPop.y, swi.u3)
    annotation (Line(points={{-59,100},{-50,100},{-50,122},{-42,122}},
      color={0,0,127}));
  connect(swi.y, breZon.u2)
    annotation (Line(points={{-19,130},{-10,130},{-10,154},{-2,154}},
      color={0,0,127}));
  connect(disEffCoo.y, swi1.u1)
    annotation (Line(points={{-59,60},{-40,60},{-40,28},{-22,28}},
      color={0,0,127}));
  connect(disEffHea.y, swi1.u3)
    annotation (Line(points={{-59,-10},{-40,-10},{-40,12},{-22,12}},
        color={0,0,127}));
  connect(breZon.y, zonOutAirRate.u1)
    annotation (Line(points={{21,160},{30,160},{30,156},{38,156}},
      color={0,0,127}));
  connect(swi1.y, zonOutAirRate.u2)
    annotation (Line(points={{1,20},{20,20},{20,144},{38,144}},
      color={0,0,127}));
  connect(greThr.y, swi1.u2)
    annotation (Line(points={{-59,20},{-59,20},{-22,20}},
      color={255,0,255}));
  connect(uWindow, swi2.u2)
    annotation (Line(points={{-120,80},{20,80},{98,80}},
      color={255,0,255}));
  connect(zerOutAir.y, swi2.u1)
    annotation (Line(points={{61,52},{80,52},{80,72},{98,72}},
      color={0,0,127}));
  connect(zonOutAirRate.y, swi2.u3)
    annotation (Line(points={{61,150},{80,150},{80,88},{98,88}},
      color={0,0,127}));
  connect(swi.u2, occSenor.y)
    annotation (Line(points={{-42,130},{-79,130}},color={255,0,255}));
  connect(uCoo, greThr.u)
    annotation (Line(points={{-120,20},{-102,20},{-82,20}},
      color={0,0,127}));
  connect(occCou, gai.u)
    annotation (Line(points={{-120,160},{-94,160},{-82,160}},
        color={0,0,127}));
  connect(swi3.y, yVOutMinSet)
    annotation (Line(points={{161,60},{200,60}}, color={0,0,127}));
  connect(zerOutAir.y, swi3.u3)
    annotation (Line(points={{61,52},{138,52}},          color={0,0,127}));
  connect(swi2.y, swi3.u1)
    annotation (Line(points={{121,80},{124,80},{128,80},
          {128,68},{138,68}}, color={0,0,127}));
  connect(uSupFan, swi3.u2)
    annotation (Line(points={{-120,-30},{4,-30},{128,
          -30},{128,60},{138,60}}, color={255,0,255}));
 annotation (
defaultComponentName="outAirSingleZone",
Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,82},{84,-68}},
          lineColor={0,0,0},
          textString="minOATsp"),
        Text(
          extent={{-100,124},{98,102}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{180,200}},
        initialScale=0.1)),
 Documentation(info="<html>      
<p>
This atomic sequence sets the minimum outdoor airflow setpoint. The implementation 
is according to ASHRAE Guidline 36 (G36), PART5.P.4.b, PART5.B.2.b, PART3.1-D.2.a.
</p>   

<h4>Single zone AHU: minimum outdoor airflow setpoint (PART5.P.4.b)</h4>
<ol> 
<li>Calculate the required zone outdoor airflow <code>zonOutAirRate</code> 
as follows:
<ul>
<li>If discharge air temperature at the terminal unit is less than zone space 
temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone space 
temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code></li>
</ul>
</li>

<li>Calculate the area component <code>zonOutAirRateAre</code> of the required 
zone outdoor airflow as follows:
<ul>
<li>If discharge air temperature at the terminal unit is less than zone space 
temperature: <code>zonOutAirRateAre = breZonAre/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone space 
temperature: <code>zonOutAirRateAre = breZonAre/disEffHea</code></li>
</ul>
</li>

<li>While the zone is in Occupied Mode, the minimum outdoor air setpoint 
<code>yVOutMinSet</code> shall be reset based on the zone CO2 control loop 
signal from <code>zonOutAirRateAre</code> at <code>0%</code> signal 
to <code>zonOutAirRate</code> at <code>100%</code> signal.</li>
<li>If the zone has an occupancy sensor, <code>yVOutMinSet</code> shall equal
<code>zonOutAirRateAre</code> when the zone is unpopulated.</li>
<li>If the zone has a window switch, <code>yVOutMinSet</code> shall be zero 
when the window is open.</li>
<li>When the zone is in other than Occupied Mode, <code>yVOutMinSet</code> 
shall be zero.</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorAirFlowSetpoint_SingleZone;
