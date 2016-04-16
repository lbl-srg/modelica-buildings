within Buildings.Fluid.FMI;
model ThermalZoneAdaptor
  "Model for exposing a room supply and return of an HVAC system to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nPorts(final min = 1) "Number of ports"
                      annotation(Dialog(connectorSizing=true));

  Modelica.Blocks.Interfaces.RealInput TZon(final unit="K",
                                            displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{140,-20},{100,20}})));
  Modelica.Blocks.Interfaces.RealInput X_wZon(
    final unit = "kg/kg") if
       Medium.nXi > 0 "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{140,-60},{100,-20}})));
  Modelica.Blocks.Interfaces.RealInput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{140,-100},{100,-60}})));

  Interfaces.Outlet supAir[nPorts](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Supply air connector"
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

  ConnectionConverter con[nPorts] "Converter between the different connectors"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Sensors.MassFlowRate senMasFlo[nPorts](
    redeclare each package Medium = Medium,
    each allowFlowReversal=true) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.RealExpression TSup[nPorts](
    y={Medium.temperature_phX(
        p=ports[i].p,
        h=inStream(ports[i].h_outflow),
        X=inStream(ports[i].Xi_outflow)) for i in 1:nPorts})
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.RealExpression X_wSup[nPorts](final y={sum(inStream(
        ports[i].Xi_outflow)) for i in 1:nPorts})
    "Water vapor concentration of supply air"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  RealVectorExpression CSup[nPorts](
    final y={inStream(ports[i].C_outflow) for i in 1:nPorts},
    each final n=Medium.nC) if
       Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  X_w_toX x_w_toX(
    redeclare final package Medium = Medium) if
       Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  ///////////////////////////////////////////////////////////////////////////
  // Internal blocks
  block ConnectionConverter
    extends Modelica.Blocks.Icons.Block;

    Interfaces.Outlet outlet(
      redeclare final package Medium = Medium,
      final allowFlowReversal=false,
      final use_p_in=false) "Fluid outlet"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

    Modelica.Blocks.Interfaces.RealInput m_flow(
      final unit="kg/s") "Mass flow rate"
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));

    Modelica.Blocks.Interfaces.RealInput TSup(
      final unit="K",
      displayUnit="degC") "Prescribed fluid temperature"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput X_wSup(
      final unit = "kg/kg") "Water vapor concentration in kg/kg total air"
      annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
    Modelica.Blocks.Interfaces.RealInput CSup[Medium.nC](
      final quantity=Medium.extraPropertiesNames)
      "Prescribed boundary trace substances"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation
    outlet.m_flow    = m_flow;
    outlet.forward.T = TSup;
    connect(outlet.forward.X_w,  X_wSup);
    outlet.forward.C  = CSup;

    annotation (Icon(graphics={
          Polygon(origin={20,0},
            lineColor={64,64,64},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}}),
          Polygon(fillColor={102,102,102},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            points={{-100,20},{-60,20},{-30,70},{-10,70},{-10,-70},{-30,-70},{-60,
                -20},{-100,-20}})}));
  end ConnectionConverter;

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

  block X_w_toX "Conversion from Xi to X"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium
      "Medium model within the source"
       annotation (choicesAllMatching=true);
    Modelica.Blocks.Interfaces.RealInput X_w(final unit="kg/kg") if
          Medium.nXi > 0 "Water mass fraction per total air mass"
       annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput X[Medium.nX](
      each final unit="kg/kg",
      final quantity=Medium.substanceNames) "Prescribed fluid composition"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  protected
    Modelica.Blocks.Interfaces.RealInput X_w_internal(final unit="kg/kg")
      "Internal connector for water mass fraction per total air mass";
  equation
    // Conditional connector
    connect(X_w_internal, X_w);
    if Medium.nXi == 0 then
      X_w_internal = 0;
    end if;
    // Assign vector to output connector
   X = cat(1, {X_w_internal}, {1-X_w_internal});
    annotation (Documentation(revisions="<html>
<ul>
<li>
April 15, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>
Block that converts a scalar input for the water mass fraction <code>Xi</code>
to a vector output <code>X</code>.
This is needed for models in which a scalar input signal <code>Xi</code> that
may be conditionally removed is to be connected to a model with a vector
input <code>X</code>, because the conversion from scalar to vector
needs to access the conditional connector, but conditional connectors
can only be used in <code>connect</code> statements.
</p>
</html>"));
  end X_w_toX;

initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation

  connect(con.outlet, supAir)
    annotation (Line(points={{81,70},{96,70},{110,70}},
                                                      color={0,0,255}));
  connect(senMasFlo.m_flow, con.m_flow) annotation (Line(points={{-70,11},{-70,11},
          {-70,80},{58,80}},                           color={0,0,127}));
  connect(TSup.y, con.TSup) annotation (Line(points={{-19,60},{20,60},{20,76},{58,
          76}}, color={0,0,127}));
  connect(X_wSup.y, con.X_wSup) annotation (Line(points={{-19,40},{4,40},{28,40},
          {28,73},{58,73}}, color={0,0,127}));
  for i in 1:nPorts loop
    connect(CSup[i].y, con[i].CSup) annotation (Line(points={{-19,20},{32,20},{32,70},{58,
          70}}, color={0,0,127}));
  end for;
  connect(TZon, bou.T_in) annotation (Line(points={{120,0},{120,0},{80,0},{80,4},
          {42,4}},    color={0,0,127}));
  connect(bou.C_in, CZon) annotation (Line(points={{40,-8},{52,-8},{52,-80},{120,
          -80}},      color={0,0,127}));
  connect(senMasFlo.port_b, bou.ports)
    annotation (Line(points={{-60,0},{20,0}},         color={0,127,255}));
  connect(ports, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-90,0},{-80,0}}, color={0,127,255}));
  connect(x_w_toX.X_w, X_wZon)
    annotation (Line(points={{92,-40},{120,-40}},           color={0,0,127}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{68,-40},{60,-40},{60,
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
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-100,20},{-42,12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,-8},{-42,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-42,-46},{50,46}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,40},{44,-40}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{44,26},{50,-18}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,26},{48,-18}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model that is used to connect an HVAC system to a thermal zone.
</p>
<p>
The model has two fluid ports <code>sup</code> and <code>ret</code>
for the supply and the return air. These quantities are
converted to the FMI ports <code>supAir</code> and <code>retAir</code>.
The model also outputs the air temperature of the zone, as obtained
from the connector <code>retAir</code>. This will always be the
zone air temperature, even if the return air mass flow rate is
zero or negative.
</p>
<h4>Assumption and limitations</h4>
<p>
The model has no pressure drop. Hence, the pressure drop
of an air diffuser or of an exhaust grill need to be modelled
in models that are connected to the ports <code>sup</code>
or <code>ret</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
Set <code>allowFlowReversal = true </code> if the HVAC system
should model reverse flow. The setting of <code>allowFlowReversal</code>
affects what quantities are exposed in the FMI interface at the connectors
<code>supAir</code> and <code>retAir</code>. See also
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Outlet\">
Buildings.Fluid.FMI.Interfaces.Outlet</a>.
</p>
<p>
Also, if <code>allowFlowReversal = false</code>, then the fluid properties
for the backward flowing medium at the port <code>sup</code> will be
set to the default values of the medium.
</p>
<p>
If the parameter <code>use_p_in = true</code>, then the pressure
is sent to the FMI interface for the supply air, and read from the FMI interface
for the return air.
If <code>use_p_in = false</code>, then the pressure of the return
air port <code>ret</code> is set to be the same as the pressure of
the supply air port <code>sup</code>.
Setting these equal allows for example to model a pressurized room,
and also to model systems in which the supply air fan provides the pressure
needed for the return and exhaust air.
</p>
<p>
See 
<a href=\"modelica://Buildings.Fluid.FMI.xxx\">
Buildings.Fluid.FMI.xxx</a>
for how to use this model.
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
end ThermalZoneAdaptor;
