within Buildings.Fluid.FMI;
model HVACAdaptor "Model for exposing a room model to the FMI interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nPorts(final min = 1) "Number of ports"
    annotation(Dialog(connectorSizing=true));

  Modelica.Blocks.Interfaces.RealOutput TZon(final unit="K",
                                            displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput X_wZon(
    final unit = "kg/kg") "Zone air water mass fraction per total air mass"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealOutput CZon[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));

   Interfaces.Inlet supAir[nPorts](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=false,
    each final use_p_in=false) "Supply air connectorFluid outlet"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts+1](
    redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,40},{-90,-40}})));

   Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(final unit="W")
    "Radiant heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-60,-140})));
  Modelica.Blocks.Interfaces.RealInput QGaiCon_flow(final unit="W")
    "Convective sensible heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-140})));
  Modelica.Blocks.Interfaces.RealInput QGaiLat_flow(final unit="W")
    "Latent heat input into zone (positive if heat gain)"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={60,-140})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorRad
    "Heat port for radiative heat gain and radiative temperature" annotation (
      Placement(transformation(extent={{-112,-90},{-92,-70}}),
                                                           iconTransformation(
          extent={{-112,-90},{-92,-70}})));
   Modelica.Blocks.Interfaces.RealOutput TRad(final unit="K", displayUnit="degC")
    "Zone radiative temperature"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));

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

  Rooms.BaseClasses.MixedAirHeatGain           heaGai(
    redeclare package Medium = Medium, final AFlo=1)
    "Model to convert internal heat gains. In this model, AFlo is set to 1 because of its inputs which are already in W."
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-28})));

  x_i_toX_w x_i_toX(
    redeclare final package Medium = Medium) if
       Medium.nXi > 0 "Conversion from x_i to X_w"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Modelica.Blocks.Routing.Multiplex3 mux annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-60})));

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
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  RealVectorExpression CSup(each final n=Medium.nC, final y=inStream(ports[1].C_outflow)) if
       Medium.nC > 0 "Trace substance concentration of supply air"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Sources.MassFlowSource_T bou[nPorts](
    each final nPorts=1,
    redeclare each final package Medium = Medium,
    each final use_m_flow_in=false,
    each final use_T_in=true,
    each final use_C_in=Medium.nC > 0,
    each final m_flow=0,
    each final use_X_in=Medium.nXi > 0) "Boundary conditions for HVAC system"
    annotation (Placement(transformation(extent={{-38,70},{-58,90}})));
  Conversion.InletToAir con[nPorts](
      redeclare each final package Medium = Medium)
    annotation (Placement(transformation(extent={{54,74},{74,94}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRad
    "Radiative temperature sensor"
    annotation (Placement(transformation(extent={{42,-90},{62,-70}})));

  BaseClasses.X_w_toX x_w_toX[nPorts](redeclare final package Medium = Medium)
    if Medium.nXi > 0 "Conversion from X_w to X"
    annotation (Placement(transformation(extent={{-4,70},{-16,82}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port for convective heat gain" annotation (Placement(transformation(
          extent={{-110,70},{-90,90}}), iconTransformation(extent={{-110,66},{-90,
            86}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemAir
    "Room air temperature sensor"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation

  for i in 1:nPorts loop
      connect(bou[i].ports[1], ports[i]) annotation (Line(points={{-58,80},{-70,
            80},{-80,80},{-80,0},{-100,0}},
                             color={0,127,255}));
  end for;
  connect(QGaiRad_flow, mux.u1[1]) annotation (Line(points={{-60,-140},{-60,
          -140},{-60,-100},{-7,-100},{-7,-72}},
                                        color={0,0,127}));
  connect(QGaiCon_flow, mux.u2[1]) annotation (Line(points={{0,-140},{0,-140},{
          0,-72},{-8.88178e-16,-72}},
                                    color={0,0,127}));
  connect(QGaiLat_flow, mux.u3[1]) annotation (Line(points={{60,-140},{60,-100},
          {7,-100},{7,-72}},
                           color={0,0,127}));
  connect(heaGai.QLat_flow, ports[nPorts+1]) annotation (Line(points={{6,-18},{
          6,-18},{6,-2},{-100,-2},{-100,0}},
                                     color={0,127,255}));
  connect(x_i_toX.X_w, X_wZon)
    annotation (Line(points={{92,0},{92,0},{120,0}},        color={0,0,127}));
  connect(X_wZon, X_wZon)
    annotation (Line(points={{120,0},{120,0}}, color={0,0,127}));
  connect(senTemRad.port, heaPorRad)
    annotation (Line(points={{42,-80},{-78,-80},{-102,-80}},
                                                    color={191,0,0}));
  connect(con.inlet, supAir)
    annotation (Line(points={{75,84},{92,84},{92,80},{110,80}},
                                                       color={0,0,255}));
  connect(x_w_toX.X, bou.X_in) annotation (Line(points={{-17.2,76},{-17.2,76},{
          -36,76}},
                color={0,0,127}));
  connect(con.X_w, x_w_toX.X_w) annotation (Line(points={{52,80},{14,80},{14,76},
          {-2.8,76}}, color={0,0,127}));
  connect(bou.C_in, con.C) annotation (Line(points={{-38,72},{-34,72},{-28,72},
          {-28,68},{26,68},{26,76},{52,76}},color={0,0,127}));
  connect(bou.T_in, con.T) annotation (Line(points={{-36,84},{-30,84},{-30,88},
          {52,88}},color={0,0,127}));
  connect(heaGai.QCon_flow, heaPorAir) annotation (Line(points={{6.66134e-16,
          -18},{0,-18},{0,10},{-88,10},{-88,80},{-100,80}},
                                               color={191,0,0}));
  connect(heaPorAir, heaPorAir)
    annotation (Line(points={{-100,80},{-100,80}}, color={191,0,0}));
  connect(senTemAir.port, heaPorAir) annotation (Line(points={{30,40},{-88,40},
          {-88,80},{-100,80}}, color={191,0,0}));
  connect(senTemAir.T, TZon)
    annotation (Line(points={{50,40},{50,40},{120,40}},
                                                 color={0,0,127}));
  connect(CSup.y, CZon)
    annotation (Line(points={{61,-40},{61,-40},{120,-40}}, color={0,0,127}));
  connect(XiSup.y, x_i_toX.Xi)
    annotation (Line(points={{61,0},{68,0}}, color={0,0,127}));
  connect(senTemRad.T, TRad)
    annotation (Line(points={{62,-80},{120,-80},{120,-80}}, color={0,0,127}));
  connect(mux.y, heaGai.qGai_flow)
    annotation (Line(points={{0,-49},{0,-40},{0,-40}}, color={0,0,127}));
  annotation (defaultComponentName="theZonAda",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-120},{100,120}}), graphics={
                                   Rectangle(
          extent={{-100,120},{100,-120}},
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
<p>Model that is used as an adapter between a thermal zone that uses fluid ports and an HVAC system that uses input and output signals as needed for an FMU. </p>
<h4>Assumption and limitations</h4>
<p>The mass flow rates at <code>ports</code> sum to zero, hence this model conserves mass. </p>
<p>This model does not impose any pressure, other than setting the pressure of all fluid connections to <code>ports</code> to be equal. The reason is that setting a pressure can lead to non-physical system models, for example if a mass flow rate is imposed and the thermal zone is connected to a model that sets a pressure boundary condition such as <a href=\"modelica://Buildings.Fluid.Sources.Outside\">Buildings.Fluid.Sources.Outside</a>.</p>
<h4>Typical use and important parameters</h4>
<p>See <a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">Buildings.Fluid.FMI.RoomConvective</a> for a model that uses this model. </p>
</html>", revisions="<html>
<ul>
<li>April 27, 2016, by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            120}})));
end HVACAdaptor;
