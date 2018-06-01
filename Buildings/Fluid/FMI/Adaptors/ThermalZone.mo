within Buildings.Fluid.FMI.Adaptors;
model ThermalZone
  "Adaptor for connecting a thermal zone to signal ports which then can be exposed at an FMI interface"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model within the source" annotation (choicesAllMatching=true);

  // Don't use annotation(Dialog(connectorSizing=true)) for nPorts because
  // otherwise, in Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones
  // the fluid ports can not be assigned between the different zones by the user.
  parameter Integer nPorts(final min=2) "Number of fluid ports"
    annotation (Dialog(connectorSizing=false));

  Interfaces.Inlet fluPor[nPorts](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=true,
    each final use_p_in=false) "Fluid connector" annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}}), iconTransformation(
          extent={{-142,-20},{-102,20}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
    redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{90,
            40},{110,-40}}), iconTransformation(extent={{90,40},{110,-40}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port for sensible heat input" annotation (Placement(transformation(
          extent={{90,-90},{110,-70}}), iconTransformation(extent={{90,-90},{110,-70}})));

protected
  x_i_toX_w x_i_toX(
    redeclare final package Medium = Medium) if
    Medium.nXi > 0 "Conversion from x_i to X_w"
    annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));

  RealVectorExpression XiSup(
    final n=Medium.nXi,
    final y=inStream(ports[1].Xi_outflow)) if
       Medium.nXi > 0
      "Water vapor concentration of supply air"
    annotation (Placement(transformation(extent={{20,-30},{0,-10}})));

  RealVectorExpression CSup(
    final n=Medium.nC,
    final y=inStream(ports[1].C_outflow)) if
    Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));

  Sources.MassFlowSource_T bou[nPorts](
    each final nPorts=1,
    redeclare each final package Medium = Medium,
    each final use_T_in=true,
    each final use_C_in=Medium.nC > 0,
    each final use_X_in=Medium.nXi > 0,
    each use_m_flow_in=true) "Mass flow source"
    annotation (Placement(transformation(extent={{2,38},{22,58}})));

  Conversion.InletToAir con[nPorts](redeclare each final package Medium =
        Medium) "Connector between FMI signals and real input and real outputs"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{72,-90},{52,-70}})));

  BaseClasses.X_w_toX x_w_toX[nPorts](redeclare final package Medium = Medium)
    if Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));

  Modelica.Blocks.Math.MultiSum multiSum(final nu=nPorts, final k=fill(1,
        nPorts)) "Sum of air mass flow rates"
    annotation (Placement(transformation(extent={{4,72},{16,84}})));

  Buildings.Utilities.Diagnostics.AssertEquality assEqu(
    message="\"Mass flow rate does not balance. The sum needs to be zero.",
      threShold=1E-4)
    "Tests whether the mass flow rates balance to zero"
    annotation (Placement(transformation(extent={{70,56},{90,76}})));
  Modelica.Blocks.Sources.Constant const(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{30,68},{50,88}})));

  ///////////////////////////////////////////////////////////////////////////
  // Internal blocks
  block RealVectorExpression
    "Set vector output signal to a time varying vector Real expression"
    parameter Integer n "Dimension of output signal";
    Modelica.Blocks.Interfaces.RealOutput[n] y "Value of Real output"
    annotation (Dialog(group="Time varying output signal"), Placement(
        transformation(extent={{100,-10},{120,10}})));
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
</html>", revisions="<html>
<ul>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
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
      final unit="kg/kg") "Water vapor concentration in kg/kg total air"
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
November 8, 2016, by Michael Wetter:<br/>
Removed wrong usage of <code>each</code> keyword.
</li>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
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

  for i in 1:nPorts loop
    connect(bou[i].ports[1], ports[i]) annotation (Line(points={{22,48},{22,48},
            {80,48},{80,0},{100,0}},
                     color={0,127,255}));
  end for;
  connect(con.inlet, fluPor)
    annotation (Line(points={{-81,60},{-90,60},{-90,60},{-90,0},{-110,0}},
                                                       color={0,0,255}));
  connect(con.X_w, x_w_toX.X_w) annotation (Line(points={{-58,56},{-58,56},{-42,
          56}},       color={0,0,127}));

  connect(x_w_toX.X, bou.X_in)
    annotation (Line(points={{-18,56},{-18,56},{-14,56},{-14,44},{0,44}},
                                               color={0,0,127}));
  connect(con.C, bou.C_in) annotation (Line(points={{-58,52},{-50,52},{-50,40},
          {0,40},{0,40}},                   color={0,0,127}));
  connect(heaPorAir, senTemAir.port) annotation (Line(points={{100,-80},{80,-80},
          {72,-80}},          color={191,0,0}));
  connect(XiSup.y, x_i_toX.Xi)
    annotation (Line(points={{-1,-20},{-18,-20}}, color={0,0,127}));
  connect(con.T, bou.T_in) annotation (Line(points={{-58,64},{-58,64},{-44,64},{
          -44,74},{-12,74},{-12,52},{0,52}},color={0,0,127}));
  connect(con[1:nPorts].m_flow, multiSum.u[1:nPorts]) annotation (Line(points={{-58,68},{-54,68},
          {-50,68},{-50,78},{4,78}},  color={0,0,127}));
  connect(multiSum.y, assEqu.u2) annotation (Line(points={{17.02,78},{26,78},{26,
          60},{30,60},{68,60}}, color={0,0,127}));
  connect(const.y, assEqu.u1) annotation (Line(points={{51,78},{60,78},{60,72},{
          68,72}}, color={0,0,127}));
  for i in 1:nPorts loop
  connect(senTemAir.T, con[i].TAirZon) annotation (Line(points={{52,-80},{40,-80},
            {40,20},{-76,20},{-76,48}},
                                      color={0,0,127}));
  if Medium.nXi > 0 then
    connect(x_i_toX.X_w, con[i].X_wZon) annotation (Line(points={{-42,-20},{-42,-20},
            {-70,-20},{-70,48}}, color={0,0,127}));
  end if;
  connect(CSup.y, con[i].CZon)
    annotation (Line(points={{-1,-60},{-64,-60},{-64,48}}, color={0,0,127}));
  end for;
  connect(bou.m_flow_in, con.m_flow) annotation (Line(points={{0,56},{-8,56},{
          -8,78},{-50,78},{-50,68},{-58,68}},
                                           color={0,0,127}));
  annotation (defaultComponentName="hvacAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false),      graphics={
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
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-2,-20},{84,-76}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="[%nPorts]")}),
    Documentation(info="<html>
<p>
Adaptor that can be used to connect a model of a thermal zone (with acausal ports)
to input/output signals, which can be exposed in an FMI interface.
</p>
<p>
This model has a vector <code>fluPor</code> with dimension <code>nPorts</code>
which can be exposed at the FMI interface for the connecting the HVAC system.
These connectors contain for each fluid inlet the mass flow rate, the temperature,
the water vapor mass fraction per total mass of the air (unless <code>Medium.nXi=0</code>),
and the trace substances (unless <code>Medium.nC=0</code>).
</p>

<p>
The connector <code>ports</code> can be used to connect the model with a thermal zone.
The number of connections to <code>ports</code> must
be equal to <code>nPorts</code>.
</p>

<h4>Assumption and limitations</h4>
<p>
The mass flow rates at <code>ports</code> sum to zero, hence this
model conserves mass. If the mass flow rates at <code>fluPor</code>
do not sum to zero, then this model stops with an error.
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
The model has no pressure drop.
</p>

<h4>Typical use</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.ThermalZone
</a>
for a model that uses this model.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2016, by Michael Wetter:<br/>
Revised implementation and documentation.
</li>
<li>
April 27, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZone;
