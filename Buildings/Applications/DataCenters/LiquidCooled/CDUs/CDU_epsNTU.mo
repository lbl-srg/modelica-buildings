within Buildings.Applications.DataCenters.LiquidCooled.CDUs;
model CDU_epsNTU "CDU using epsilon-NTU for heat transfer"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

  parameter Real r_nominal(min=0)=
      (k1_default * (m1_flow_nominal/eta1_default)^n1 * Pr1_default^(1/3)) /
      (k2_default * (m2_flow_nominal/eta2_default)^n2 * Pr2_default^(1/3))
    "Ratio between convective heat transfer coefficients at nominal conditions, r_nominal = hA1_nominal/hA2_nominal"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

  parameter Real n1(min=0, max=1)=0.8
    "Exponent for convective heat transfer coefficient, h1~m1_flow^n1"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));
  parameter Real n2(min=0, max=1)=n1
   "Exponent for convective heat transfer coefficient, h2~m2_flow^n2"
   annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration =
   Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
   "Heat exchanger configuration"
    annotation (Evaluate=true);

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0)
    "Nominal heat flow rate (negative as it is for cooling)"
    annotation (Dialog(group="Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature T_a1_nominal
    "Nominal temperature at port a1" annotation (Dialog(group=
          "Nominal thermal performance"));
  parameter Modelica.Units.SI.Temperature T_a2_nominal
    "Nominal temperature at port a2" annotation (Dialog(group=
          "Nominal thermal performance"));

  // Flow resistance parameters
  parameter Boolean computeFlowResistance1 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));
  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance1,
                tab="Flow resistance", group="Medium 1"));
  parameter Modelica.Units.SI.PressureDifference dpHex1_nominal(
    min=0,
    displayUnit="Pa")= 80000 "Heat exchanger design pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance1,
               tab="Flow resistance", group="Medium 1"));
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance1,
                      tab="Flow resistance", group="Medium 1"));
  parameter Boolean computeFlowResistance2 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 2"));

  parameter Boolean from_dp2 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance2,
                tab="Flow resistance", group="Medium 2"));
  parameter Modelica.Units.SI.PressureDifference dpHex2_nominal(
    min=0,
    displayUnit="Pa") = dpHex1_nominal "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean linearizeFlowResistance2 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance2,
               tab="Flow resistance", group="Medium 2"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance2,
                      tab="Flow resistance", group="Medium 2"));

  final parameter Medium1.DynamicViscosity eta1_default = Medium1.dynamicViscosity(sta1_default) "Dynamic viscosity";
  final parameter Medium1.ThermalConductivity k1_default = Medium1.thermalConductivity(sta1_default) "Thermal conductivity";
  final parameter Medium1.PrandtlNumber Pr1_default = Medium1.prandtlNumber(sta1_default) "Prandtl number";
  final parameter Medium2.DynamicViscosity eta2_default = Medium2.dynamicViscosity(sta2_default) "Dynamic viscosity";
  final parameter Medium2.ThermalConductivity k2_default = Medium2.thermalConductivity(sta2_default) "Thermal conductivity";
  final parameter Medium2.PrandtlNumber Pr2_default = Medium2.prandtlNumber(sta2_default) "Prandtl number";

  // Valve
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal = dpHex1_nominal
    "Nominal pressure drop of fully open valve, used if val.CvData=Buildings.Fluid.Types.CvTypes.OpPoint"
    annotation (Dialog(group="Valve"));

  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close valve using strokeTime"
    annotation (Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to fully open or close actuator"
    annotation (Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.Blocks.Types.Init initVal=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (Dialog(tab="Dynamics", group="Valve"));
  parameter Real yVal_start=1 "Initial position of actuator"
    annotation (Dialog(tab="Dynamics", group="Valve"));

  // Pump
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal
    "Nominal pressure head of pump for configuration of pressure curve, after subtracting dpHex2_nominal. I.e., this is the head for resistances external to the CDU"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Boolean use_riseTime=true
    "Set to true to continuously change motor speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Modelica.Units.SI.Time riseTime=30
    "Time needed to change motor speed between zero and full speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Real yPum_start=0 "Initial value of speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));

  //Connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal(
    min=0,
    max=1,
    final unit="1")
    "Valve position (0: closed, 1: open)" annotation (Placement(transformation(
          extent={{-140,0},{-100,40}}), iconTransformation(extent={{-140,70},{-100,
            110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yPum(
    min=0,
    max=1,
    final unit="1")
    "Normalized rotational speed of pump" annotation (Placement(
        transformation(extent={{-140,-40},{-100,0}}), iconTransformation(extent={{-140,
            -110},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{90,70},{110,90}})));

  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final dp1_nominal=dpHex1_nominal,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final dp2_nominal=dpHex2_nominal,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final configuration=configuration,
    final use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal,
    final r_nominal=r_nominal,
    final n1=n1,
    final n2=n2)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_nominal=m1_flow_nominal,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final dpValve_nominal=dpValve_nominal,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=initVal,
    final y_start=yVal_start) "Control valve on chilled water side"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,20})));

  Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare package Medium = Medium2,
    energyDynamics=energyDynamics,
    allowFlowReversal=allowFlowReversal2,
    tau=tau,
    use_riseTime=use_riseTime,
    riseTime=riseTime,
    y_start=yPum_start,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=dpPum_nominal+dpHex2_nominal) "Pump on IT side"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-20})));

protected
  final parameter Medium1.ThermodynamicState sta1_default=Medium1.setState_pTX(
      T=Medium1.T_default,
      p=Medium1.p_default,
      X=Medium1.X_default[1:Medium1.nXi]) "Default state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_default=Medium2.setState_pTX(
      T=Medium2.T_default,
      p=Medium2.p_default,
      X=Medium2.X_default[1:Medium2.nXi]) "Default state for medium 2";
equation
  connect(port_a1, val.port_a)
    annotation (Line(points={{-100,60},{-40,60},{-40,30}}, color={0,127,255}));
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-40,10},{-40,6},{-10,6}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{40,6},{40,60},{
          100,60}}, color={0,127,255}));
  connect(port_b2,pum. port_b) annotation (Line(points={{-100,-60},{-40,-60},{-40,
          -30}}, color={0,127,255}));
  connect(pum.port_a, hex.port_b2)
    annotation (Line(points={{-40,-10},{-40,-6},{-10,-6}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{40,-6},{40,-60},
          {100,-60}}, color={0,127,255}));
  connect(pum.y, yPum)
    annotation (Line(points={{-52,-20},{-120,-20}}, color={0,0,127}));
  connect(val.y, yVal)
    annotation (Line(points={{-52,20},{-120,20}}, color={0,0,127}));
  connect(pum.P, P) annotation (Line(points={{-49,-31},{-49,-40},{60,-40},{60,90},
          {110,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,30},{34,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,65},{-80,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-57},{-22,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,60},
          rotation=270),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={-60,84},
          rotation=90),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-60,60},
          rotation=180),
        Rectangle(
          extent={{-40,65},{-22,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,64},{100,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-17,4},{17,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={26,47},
          rotation=90),
        Rectangle(
          extent={{-17,4},{17,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-26,47},
          rotation=90),
        Ellipse(
          extent={{-80,-40},{-40,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-80,-60},{-60,-40},{-60,-80},{-80,-60}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-17.5,3.5},{17.5,-3.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-25.5,-47.5},
          rotation=90),
        Rectangle(
          extent={{-17,3},{17,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={27,-47},
          rotation=90),
        Rectangle(
          extent={{24,-55},{96,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-30,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-70,90},
          rotation=360),
        Line(
          points={{-40,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,-90},
          rotation=360),
        Line(
          points={{-10,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,-90},
          rotation=270)}),
  defaultComponentName="cdu",
  Documentation(
    info="<html>
<p>
Model of a coolant distribution unit (CDU) with built in two-way valve on the chilled
water side and pump on the IT side as shown in the figure below.
</p>
<p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/LiquidCooled/CDUs/CDU_epsNTU.png\"
         alt=\"Schematic diagram of the CDU.\"
         style=\"width: 100%; height: auto;\">
<p>
</p>
<p>
This CDU models a plate heat exchanger using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</a>, and hence
the heat transfer is calculated using epsilon-NTU correlations with convection coefficients
that are a function of the flow rate.
</p>
<p>
On the chilled water side, denoted with index <i>1</i>, is a three-way valve with equal-percentage
opening characteristics. By default, the valve pressure drop is set to the same value
as the heat exchanger pressure drop, achieving a valve authority of <i>0.5</i>.
The valve is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage\">
Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage</a>.
</p>
<p>
On the IT water side, denoted with index <i>2</i>, is a circulation pump with
pre-configured head. Note that the head, specified through the parameter <code>dpPum_nominal</code>,
which is the head of the pump. Hence, to specify the head available for the flow resistance
of the network connected to the CDU, add the CDU's heat exchanger flow resistance <code>dpHex_nominal</code>
to the pump head.
The pump is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y\">
Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CDU_epsNTU;
