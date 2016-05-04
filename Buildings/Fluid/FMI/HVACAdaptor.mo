within Buildings.Fluid.FMI;
model HVACAdaptor "Model for exposing a room model to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nFluPor(final min = 1) "Number of fluid ports."
    annotation(Dialog(connectorSizing=true));

  final parameter Modelica.SIunits.SpecificEnergy h_fg=
    Medium.enthalpyOfCondensingGas(TAveSkin) "Latent heat of water vapor"
    annotation(Evaluate=true);

  constant Modelica.SIunits.Temperature TAveSkin = 273.15+37
    "Average skin temperature";

  Modelica.Blocks.Interfaces.RealOutput TZon(final unit="K",
                                            displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    final unit = "kg/kg") "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

   Interfaces.Inlet fluPor[nFluPor](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Fluid connector"
    annotation (Placement(transformation(extent={{120,110},{100,130}}),
        iconTransformation(extent={{120,110},{100,130}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nFluPor](redeclare each final
      package Medium =       Medium)
    annotation (Placement(transformation(extent={{-130,40},{-110,-40}})));

   Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-40,-160})));
  Modelica.Blocks.Interfaces.RealInput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-160})));
  Modelica.Blocks.Interfaces.RealInput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={40,-160})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorRad
    "Heat port for radiative heat gain and radiative temperature" annotation (
      Placement(transformation(extent={{-132,-110},{-112,-90}}),
                                                           iconTransformation(
          extent={{-132,-110},{-112,-90}})));
   Modelica.Blocks.Interfaces.RealOutput TRad(final unit="K", displayUnit="degC")
    "Zone radiative temperature"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));

  ///////////////////////////////////////////////////////////////////////////
  // Internal blocks
protected
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

  x_i_toX_w x_i_toX(
    redeclare final package Medium = Medium) if
       Medium.nXi > 0 "Conversion from x_i to X_w"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));

  Modelica.Blocks.Routing.Multiplex3 mux annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-76})));

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

  RealVectorExpression XiSup(each final n=Medium.nXi, final y=inStream(ports[1].Xi_outflow)) if
       Medium.nXi > 0 "Water vapor concentration of supply air"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  RealVectorExpression CSup(each final n=Medium.nC, final y=inStream(ports[1].C_outflow)) if
       Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Sources.MassFlowSource_T bou[nFluPor](
    each final nPorts=1,
    redeclare each final package Medium = Medium,
    each final use_T_in=true,
    each final use_C_in=Medium.nC > 0,
    each final m_flow=0,
    each final use_X_in=Medium.nXi > 0,
    each final use_m_flow_in=true) "Boundary conditions for HVAC system"
    annotation (Placement(transformation(extent={{-36,110},{-56,130}})));
  Conversion.InletToAir con[nFluPor](
      redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{74,110},{54,130}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRad
    "Radiative temperature sensor"
    annotation (Placement(transformation(extent={{42,-50},{62,-30}})));

  BaseClasses.X_w_toX x_w_toX[nFluPor](redeclare final package Medium = Medium)
    if Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{-4,110},{-16,122}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port for convective heat gain" annotation (Placement(transformation(
          extent={{-132,110},{-112,130}}),
                                        iconTransformation(extent={{-132,110},{-112,
            130}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Sources.Constant TSkin(
    k=TAveSkin,
    y(final unit="K",
      final displayUnit="degC"))
    "Skin temperature at which latent heat is added to the space"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Modelica.Blocks.Math.Gain mWatFlow(
    final k(unit="kg/J") = 1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s")) "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{58,-90},{78,-70}})));
public
   Modelica.Blocks.Interfaces.RealOutput mWat_flow(final
      unit="kg/s") "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
   Modelica.Blocks.Interfaces.RealOutput TWat(displayUnit="degC", final unit="K")
    "Skin temperature at which latent heat is added to the space"
    annotation (Placement(transformation(extent={{100,-140},{140,-100}})));
protected
  HeatTransfer.Sources.PrescribedHeatFlow conQLat_flow
    "Converter for latent heat flow rate"
    annotation (Placement(transformation(extent={{-26,50},{-46,70}})));
  HeatTransfer.Sources.PrescribedHeatFlow conQCon_flow
    "Converter for convective heat flow rate"
    annotation (Placement(transformation(extent={{-24,30},{-44,50}})));
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation

  for i in 1:nFluPor loop
    connect(bou[i].ports[1], ports[i]) annotation (Line(points={{-56,120},{-60,120},{-60,0},
          {-120,0}}, color={0,127,255}));
  end for;
  connect(QGaiCon_flow, mux.u2[1]) annotation (Line(points={{0,-160},{0,-88},{-8.88178e-16,
          -88}},                    color={0,0,127}));
  connect(QGaiLat_flow, mux.u3[1]) annotation (Line(points={{40,-160},{40,-120},
          {7,-120},{7,-88}},
                           color={0,0,127}));
  connect(x_i_toX.X_w, X_wZon)
    annotation (Line(points={{92,40},{92,40},{120,40}},     color={0,0,127}));
  connect(con.inlet, fluPor)
    annotation (Line(points={{75,120},{110,120}},      color={0,0,255}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{-17.2,116},{-17.2,116},
          {-34,116}},
                color={0,0,127}));
  connect(con.X_w, x_w_toX.X_w) annotation (Line(points={{52,116},{52,116},{
          -2.8,116}}, color={0,0,127}));
  connect(bou.C_in, con.C) annotation (Line(points={{-36,112},{-36,112},{-28,112},
          {-28,108},{26,108},{26,112},{52,112}},
                                            color={0,0,127}));
  connect(bou.T_in, con.T) annotation (Line(points={{-34,124},{52,124}},
                   color={0,0,127}));
  connect(heaPorAir, heaPorAir)
    annotation (Line(points={{-122,120},{-122,120}},
                                                   color={191,0,0}));
  connect(senTemAir.port, heaPorAir) annotation (Line(points={{30,80},{-110,80},
          {-110,120},{-122,120}},
                               color={191,0,0}));
  connect(senTemAir.T, TZon)
    annotation (Line(points={{50,80},{50,80},{120,80}},
                                                 color={0,0,127}));
  connect(CSup.y, CZon)
    annotation (Line(points={{61,0},{61,0},{120,0}},       color={0,0,127}));
  connect(XiSup.y, x_i_toX.Xi)
    annotation (Line(points={{61,40},{68,40}},
                                             color={0,0,127}));

  connect(mux.y[3], mWatFlow.u) annotation (Line(points={{-0.666667,-65},{
          -0.666667,0},{20,0},{20,-80},{56,-80}},
                                        color={0,0,127}));
  connect(mWatFlow.y, mWat_flow)
    annotation (Line(points={{79,-80},{80,-80},{120,-80}}, color={0,0,127}));
  connect(QGaiRad_flow, mux.u1[1]) annotation (Line(points={{-40,-160},{-40,-160},
          {-40,-120},{-7,-120},{-7,-88}},
                                        color={0,0,127}));
  connect(TSkin.y, TWat)
    annotation (Line(points={{81,-120},{120,-120}}, color={0,0,127}));
  connect(mux.y[2], conQCon_flow.Q_flow) annotation (Line(points={{6.66134e-16,-65},
          {6.66134e-16,40},{-24,40}}, color={0,0,127}));
  connect(conQCon_flow.port, heaPorAir) annotation (Line(points={{-44,40},{-84,40},
          {-84,102},{-106,102},{-106,120},{-122,120}}, color={191,0,0}));
  connect(mux.y[3], conQLat_flow.Q_flow) annotation (Line(points={{-0.666667,
          -65},{0,-65},{0,60},{-26,60}},
                                    color={0,0,127}));
  connect(conQLat_flow.port, heaPorAir) annotation (Line(points={{-46,60},{-74,60},
          {-74,104},{-100,104},{-100,120},{-122,120}}, color={191,0,0}));
  connect(senTemRad.T, TRad) annotation (Line(points={{62,-40},{72,-40},{80,-40},
          {120,-40}}, color={0,0,127}));
  connect(heaPorRad, senTemRad.port) annotation (Line(points={{-122,-100},{-102,
          -100},{-80,-100},{-80,-40},{42,-40}}, color={191,0,0}));

  connect(con.m_flow, bou.m_flow_in)
    annotation (Line(points={{52,128},{52,128},{-36,128}},color={0,0,127}));
  annotation (defaultComponentName="theZonAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-140},{100,160}}), graphics={
                                   Rectangle(
          extent={{-120,160},{100,-140}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Text(
          extent={{-146,114},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-110,20},{-42,12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-110,-8},{-42,-16}},
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
Model that is used as an adapter between a thermal 
zone that uses fluid ports and an HVAC system that 
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
<a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">
Buildings.Fluid.FMI.RoomConvective
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{100,
            160}})));
end HVACAdaptor;
