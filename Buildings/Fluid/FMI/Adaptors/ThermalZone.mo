within Buildings.Fluid.FMI.Adaptors;
model ThermalZone
  "Adaptor for connecting a thermal zone to signal ports which then can be exposed at an FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nFluPor(final min = 1) "Number of fluid ports."
    annotation(Dialog(connectorSizing=true));


   Interfaces.Inlet fluPor[nFluPor](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Fluid connector"
    annotation (Placement(transformation(extent={{160,140},{140,160}}),
        iconTransformation(extent={{180,120},{140,160}})));

  Modelica.Blocks.Interfaces.RealOutput TAirZon(
    final unit="K",
    displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{140,60},{180,100}})));

  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    final unit = "kg/kg") "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{140,20},{180,60}})));

  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{140,-20},{180,20}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nFluPor](
    redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{-148,40},{-128,-40}})));

protected
  constant Modelica.SIunits.Temperature TAveSkin = 273.15+37
    "Average skin temperature";
  final parameter Modelica.SIunits.SpecificEnergy h_fg=
    Medium.enthalpyOfCondensingGas(TAveSkin) "Latent heat of water vapor"
    annotation(Evaluate=true);

  x_i_toX_w x_i_toX(
    redeclare final package Medium = Medium) if
       Medium.nXi > 0 "Conversion from x_i to X_w"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  RealVectorExpression XiSup(each final n=Medium.nXi, final y=inStream(ports[1].Xi_outflow)) if
       Medium.nXi > 0 "Water vapor concentration of supply air"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));

  RealVectorExpression CSup(each final n=Medium.nC, final y=inStream(ports[1].C_outflow)) if
       Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Sources.MassFlowSource_T bou[nFluPor](
    each final nPorts=1,
    redeclare each final package Medium = Medium,
    each final use_T_in=true,
    each final use_C_in=Medium.nC > 0,
    each final m_flow=0,
    each final use_X_in=Medium.nXi > 0,
    each final use_m_flow_in=true) "Boundary conditions for ThermalZone system"
    annotation (Placement(transformation(extent={{-36,110},{-56,130}})));
  Conversion.InletToAir con[nFluPor](
      redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{120,110},{100,130}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  BaseClasses.X_w_toX x_w_toX[nFluPor](redeclare final package Medium = Medium)
    if Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{40,100},{20,120}})));

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
    connect(bou[i].ports[1], ports[i]) annotation (Line(points={{-56,120},{-60,
            120},{-60,0},{-138,0}},
                     color={0,127,255}));
  end for;
  connect(x_i_toX.X_w, X_wZon)
    annotation (Line(points={{122,40},{122,40},{160,40}},   color={0,0,127}));
  connect(con.inlet, fluPor)
    annotation (Line(points={{121,120},{130,120},{130,150},{136,150},{136,150},
          {150,150},{150,150}},                        color={0,0,255}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{18,110},{18,110},{6,
          110},{6,110},{0,110},{0,116},{-34,116}},
                color={0,0,127}));
  connect(con.X_w, x_w_toX.X_w) annotation (Line(points={{98,116},{98,114},{60,
          114},{60,110},{42,110}},
                      color={0,0,127}));
  connect(bou.C_in, con.C) annotation (Line(points={{-36,112},{-36,112},{-28,
          112},{-28,90},{78,90},{78,112},{98,112}},
                                            color={0,0,127}));
  connect(bou.T_in, con.T) annotation (Line(points={{-34,124},{18,124},{98,124}},
                   color={0,0,127}));
  connect(senTemAir.T, TAirZon)
    annotation (Line(points={{120,80},{120,80},{160,80}}, color={0,0,127}));
  connect(CSup.y, CZon)
    annotation (Line(points={{91,0},{91,0},{160,0}},       color={0,0,127}));
  connect(XiSup.y, x_i_toX.Xi)
    annotation (Line(points={{91,40},{98,40}},
                                             color={0,0,127}));

  connect(con.m_flow, bou.m_flow_in)
    annotation (Line(points={{98,128},{98,128},{-36,128}},color={0,0,127}));
  annotation (defaultComponentName="hvacAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-160},{140,160}}), graphics={
                                   Rectangle(
          extent={{-140,160},{140,-160}},
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
        Polygon(
          points={{-140,-160},{140,160},{140,-160},{-140,-160}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,164},{146,200}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{42,32},{134,22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{40,-22},{134,-32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{66,52},{118,0}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{106,48},{66,26},{106,4},{106,48}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{62,-2},{114,-54}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{76,-6},{116,-28},{76,-50},{76,-6}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
                 Bitmap(extent={{36,-154},{124,-84}},
                                                    fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png"),
        Rectangle(
          extent={{-90,24},{-56,-18}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-54,10},{-52,-6}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-128,-6},{-96,-14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-128,20},{-96,12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
            Bitmap(extent={{-120,90},{0,154}}, fileName=
            "modelica://Buildings/Resources/Images/Fluid/FMI/modelica_icon.png")}),
    Documentation(info="<html>
<p>
Adaptor that can be used to connect a model of a thermal zone (with acausal ports)
to input/output signals, which then can be exposed in an FMI interface.
</p>
<h4>Assumption and limitations</h4>
<p>
fixme: This needs to be updated.

The mass flow rates at <code>ports</code> sum to zero,
hence this model conserves mass.
</p>
<p>
This model does not impose any pressure, other than
setting the pressure of all fluid connections
to <code>ports</code> to be equal. The reason is that setting
a pressure can lead to non-physical system models,
for example if a mass flow rate is imposed and the thermal
zone is connected to a model that sets a pressure boundary condition such
as
<a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside
</a>.
</p>
<h4>Typical use and important parameters</h4>
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{
            140,160}})));
end ThermalZone;
