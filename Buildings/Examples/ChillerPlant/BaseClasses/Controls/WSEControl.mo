within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
model WSEControl "Control unit for WSE"
  parameter Modelica.SIunits.TemperatureDifference dTOff = 1
    "Temperature difference to switch WSE off";
  parameter Modelica.SIunits.TemperatureDifference dTW = 1
    "Temperature difference that is added to WSE on guard";
  Modelica.Blocks.Interfaces.RealInput wseCHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="deg")
    "WSE chilled water supply temperature (water entering WSE)" annotation (
      Placement(transformation(extent={{-60,160},{-20,200}}),
        iconTransformation(extent={{-60,160},{-20,200}})));
  Modelica.Blocks.Interfaces.RealOutput y2
    "Control signal for chiller shutoff valve"    annotation (Placement(
        transformation(extent={{180,-10},{200,10}}),iconTransformation(extent={{180,-10},
            {200,10}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="deg") "Wet bulb temperature" annotation (Placement(
        transformation(extent={{-60,60},{-20,100}}),  iconTransformation(extent={{-60,60},
            {-20,100}})));
  Modelica.Blocks.Interfaces.RealInput towTApp(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="deg") "Cooling tower approach"
    annotation (Placement(transformation(extent={{-60,0},{-20,40}})));
  Modelica.Blocks.Interfaces.RealInput wseCWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="deg")
    "WSE condenser water supply temperature (water entering WSE)" annotation (
     Placement(transformation(extent={{-60,-78},{-20,-38}}),
        iconTransformation(extent={{-60,-78},{-20,-38}})));
  Modelica.Blocks.Math.BooleanToReal booToRea2
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Modelica.Blocks.Interfaces.RealOutput y1
    "Control signal for WSE shutoff valve"           annotation (Placement(
        transformation(extent={{180,130},{200,150}}), iconTransformation(extent={{180,150},
            {200,170}})));
  Modelica_StateGraph2.Step off(
    use_activePort=true,
    nOut=1,
    nIn=1,
    final initialStep=true)
           annotation (Placement(transformation(extent={{30,172},{48,190}})));
  Modelica_StateGraph2.Transition T1(delayedTransition=true, waitTime=1200,
    use_conditionPort=false,
    condition=wseCHWST > 0.9*TWetBul + towTApp + dTW)
    annotation (Placement(transformation(extent={{20,100},{58,138}})));
  Modelica_StateGraph2.Step on(nIn=1, nOut=1,
    final initialStep=false)
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Modelica_StateGraph2.Transition T2(delayedTransition=true, waitTime=1200,
    use_conditionPort=false,
    condition=wseCHWST < wseCWST + dTOff)
    annotation (Placement(transformation(extent={{22,-20},{58,16}})));
  Modelica.Blocks.Math.BooleanToReal booToRea1(realTrue=0, realFalse=1)
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
equation

  connect(booToRea2.y, y2)
                          annotation (Line(
      points={{161,4.44089e-16},{168,4.44089e-16},{168,0},{190,0},{190,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.outPort[1], T1.inPort)   annotation (Line(
      points={{39,170.65},{39,138}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T1.outPort, on.inPort[1])    annotation (Line(
      points={{39,95.25},{39,60},{40,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(on.outPort[1], T2.inPort)    annotation (Line(
      points={{40,38.5},{40,16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T2.outPort, off.inPort[1])   annotation (Line(
      points={{40,-24.5},{40,-60},{100,-60},{100,220},{39,220},{39,190}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(off.activePort, booToRea2.u) annotation (Line(
      points={{49.62,181},{120,181},{120,8.88178e-16},{138,8.88178e-16}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToRea1.y, y1) annotation (Line(
      points={{161,140},{190,140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToRea1.u, off.activePort) annotation (Line(
      points={{138,140},{120,140},{120,181},{49.62,181}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="wseCon",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-20,-80},{180,240}},
        initialScale=0.04), graphics={
        Rectangle(
          extent={{-20,-80},{180,240}},
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
    Diagram(coordinateSystem(extent={{-20,-80},{180,240}},  preserveAspectRatio=false)));
end WSEControl;
