within Buildings.Fluid.HeatPumps.BaseClasses;
partial model PartialWaterToWater
  "Partial model for water to water heat pumps and chillers"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1 = dp1_nominal > 0,
    final computeFlowResistance2 = dp2_nominal > 0);

  replaceable package ref = Buildings.Media.Refrigerants.R410A
    "Refrigerant in the component"
    annotation (choicesAllMatching = true);

  parameter Boolean enable_variable_speed = true
    "Set to true to allow modulating of compressor speed";

  parameter Real scaling_factor = 1.0
    "Scaling factor for heat pump capacity";

  parameter Modelica.SIunits.ThermalConductance UACon
    "Thermal conductance of condenser";

  parameter Modelica.SIunits.ThermalConductance UAEva
    "Thermal conductance of evaporator";

  parameter Modelica.SIunits.Time tau1=60
    "Time constant at nominal flow rate (used if energyDynamics1 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Time tau2=60
    "Time constant at nominal flow rate (used if energyDynamics2 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.SIunits.Temperature T1_start=Medium1.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Temperature T2_start=Medium2.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics", group="Evaporator and condenser"));

  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput y(final unit = "1") if
    enable_variable_speed == true
    "Modulating signal for compressor frequency, equal to 1 at full load condition"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));

  Modelica.Blocks.Interfaces.IntegerInput stage if
    enable_variable_speed == false
    "Current stage of the heat pump, equal to 1 at full load condition"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));

  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    min = 0,
    final quantity="HeatFlowRate",
    final unit="W") "Actual heating heat flow rate added to fluid 1"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    min = 0,
    final quantity="Power",
    final unit="W") "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    max = 0,
    final quantity="HeatFlowRate",
    final unit="W") "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  HeatExchangers.EvaporatorCondenser con(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal,
    final m_flow_small=m1_flow_small,
    m_flow(start=m1_flow_nominal),
    final from_dp=from_dp1,
    final dp_nominal=dp1_nominal,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final deltaM=deltaM1,
    final tau=tau1,
    final T_start=T1_start,
    final energyDynamics=energyDynamics,
    final homotopyInitialization=homotopyInitialization,
    final UA=UACon)
    "Condenser"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  HeatExchangers.EvaporatorCondenser eva(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=m2_flow_nominal,
    final m_flow_small=m2_flow_small,
    m_flow(start=m2_flow_nominal),
    final from_dp=from_dp2,
    final dp_nominal=dp2_nominal,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final tau=tau2,
    final T_start=T2_start,
    final energyDynamics=energyDynamics,
    final homotopyInitialization=homotopyInitialization,
    final UA=UAEva)
    "Evaporator"
    annotation (Placement(transformation(extent={{10,-50},{-10,-70}})));

  replaceable Buildings.Fluid.HeatPumps.Compressors.BaseClasses.PartialCompressor com
    "Compressor"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-6})));

protected
  Modelica.Blocks.Math.IntegerToReal integerToReal if
    enable_variable_speed == false
    "Conversion for stage signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Blocks.Nonlinear.Limiter limiter(
    final uMin=0,
    final uMax=1) if
    enable_variable_speed == false
    "Limiter for control signal"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));

equation
  connect(port_a1, con.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(con.port_b, port_b1)
    annotation (Line(points={{10,60},{56,60},{100,60}}, color={0,127,255}));
  connect(con.Q_flow, QCon_flow) annotation (Line(points={{11,66},{60,66},{60,90},
          {110,90}}, color={0,0,127}));
  connect(eva.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(eva.port_b, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{-11,-66},{-20,-66},{-20,
          -90},{110,-90}}, color={0,0,127}));
  connect(com.port_b, con.port_ref)
    annotation (Line(points={{0,4},{0,29},{0,54}}, color={191,0,0}));
  connect(com.port_a, eva.port_ref) annotation (Line(points={{-4.44089e-016,-16},
          {0,-16},{0,-54}}, color={191,0,0}));
  connect(com.P, P)
    annotation (Line(points={{11,0},{110,0}},         color={0,0,127}));
  if enable_variable_speed then
    connect(y,com.y)
      annotation (Line(points={{-120,30},{-66,30},{-66,0},{-11,0}},
        color={0,0,127}));
  else
    connect(limiter.y, com.y) annotation (Line(points={{-29,-30},{-20,-30},{-20,0},
          {-11,0}}, color={0,0,127}));
  end if;
  connect(stage, integerToReal.u) annotation (Line(points={{-120,30},{-120,30},{
          -92,30},{-92,-16},{-92,-30},{-82,-30}},                   color={255,127,
          0}));
  connect(integerToReal.y, limiter.u)
    annotation (Line(points={{-59,-30},{-52,-30}}, color={0,0,127}));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,68},{0,90},{90,90},{100,90}},
                                                 color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255}),
        Line(points={{62,0},{100,0}},                 color={0,0,255})}),
    defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
Partial model for a water to water heat pump, as detailed in Jin (2002). The
model for the comrpessor is a partial model and needs to be replaced by one of the
compressor models in <a href = \"modelica://Buildings.Fluid.Chillers.Compressors\">
Buildings.Fluid.Chillers.Compressors</a>.
</p>
<h4>References</h4>
<p>
H. Jin.
<i>
Parameter estimation based models of water source heat pumps.
</i>
PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterToWater;
