within Buildings.Fluid.FMI.Adaptors;
model HVACConvective "Model for exposing a room model to the FMI interface"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nFluPor(final min = 1) "Number of fluid ports."
    annotation(Dialog(connectorSizing=true));


   Interfaces.Inlet fluPor[nFluPor](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Fluid connector"
    annotation (Placement(transformation(extent={{160,110},{140,130}}),
        iconTransformation(extent={{160,110},{140,130}})));

   Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-40,-180}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-60,-180})));

  Modelica.Blocks.Interfaces.RealInput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-180}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-180})));

  Modelica.Blocks.Interfaces.RealInput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={40,-180}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={60,-180})));

  Modelica.Blocks.Interfaces.RealOutput TZonAir(
    final unit="K",
    displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{140,60},{180,100}})));

  Modelica.Blocks.Interfaces.RealOutput TZonRad(
    final unit="K",
    displayUnit="degC")
    "Zone radiative temperature"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}})));

  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    final unit = "kg/kg") "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{140,20},{180,60}})));

  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{140,-20},{180,20}})));

  Modelica.Blocks.Interfaces.RealOutput mWat_flow(final
    unit="kg/s") "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}})));

  Modelica.Blocks.Interfaces.RealOutput TWat(displayUnit="degC", final unit="K")
    "Skin temperature at which latent heat is added to the space"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port for convective heat gain" annotation (Placement(transformation(
          extent={{-150,110},{-130,130}}),
          iconTransformation(extent={{-150,110},{-130,130}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorRad
    "Heat port for radiative heat gain and radiative temperature" annotation (
      Placement(transformation(extent={{-150,-110},{-130,-90}}),
                iconTransformation(extent={{-150,-110},{-130,-90}})));

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

    Modelica.Blocks.Routing.Multiplex3 mux "Multiplex"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-76})));

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
    each final use_m_flow_in=true) "Boundary conditions for HVACConvective system"
    annotation (Placement(transformation(extent={{-36,110},{-56,130}})));
  Conversion.InletToAir con[nFluPor](
      redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{120,110},{100,130}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRad
    "Radiative temperature sensor"
    annotation (Placement(transformation(extent={{72,-50},{92,-30}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  BaseClasses.X_w_toX x_w_toX[nFluPor](redeclare final package Medium = Medium)
    if Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{40,100},{20,120}})));

  Modelica.Blocks.Sources.Constant TSkin(
    k=TAveSkin,
    y(final unit="K",
      final displayUnit="degC"))
    "Skin temperature at which latent heat is added to the space"
    annotation (Placement(transformation(extent={{90,-130},{110,-110}})));
  Modelica.Blocks.Math.Gain mWatFlow(
    final k(unit="kg/J") = 1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s")) "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{88,-90},{108,-70}})));

  HeatTransfer.Sources.PrescribedHeatFlow conQLat_flow
    "Converter for latent heat flow rate"
    annotation (Placement(transformation(extent={{-26,50},{-46,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow conQCon_flow
    "Converter for convective heat flow rate"
    annotation (Placement(transformation(extent={{-24,30},{-44,50}})));

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
  connect(QGaiCon_flow, mux.u2[1]) annotation (Line(points={{0,-180},{0,-88},{
          -8.88178e-16,-88}},       color={0,0,127}));
  connect(QGaiLat_flow, mux.u3[1]) annotation (Line(points={{40,-180},{40,-140},
          {7,-140},{7,-88}},
                           color={0,0,127}));
  connect(x_i_toX.X_w, X_wZon)
    annotation (Line(points={{122,40},{122,40},{160,40}},   color={0,0,127}));
  connect(con.inlet, fluPor)
    annotation (Line(points={{121,120},{120,120},{150,120}},
                                                       color={0,0,255}));
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
  connect(heaPorAir, heaPorAir)
    annotation (Line(points={{-140,120},{-140,120}},
                                                   color={191,0,0}));
  connect(senTemAir.port, heaPorAir) annotation (Line(points={{100,80},{-110,80},
          {-110,120},{-140,120}},
                               color={191,0,0}));
  connect(senTemAir.T, TZonAir)
    annotation (Line(points={{120,80},{120,80},{160,80}}, color={0,0,127}));
  connect(CSup.y, CZon)
    annotation (Line(points={{91,0},{91,0},{160,0}},       color={0,0,127}));
  connect(XiSup.y, x_i_toX.Xi)
    annotation (Line(points={{91,40},{98,40}},
                                             color={0,0,127}));

  connect(mux.y[3], mWatFlow.u) annotation (Line(points={{7.77156e-16,-65},{
          7.77156e-16,-66},{0,-66},{0,-60},{20,-60},{20,-80},{86,-80}},
                                        color={0,0,127}));
  connect(mWatFlow.y, mWat_flow)
    annotation (Line(points={{109,-80},{109,-80},{160,-80}},
                                                           color={0,0,127}));
  connect(QGaiRad_flow, mux.u1[1]) annotation (Line(points={{-40,-180},{-40,
          -180},{-40,-140},{-7,-140},{-7,-88}},
                                        color={0,0,127}));
  connect(TSkin.y, TWat)
    annotation (Line(points={{111,-120},{160,-120}},color={0,0,127}));
  connect(mux.y[2], conQCon_flow.Q_flow) annotation (Line(points={{6.66134e-16,-65},
          {6.66134e-16,40},{-24,40}}, color={0,0,127}));
  connect(conQCon_flow.port, heaPorAir) annotation (Line(points={{-44,40},{-84,
          40},{-84,80},{-110,80},{-110,120},{-140,120}},
                                                       color={191,0,0}));
  connect(mux.y[3], conQLat_flow.Q_flow) annotation (Line(points={{7.77156e-16,
          -65},{0,-65},{0,60},{-26,60}},
                                    color={0,0,127}));
  connect(conQLat_flow.port, heaPorAir) annotation (Line(points={{-46,60},{-84,
          60},{-84,80},{-110,80},{-110,120},{-140,120}},
                                                       color={191,0,0}));
  connect(senTemRad.T, TZonRad) annotation (Line(points={{92,-40},{92,-40},{120,
          -40},{160,-40}}, color={0,0,127}));
  connect(heaPorRad, senTemRad.port) annotation (Line(points={{-140,-100},{-140,
          -100},{-80,-100},{-80,-40},{72,-40}}, color={191,0,0}));

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
        Text(
          extent={{-150,164},{146,200}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-128,30},{50,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-130,-22},{50,-32}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-94,52},{-42,0}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-54,48},{-94,26},{-54,4},{-54,48}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-96,-2},{-44,-54}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84,-6},{-44,-28},{-84,-50},{-84,-6}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,54},{10,-4}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{10,54},{-10,-4}}, color={0,0,0})}),
    Documentation(info="<html>
<p>
Model that is used as an adapter between
a thermal zone that uses fluid ports and an convective HVAC system that
uses input and output signals as needed for an FMU.
</p>
<h4>Assumption and limitations</h4>
<p>
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
end HVACConvective;
