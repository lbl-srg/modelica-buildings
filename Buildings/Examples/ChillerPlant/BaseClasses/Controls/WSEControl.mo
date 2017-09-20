within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
model WSEControl "Control unit for WSE"
  parameter Modelica.SIunits.TemperatureDifference dTOff = 1
    "Temperature difference to switch WSE off";
  parameter Modelica.SIunits.TemperatureDifference dTW = 1
    "Temperature difference that is added to WSE on guard";
  Modelica.Blocks.Interfaces.RealInput wseCHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "WSE chilled water supply temperature (water entering WSE)" annotation (
      Placement(transformation(extent={{-60,100},{-20,140}}),
        iconTransformation(extent={{-60,100},{-20,140}})));
  Modelica.Blocks.Interfaces.RealOutput y2
    "Control signal for chiller shutoff valve"    annotation (Placement(
        transformation(extent={{180,-50},{200,-30}}),
                                                    iconTransformation(extent={{180,-50},
            {200,-30}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Wet bulb temperature" annotation (Placement(
        transformation(extent={{-60,0},{-20,40}}),    iconTransformation(extent={{-60,0},
            {-20,40}})));
  Modelica.Blocks.Interfaces.RealInput towTApp(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Cooling tower approach"
    annotation (Placement(transformation(extent={{-60,-60},{-20,-20}})));
  Modelica.Blocks.Interfaces.RealInput wseCWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "WSE condenser water supply temperature (water entering WSE)" annotation (
     Placement(transformation(extent={{-60,-138},{-20,-98}}),
        iconTransformation(extent={{-60,-138},{-20,-98}})));
  Modelica.Blocks.Math.BooleanToReal booToRea2
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Modelica.Blocks.Interfaces.RealOutput y1
    "Control signal for WSE shutoff valve"           annotation (Placement(
        transformation(extent={{180,30},{200,50}}),   iconTransformation(extent={{180,30},
            {200,50}})));
  Modelica.StateGraph.InitialStepWithSignal off(
    nOut=1,
    nIn=1) annotation (Placement(transformation(extent={{-2,78},{22,102}})));
  Modelica.StateGraph.Transition T1(
    waitTime=1200,
    condition=wseCHWST > 0.9*TWetBul + towTApp + dTW,
    enableTimer=true)
    annotation (Placement(transformation(extent={{32,72},{68,108}})));
  Modelica.StateGraph.Step  on(nIn=1, nOut=1)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.StateGraph.Transition  T2(
     waitTime=1200,
    condition=wseCHWST < wseCWST + dTOff,
    enableTimer=true)
    annotation (Placement(transformation(extent={{122,72},{158,108}})));
  Modelica.Blocks.Math.BooleanToReal booToRea1(realTrue=0, realFalse=1)
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
equation

  connect(booToRea2.y, y2)
                          annotation (Line(
      points={{161,-40},{190,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.outPort[1], T1.inPort)   annotation (Line(
      points={{22.6,90},{42.8,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T1.outPort, on.inPort[1])    annotation (Line(
      points={{52.7,90},{79,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(on.outPort[1], T2.inPort)    annotation (Line(
      points={{100.5,90},{132.8,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T2.outPort, off.inPort[1])   annotation (Line(
      points={{142.7,90},{168,90},{168,130},{-12,130},{-12,90},{-3.2,90}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(booToRea1.y, y1) annotation (Line(
      points={{161,40},{190,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.active, booToRea1.u)
    annotation (Line(points={{10,76.8},{10,40},{138,40}}, color={255,0,255}));
  connect(off.active, booToRea2.u) annotation (Line(points={{10,76.8},{10,-40},{
          138,-40}}, color={255,0,255}));
  annotation (
    defaultComponentName="wseCon",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-20,-160},{180,180}},
        initialScale=0.04), graphics={
        Rectangle(
          extent={{-20,-160},{180,180}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{232,246},{-88,338}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
This component decides if the WSE is set to on or off.
The WSE is enabled when
</p>
<ol>
<li>The WSE has been disabled for at least 20 minutes, and</li>
<li>
<i>
  T<sub>WSE_CHWST</sub> &gt; 0.9 T<sub>WetBul</sub> + T<sub>TowApp</sub> + T<sub>WSEApp</sub>
</i>
</li>
</ol>
<p>
The WSE is disabled when
</p>
<ol>
<li>The WSE has been enabled for at least 20 minutes, and</li>
<li>
<i>
  T<sub>WSE_CHWRT</sub> &lt; 1 + T<sub>WSE_CWST</sub>
</i>
</li>
</ol>
<p>
where <i>T<sub>WSE_CHWST</sub></i> is the chilled water supply temperature for the WSE,
<i>T<sub>WetBul</sub></i> is the wet bulb temperature, <i>T<sub>TowApp</sub></i> is the cooling tower approach, <i>T<sub>WSEApp</sub></i> is the approach for the WSE, <i>T<sub>WSE_CHWRT</sub></i> is the chilled water return temperature for the WSE, and <i>T<sub>WSE_CWST</sub></i> is the condenser water return temperature for the WSE.
</p>
</html>", revisions="<html>
<ul>
<li>
April 6, 2016, by Michael Wetter:<br/>
Replaced <code>Modelica_StateGraph2</code> with <code>Modelica.StateGraph</code>.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
</li>
<li>
April 1, 2013, by Wangda Zuo:<br/>
Added <code>final</code> attribute to initial state declaration.
This is required for a successful model check in Dymola 2014 using the pedantic check.
</li>
<li>
September 12, 2011, by Wangda Zuo:<br/>
Deleted the first order continuous block and changed the model to use SI units.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added comments, redefined variables names, and merged to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul></html>"),
    Diagram(coordinateSystem(extent={{-20,-160},{180,180}}, preserveAspectRatio=false)));
end WSEControl;
