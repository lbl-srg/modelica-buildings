within Buildings.Fluid.HeatPumps.Data;
model TEST "simplified example"

package Medium                         "Medium model"
                 extends Buildings.Media.Water;
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
      h_outflow(start=h1_outflow_start, nominal=Medium1.h_default),
      redeclare final package Medium = Medium1,
      m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
      h_outflow(start=h1_outflow_start, nominal=Medium1.h_default),
      redeclare final package Medium = Medium1,
      m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
      h_outflow(start=h2_outflow_start, nominal=Medium2.h_default),
      redeclare final package Medium = Medium2,
      m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
      h_outflow(start=h2_outflow_start, nominal=Medium2.h_default),
      redeclare final package Medium = Medium2,
      m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));
  replaceable MixingVolumes.BaseClasses.MixingVolumeHeatPort                 vol1(final
        prescribedHeatFlowRate=true)
    constrainedby MixingVolumes.BaseClasses.MixingVolumeHeatPort(
        redeclare final package Medium = Medium1,
        nPorts = 2,
        V=m1_flow_nominal*tau1/rho1_nominal,
        final allowFlowReversal=allowFlowReversal1,
        final m_flow_nominal=m1_flow_nominal,
        energyDynamics=if tau1 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
        massDynamics=if tau1 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
        final p_start=p1_start,
        final T_start=T1_start,
        final X_start=X1_start,
        final C_start=C1_start,
        final C_nominal=C1_nominal,
        mSenFac=1) "Volume for fluid 1"
    annotation (Placement(transformation(extent={{-10,70}, {10,50}})));
              MixingVolumes.MixingVolume                 vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true,
      redeclare final package Medium = Medium2,
      final allowFlowReversal=allowFlowReversal2,
      mSenFac=1,
      final m_flow_nominal=m2_flow_nominal,
      energyDynamics=if tau2 > Modelica.Constants.eps then energyDynamics else
          Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=if tau2 > Modelica.Constants.eps then massDynamics else
          Modelica.Fluid.Types.Dynamics.SteadyState,
      final p_start=p2_start,
      final T_start=T2_start,
      final X_start=X2_start,
      final C_start=C2_start,
      final C_nominal=C2_nominal)   "Volume for fluid 2"
   annotation (Placement(transformation(
        origin={2,-60},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  FixedResistances.PressureDrop                 preDro1(
      redeclare final package Medium = Medium1,
      final m_flow_nominal=m1_flow_nominal,
      final deltaM=deltaM1,
      final allowFlowReversal=allowFlowReversal1,
      final show_T=false,
      final from_dp=from_dp1,
      final linearized=linearizeFlowResistance1,
      final homotopyInitialization=homotopyInitialization,
      final dp_nominal=dp1_nominal)
                                  "Flow resistance of fluid 1"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  FixedResistances.PressureDrop                 preDro2(
      redeclare final package Medium = Medium2,
      final m_flow_nominal=m2_flow_nominal,
      final deltaM=deltaM2,
      final allowFlowReversal=allowFlowReversal2,
      final show_T=false,
      final from_dp=from_dp2,
      final linearized=linearizeFlowResistance2,
      final homotopyInitialization=homotopyInitialization,
      final dp_nominal=dp2_nominal)
                                  "Flow resistance of fluid 2"
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_in(final y=QCon_flow)
  "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-82,24},{-62,44}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-41,24},{-21,44}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(final y=QEva_flow)
    "Evaorator heat flow rate"
    annotation (Placement(transformation(extent={{-82,-50},{-62,-30}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-37,-50},{-17,-30}})));
  Modelica.Blocks.Interfaces.RealInput TSet_chilledwater(final unit="K",
        displayUnit="degC")
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
                iconTransformation(extent={{-140,-110},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput TSet_heatingwater(final unit="K",
        displayUnit="degC")
    "Set point for leaving heating water temperature"
    annotation (Placement(transformation(
                extent={{-140,70},{-100,110}}),iconTransformation(extent={{-140,70},
            {-100,110}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod "Heating mode= 1, Off=0, Cooling mode=-1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    parameter EquationFitWaterToWater.Generic_EquationFit per annotation (
        choicesAllMatching=true, Placement(transformation(extent={{48,12},{80,
              44}})));
    parameter EquationFitWaterToWater.setCond setCond
      annotation (Placement(transformation(extent={{56,-20},{76,0}})));
equation
  connect(vol1.ports[2],port_b1)  annotation (Line(
      points={{0,70},{20,70},{20,60},{100,60}},
      color={0,127,255}));
  connect(vol2.ports[2],port_b2)  annotation (Line(
      points={{-1.77636e-15,-70},{-30,-70},{-30,-60},{-100,-60}},
      color={0,127,255}));
  connect(port_a1,preDro1. port_a) annotation (Line(
      points={{-100,60},{-90,60},{-90,80},{-80,80}},
      color={0,127,255}));
  connect(preDro1.port_b,vol1. ports[1]) annotation (Line(
      points={{-60,80},{0,80},{0,70}},
      color={0,127,255}));
  connect(port_a2,preDro2. port_a) annotation (Line(
      points={{100,-60},{90,-60},{90,-80},{80,-80}},
      color={0,127,255}));
  connect(preDro2.port_b,vol2. ports[1]) annotation (Line(
      points={{60,-80},{4,-80},{4,-70}},
      color={0,127,255}));
  connect(QEva_flow_in.y,preHeaFloEva. Q_flow) annotation (Line(points={{-61,-40},{-37,-40}},
          color={0,0,127}));
  connect(QCon_flow_in.y,preHeaFloCon. Q_flow) annotation (Line(points={{-61,34},{-41,34}},
          color={0,0,127}));
  connect(preHeaFloCon.port,vol1.heatPort)
  annotation (Line(points={{-21,34},{-16,34},{-16,60},{-10,60}}, color={191,0,0}));
  connect(preHeaFloEva.port,vol2.heatPort)
  annotation (Line(points={{-17,-40},{-2,-40},{-2,-60},{12,-60}},
                                       color={191,0,0}));
end Medium;

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=0.00189
    "Nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=0.00189
    "Nominal mass flow rate";

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TEST;
