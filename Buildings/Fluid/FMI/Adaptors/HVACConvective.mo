within Buildings.Fluid.FMI.Adaptors;
model HVACConvective
  "Adaptor for connecting an HVAC system to signal ports which then can be exposed at an FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  // Don't use annotation(Dialog(connectorSizing=true)) for nPorts because
  // otherwise, in Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveMultipleZones
  // the fluid ports can not be assigned between the different zones by the user.
  parameter Integer nPorts(final min = 1) "Number of ports";

  Modelica.Blocks.Interfaces.RealInput TAirZon(
    final unit="K",
    displayUnit="degC") "Zone air temperature"
    annotation (Placement(transformation(extent={{140,-30},{100,10}}),
        iconTransformation(extent={{120,-10},{100,10}})));

  Modelica.Blocks.Interfaces.RealInput X_wZon(
    final unit = "kg/kg") if
    Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{138,-70},{98,-30}}),
        iconTransformation(extent={{118,-50},{98,-30}})),
        visible=Medium.nXi > 0);

  Modelica.Blocks.Interfaces.RealInput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{140,-110},{100,-70}}),
        iconTransformation(extent={{120,-90},{100,-70}})),
        visible=Medium.nC > 0);
  Interfaces.Outlet fluPor[nPorts](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Fluid connector"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
    redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,40},{-90,-40}})));

protected
  Sources.MassFlowSource_T bou(
    final nPorts=nPorts,
    redeclare final package Medium = Medium,
    final use_m_flow_in=false,
    final use_T_in=true,
    final use_X_in=Medium.nXi > 0,
    final use_C_in=Medium.nC > 0,
    final m_flow=0) "Boundary conditions for HVAC system"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));

  Buildings.Fluid.FMI.Conversion.AirToOutlet con[nPorts](
      redeclare each final package Medium = Medium)
    "Converter between the different connectors"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Sensors.MassFlowRate senMasFlo[nPorts](
    redeclare each final package Medium = Medium,
    each allowFlowReversal=true) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Sources.RealExpression hSup[nPorts](
    final y={inStream(ports[i].h_outflow) for i in 1:nPorts})
    "Supply air specific enthalpy"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  RealVectorExpression XiSup[nPorts](
    each final n = Medium.nXi,
    final y={inStream(ports[i].Xi_outflow) for i in 1:nPorts}) if
       Medium.nXi > 0 "Water vapor concentration of supply air"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  RealVectorExpression CSup[nPorts](
    each final n=Medium.nC,
    final y={inStream(ports[i].C_outflow) for i in 1:nPorts}) if
       Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  BaseClasses.X_w_toX
          x_w_toX(
    redeclare final package Medium = Medium) if
       Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{90,-60},{70,-40}})));
  ///////////////////////////////////////////////////////////////////////////
  // Internal blocks
  block RealVectorExpression
    "Set vector output signal to a time varying vector Real expression"
    parameter Integer n "Dimension of output signal";
    Modelica.Blocks.Interfaces.RealOutput[n] y "Value of Real output"
    annotation (Dialog(group="Time varying output signal"), Placement(
        transformation(extent={{100,-10},{120,10}}, rotation=0)));

  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,46},{94,-34}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={200,200,200},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Rectangle(
          extent={{-92,30},{100,-44}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-96,15},{96,-15}},
          lineColor={0,0,0},
          textString="%y"),
        Text(
          extent={{-150,90},{140,50}},
          textString="%name",
          lineColor={0,0,255})}), Documentation(info="<html>
<p>
The (time varying) vector <code>Real</code> output signal of this block can be defined in its
parameter menu via variable <code>y</code>. The purpose is to support the
easy definition of vector-valued Real expressions in a block diagram.
</p>
</html>"));

  end RealVectorExpression;
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation

  connect(con.outlet, fluPor)
    annotation (Line(points={{81,70},{96,70},{110,70}},
                                                      color={0,0,255}));
  connect(senMasFlo.m_flow, con.m_flow) annotation (Line(points={{-70,11},{-70,11},
          {-70,78},{58,78}},                           color={0,0,127}));
  connect(hSup.y, con.h) annotation (Line(points={{-19,60},{20,60},{20,74},{58,74}},
        color={0,0,127}));
  for i in 1:nPorts loop
   connect(XiSup[i].y, con[i].Xi) annotation (Line(points={{-19,40},{4,40},{28,40},{28,
          66},{58,66}}, color={0,0,127}));
    connect(CSup[i].y, con[i].C) annotation (Line(points={{-19,20},{32,20},{32,62},
            {58,62}}, color={0,0,127}));
  end for;
  connect(TAirZon, bou.T_in) annotation (Line(points={{120,-10},{120,-10},{80,
          -10},{80,4},{42,4}},
                         color={0,0,127}));
  connect(bou.C_in, CZon) annotation (Line(points={{40,-8},{52,-8},{52,-90},{
          120,-90}},  color={0,0,127}));
  connect(senMasFlo.port_b, bou.ports)
    annotation (Line(points={{-60,0},{20,0}},         color={0,127,255}));
  connect(ports, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-90,0},{-80,0}}, color={0,127,255}));
  connect(x_w_toX.X_w, X_wZon)
    annotation (Line(points={{92,-50},{92,-50},{118,-50}},  color={0,0,127}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{68,-50},{60,-50},{60,
          -4},{42,-4}},     color={0,0,127}));
  annotation (defaultComponentName="theZonAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
                                   Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Polygon(
          points={{-100,-100},{100,100},{100,-100},{-100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-90,20},{40,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-90,-8},{40,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{40,-22},{86,30}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,24},{80,-18}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{80,14},{86,-8}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,10},{84,-6}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,-42},{-6,-98}},
          lineColor={0,0,127},
          textString="[%nPorts]",
          horizontalAlignment=TextAlignment.Left),
        Ellipse(
          extent={{-76,36},{-40,0}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-66,34},{-40,18},{-66,2},{-66,34}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
            Bitmap(extent={{30,-102},{92,-40}},fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png"),
            Bitmap(extent={{-96,52},{-24,108}},fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/modelica_icon.png")}),
    Documentation(info="<html>
<p>
Adaptor that can be used to connect an HVAC system (with acausal ports)
to input/output signals, which then can be exposed in an FMI interface.
</p>
<p>
The adaptor has a vector of fluid ports called <code>ports</code>.
The supply and return air ducts need to be connected to these ports.
Also, if a thermal zone has interzonal air exchange or air infiltration,
these flow paths also need be connected to <code>ports</code>.
</p>
<p>
This model outputs at the port <code>fluPor</code> the mass flow rate for
each flow that is connected to <code>ports</code>, together with its
temperature, water vapor mass fraction per total mass of the air (not per kg dry
air), and trace substances. These quantities are always as if the flow
enters the room, even if the flow is zero or negative.
If a medium has no moisture, e.g., if <code>Medium.nXi=0</code>, or
if it has no trace substances, e.g., if <code>Medium.nC=0</code>, then
the output signal for these properties are removed.
These quantities are always as if the flow
enters the room, even if the flow is zero or negative.
Thus, a thermal zone model that uses these signals to compute the
heat added by the HVAC system need to implement an equation such as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>sen</sub> = max(0, &#7745;<sub>sup</sub>) &nbsp; c<sub>p</sub> &nbsp; (T<sub>sup</sub> - T<sub>air,zon</sub>),
</p>
<p>
where
<i>Q<sub>sen</sub></i> is the sensible heat flow rate added to the thermal zone,
<i>&#7745;<sub>sup</sub></i> is the supply air mass flow rate from
the port <code>fluPor</code> (which is negative if it is an exhaust),
<i>c<sub>p</sub></i> is the specific heat capacity at constant pressure,
<i>T<sub>sup</sub></i> is the supply air temperature and
<i>T<sub>air,zon</sub></i> is the zone air temperature.
Note that without the <i>max(&middot;, &middot;)</i> function, the energy
balance would be wrong.
</p>
</p>
<p>
The input signals of this model are the zone air temperature,
the water vapor mass fraction per total mass of the air (unless <code>Medium.nXi=0</code>)
and trace substances (unless <code>Medium.nC=0</code>).
The outflowing fluid stream(s) at the port <code>ports</code> will be at this
state. All fluid streams at port <code>ports</code> are at the same
pressure.
</p>
<h4>Assumption and limitations</h4>
<p>
The mass flow rates at <code>ports</code> sum to zero, hence this
model conserves mass.
</p>
<p>
This model does not impose any pressure, other than setting the pressure
of all fluid connections to <code>ports</code> to be equal.
The reason is that setting a pressure can lead to non-physical system models,
for example if a mass flow rate is imposed and the HVAC system is connected
to a model that sets a pressure boundary condition such as
<a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside</a>.
Also, setting a pressure would make it impossible to use multiple instances
of this model (one for each thermal zone) and build in Modelica an airflow network
model with pressure driven mass flow rates.
</p>
<p>
The model has no pressure drop. Hence, the pressure drop
of an air diffuser or of an exhaust grill need to be modelled
in models that are connected to <code>ports</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone</a>
for a model that uses this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end HVACConvective;
