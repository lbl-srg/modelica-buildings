within Buildings.Fluid.FMI.Adaptors;
model ThermalZone
  "Adaptor for connecting a thermal zone to signal ports which then can be exposed at an FMI interface"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model within the source" annotation (choicesAllMatching=true);

  parameter Integer nFluPor(final min=1) "Number of fluid ports."
    annotation (Dialog(connectorSizing=true));

  Interfaces.Inlet fluPor[nFluPor](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Fluid connector" annotation (Placement(
        transformation(extent={{-120,50},{-100,70}}), iconTransformation(
          extent={{-142,60},{-102,100}})));

  Modelica.Blocks.Interfaces.RealOutput TAirZon(
    final unit="K", displayUnit="degC") "Zone air temperature" annotation (Placement(transformation(extent={{-100,
            0},{-140,40}}), iconTransformation(extent={{-102,8},{-142,48}})));

  Modelica.Blocks.Interfaces.RealOutput X_wZon(final unit="kg/kg")
    "Zone air water mass fraction per total air mass" annotation (Placement(
        transformation(extent={{-100,-40},{-142,2}}), iconTransformation(
          extent={{-102,-38},{-142,2}})));

  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances" annotation (Placement(
        transformation(extent={{-100,-80},{-140,-40}}), iconTransformation(
          extent={{-102,-90},{-142,-50}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nFluPor](
    redeclare each final package Medium = Medium) annotation (Placement(transformation(extent={{90,
            40},{110,-40}}), iconTransformation(extent={{90,40},{110,-40}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port for sensible heat input" annotation (Placement(transformation(
          extent={{90,-90},{110,-70}}), iconTransformation(extent={{90,-90},{110,-70}})));

protected
  x_i_toX_w x_i_toX(
    redeclare final package Medium = Medium) if
    Medium.nXi > 0 "Conversion from x_i to X_w"
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));

  RealVectorExpression XiSup(each final n=Medium.nXi, final y=inStream(ports[1].Xi_outflow)) if
    Medium.nXi > 0 "Water vapor concentration of supply air"
    annotation (Placement(transformation(extent={{20,-30},{0,-10}})));

  RealVectorExpression CSup(each final n=Medium.nC, final y=inStream(ports[1].C_outflow)) if
    Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));

  Sources.MassFlowSource_T bou[nFluPor](
    each final nPorts=1,
    redeclare each final package Medium = Medium,
    each final use_T_in=true,
    each final use_C_in=Medium.nC > 0,
    each final m_flow=0,
    each final use_X_in=Medium.nXi > 0,
    each final use_m_flow_in=true) "Boundary conditions for ThermalZone system"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Conversion.InletToAir con[nFluPor](
    redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{-84,50},{-64,70}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));

  BaseClasses.X_w_toX x_w_toX[nFluPor](redeclare final package Medium = Medium)
    if Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{-10,46},{10,66}})));

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

  block x_i_toX_w "Conversion from Xi to X"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);
    Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi](each final unit="kg/kg") if
      Medium.nXi > 0 "Water vapor concentration in kg/kg total air"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

    Modelica.Blocks.Interfaces.RealOutput X_w(
      each final unit="kg/kg") "Water vapor concentration in kg/kg total air"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  protected
    Modelica.Blocks.Interfaces.RealInput Xi_internal[Medium.nXi](
      each final unit = "kg/kg")
      "Internal connector for water vapor concentration in kg/kg total air";

    Modelica.Blocks.Interfaces.RealInput X_w_internal(
      final unit = "kg/kg")
      "Internal connector for water vapor concentration in kg/kg total air";
  equation
  // Conditional connector
  connect(Xi_internal, Xi);
  if Medium.nXi == 0 then
    Xi_internal = zeros(Medium.nXi);
  end if;

  X_w_internal = sum(Xi_internal);
  connect( X_w, X_w_internal)
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 27, 2016, by Thierry S. Nouidui Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Block that converts a vector input for the water mass fraction <code>Xi</code>
to a scalar output <code>X</code>.
This is needed for models in which a scalar input signal <code>Xi</code> that
may be conditionally removed is to be connected to a model with a vector
input <code>X</code>, because the conversion from scalar to vector
needs to access the conditional connector, but conditional connectors
can only be used in <code>connect</code> statements.
</p>
</html>"));
  end x_i_toX_w;

initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation

  for i in 1:nFluPor loop
    connect(bou[i].ports[1], ports[i]) annotation (Line(points={{60,60},{60,60},
            {80,60},{80,0},{100,0}},
                     color={0,127,255}));
  end for;
  connect(con.inlet, fluPor)
    annotation (Line(points={{-85,60},{-85,60},{-110,60}},
                                                       color={0,0,255}));
  connect(con.X_w, x_w_toX.X_w) annotation (Line(points={{-62,56},{-62,56},{-12,
          56}},       color={0,0,127}));
  connect(senTemAir.T, TAirZon)
    annotation (Line(points={{50,-60},{50,-60},{40,-60},{40,20},{-120,20}},
                                                          color={0,0,127}));
  connect(CSup.y, CZon)
    annotation (Line(points={{-1,-60},{-1,-60},{-120,-60}},color={0,0,127}));

  connect(x_w_toX.X, bou.X_in)
    annotation (Line(points={{12,56},{32,56},{38,56}},
                                               color={0,0,127}));
  connect(con.C, bou.C_in) annotation (Line(points={{-62,52},{-62,52},{-44,52},
          {-44,40},{20,40},{20,52},{40,52}},color={0,0,127}));
  connect(con.m_flow, bou.m_flow_in) annotation (Line(points={{-62,68},{-50,68},
          {-40,68},{-40,80},{28,80},{28,68},{40,68}}, color={0,0,127}));
  connect(heaPorAir, senTemAir.port) annotation (Line(points={{100,-80},{80,-80},
          {80,-60},{70,-60}}, color={191,0,0}));
  connect(XiSup.y, x_i_toX.Xi)
    annotation (Line(points={{-1,-20},{-38,-20}}, color={0,0,127}));
  connect(TAirZon, TAirZon) annotation (Line(points={{-120,20},{-114,20},{-114,20},
          {-120,20}}, color={0,0,127}));
  connect(x_i_toX.X_w, X_wZon) annotation (Line(points={{-62,-20},{-121,-20},{
          -121,-19}},
                 color={0,0,127}));
  connect(con.T, bou.T_in) annotation (Line(points={{-62,64},{-46,64},{-30,64},
          {-30,74},{20,74},{20,64},{38,64}},color={0,0,127}));
  annotation (defaultComponentName="hvacAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false, initialScale=0.1),
                                         graphics={
                                   Rectangle(
          extent={{-102,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-96,-22},{-50,30}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,14},{-50,-8}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-146,104},{150,140}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{100,-100},{-102,100},{-102,-100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                 Bitmap(extent={{-96,-98},{-30,-50}},
                                                    fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png"),
            Bitmap(extent={{0,50},{100,98}},   fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/modelica_icon.png"),
        Rectangle(
          extent={{38,-22},{84,30}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,26},{78,-18}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{78,14},{84,-8}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{80,10},{82,-6}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,-8},{44,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-74,24},{44,16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-62,44},{-40,-38}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-40,44},{-62,-38}},  color={0,0,0}),
        Ellipse(
          extent={{-14,36},{16,6}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,34},{14,22},{-4,8},{-4,34}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,2},{16,-28}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{6,0},{-12,-12},{6,-26},{6,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Adaptor that can be used to connect a model of a thermal zone (with acausal ports)
to input/output signals, which can be exposed in an FMI interface.
</p>
<p>
This model has a vector <code>fluPor</code> with dimension <code>nFluPor</code>
which can be exposed at the FMI interface for the connecting the HVAC system.
These connectors contain for each fluid inlet the mass flow rate, the temperature, 
the water vapor mass fraction per total mass of the air (unless <code>Medium.nXi=0</code>), 
and the trace substances (unless <code>Medium.nC=0</code>). 
</p>

<p>
The connector <code>ports</code> can be used to connect the model with a thermal zone.
The number of connections to <code>ports</code> must 
be equal to <code>nFluPor</code>.
</p>

<p>
The output signals of this model are the zone air temperature,
the water vapor mass fraction per total mass of the zone air (unless <code>Medium.nXi=0</code>)
and the trace substances of the zone air (unless <code>Medium.nC=0</code>).
The inflowing fluid stream(s) 
at the port <code>ports</code> are at this state.
</p>

<h4>Typical use</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective
</a>
for a model that uses this model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, initialScale=0.1)));
end ThermalZone;
