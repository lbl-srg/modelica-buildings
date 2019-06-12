within Buildings.Fluid.HeatPumps.BaseClasses;
model PartialEquationFitWaterToWater "Model transporting two fluid streams between four ports with storing mass or energy"


 extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
 extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1 = dp1_nominal > 0,
    final computeFlowResistance2 = dp2_nominal > 0);




  Modelica.SIunits.HeatFlowRate Q1_flow = vol1.heatPort.Q_flow
    "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow = vol2.heatPort.Q_flow
    "Heat flow rate into medium 2";

  replaceable Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort vol1(nPorts=2)
    constrainedby
    Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort(
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

  replaceable Buildings.Fluid.MixingVolumes.MixingVolume vol2(nPorts=2)
    constrainedby
    Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort(
        redeclare final package Medium = Medium2,
        nPorts = 2,
        V=m2_flow_nominal*tau2/rho2_nominal,
        final allowFlowReversal=allowFlowReversal2,
        mSenFac=1,
        final m_flow_nominal = m2_flow_nominal,
        energyDynamics=if tau2 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
        massDynamics=if tau2 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
        final p_start=p2_start,
        final T_start=T2_start,
        final X_start=X2_start,
        final C_start=C2_start,
        final C_nominal=C2_nominal) "Volume for fluid 2"
   annotation (Placement(transformation(
        origin={2,-60},
        extent={{-10,10},{10,-10}},
        rotation=180)));

  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final deltaM=deltaM1,
    final allowFlowReversal=allowFlowReversal1,
    final show_T=false,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp1_nominal) "Flow resistance of fluid 1"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final deltaM=deltaM2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=false,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp2_nominal) "Flow resistance of fluid 2"
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));

  Sensors.MassFlowRate mCon_flow(redeclare package Medium = Medium1) annotation (Placement(transformation(extent={{64,50},{84,70}})));
   Sensors.TemperatureTwoPort TConLvg(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=false,
    tau=0) "Condenser leaving water temperature" annotation (Placement(transformation(extent={{40,50},{60,70}})));
 Sensors.TemperatureTwoPort                 TConEnt(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=false,
    tau=0) "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-56,70},{-36,90}})));
 Sensors.TemperatureTwoPort                 TEvaEnt(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    allowFlowReversal=false,
    tau=0) "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{52,-90},{32,-70}})));
   Sensors.TemperatureTwoPort TEvaLvg(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    allowFlowReversal=false,
    tau=0) "Evaporator leaving water temperature" annotation (Placement(transformation(extent={{-22,-70},{-42,-50}})));
  Sensors.MassFlowRate mEva_flow(redeclare package Medium = Medium2) "Mass flow rate sensor" annotation (Placement(transformation(extent={{-48,-70},{-68,-50}})));
protected
  parameter Medium1.ThermodynamicState sta1_nominal=Medium1.setState_pTX(
      T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho1_nominal=Medium1.density(sta1_nominal)
    "Density, used to compute fluid volume";
  parameter Medium2.ThermodynamicState sta2_nominal=Medium2.setState_pTX(
      T=Medium2.T_default, p=Medium2.p_default, X=Medium2.X_default);
  parameter Modelica.SIunits.Density rho2_nominal=Medium2.density(sta2_nominal)
    "Density, used to compute fluid volume";

  parameter Medium1.ThermodynamicState sta1_start=Medium1.setState_pTX(
      T=T1_start, p=p1_start, X=X1_start);
  parameter Modelica.SIunits.SpecificEnthalpy h1_outflow_start = Medium1.specificEnthalpy(sta1_start)
    "Start value for outflowing enthalpy";
  parameter Medium2.ThermodynamicState sta2_start=Medium2.setState_pTX(
      T=T2_start, p=p2_start, X=X2_start);
  parameter Modelica.SIunits.SpecificEnthalpy h2_outflow_start = Medium2.specificEnthalpy(sta2_start)
    "Start value for outflowing enthalpy";

initial equation
  // Check for tau1
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");

 // Check for tau2
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");

equation
  connect(port_a1, preDro1.port_a) annotation (Line(
      points={{-100,60},{-90,60},{-90,80},{-80,80}},
      color={0,127,255}));
  connect(port_a2, preDro2.port_a) annotation (Line(
      points={{100,-60},{90,-60},{90,-80},{80,-80}},
      color={0,127,255}));
  connect(port_b1, mCon_flow.port_b) annotation (Line(points={{100,60},{84,60}}, color={0,127,255}));
  connect(mCon_flow.port_a, TConLvg.port_b) annotation (Line(points={{64,60},{60,60}}, color={0,127,255}));
  connect(TConLvg.port_a, vol1.ports[1]) annotation (Line(points={{40,60},{16,60},{16,70},{-2,70}}, color={0,127,255}));
  connect(preDro1.port_b, TConEnt.port_a) annotation (Line(points={{-60,80},{-56,80}}, color={0,127,255}));
  connect(vol1.ports[2], TConEnt.port_b) annotation (Line(points={{2,70},{-2,70},{-2,80},{-36,80}}, color={0,127,255}));
  connect(preDro2.port_b, TEvaEnt.port_a) annotation (Line(points={{60,-80},{52,-80}}, color={0,127,255}));
  connect(vol2.ports[1], TEvaEnt.port_b) annotation (Line(points={{4,-70},{4,-70},{4,-80},{32,-80}}, color={0,127,255}));
  connect(vol2.ports[2], TEvaLvg.port_a) annotation (Line(points={{-1.77636e-15,-70},{-12,-70},{-12,-60},{-22,-60}}, color={0,127,255}));
  connect(TEvaLvg.port_b, mEva_flow.port_a) annotation (Line(points={{-42,-60},{-48,-60}}, color={0,127,255}));
  connect(mEva_flow.port_b, port_b2) annotation (Line(points={{-68,-60},{-100,-60}}, color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports.
It provides the basic model for implementing a dynamic heat exchanger.
</p>
<p>
The model can be used as-is, although there will be no heat or mass transfer
between the two fluid streams.
To add heat transfer, heat flow can be added to the heat port of the two volumes.
See for example
<a href=\"Buildings.Fluid.Chillers.Carnot_y\">
Buildings.Fluid.Chillers.Carnot_y</a>.
To add moisture input into (or moisture output from) volume <code>vol2</code>,
the model can be replaced with
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
</p>
<h4>Implementation</h4>
<p>
The variable names follow the conventions used in
<a href=\"modelica://Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX\">
Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2017, by Michael Wetter:<br/>
Made volume <code>vol1</code> replaceable. This is required for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Updated model as <code>use_dh</code> is no longer a parameter in the pressure drop model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Set <code>quantity</code> attributes.
</li>
<li>
November 13, 2015, by Michael Wetter:<br/>
Changed assignments of start values in <code>extends</code> statement.
This is for issue
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/299\">#299</a>.
</li>
<li>
June 2, 2015, by Filip Jorissen:<br/>
Removed final modifier from <code>mSenFac</code> in
<code>vol1</code> and <code>vol2</code>.
This is for issue
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/258=\">#258</a>.
</li>
<li>
May 6, 2015, by Michael Wetter:<br/>
Added missing propagation of <code>allowFlowReversal</code> to
instances <code>vol1</code> and <code>vol2</code>.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/412\">#412</a>.
</li>
<li>
October 6, 2014, by Michael Wetter:<br/>
Changed medium declaration in pressure drop elements to be final.
</li>
<li>
May 28, 2014, by Michael Wetter:<br/>
Removed <code>annotation(Evaluate=true)</code> for parameters <code>tau1</code>
and <code>tau2</code>.
This is needed to allow changing the time constant after translation.
</li>
<li>
November 12, 2013, by Michael Wetter:<br/>
Removed <code>import Modelica.Constants</code> statement.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 26, 2013, by Michael Wetter:<br/>
Removed unrequired <code>sum</code> operator.
</li>
<li>
February 6, 2012, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in its base class.
</li>
<li>
July 29, 2011, by Michael Wetter:
<ul>
<li>
Changed values of
<code>h_outflow_a1_start</code>,
<code>h_outflow_b1_start</code>,
<code>h_outflow_a2_start</code> and
<code>h_outflow_b2_start</code>, and
declared them as final.
</li>
<li>
Set nominal values for <code>vol1.C</code> and <code>vol2.C</code>.
</li>
</ul>
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Changed parameterization of fluid volume so that steady-state balance is
used when <code>tau = 0</code>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy operator.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
September 10, 2008 by Michael Wetter:<br/>
Added <code>stateSelect=StateSelect.always</code> for temperature of volume 1.
</li>
<li>
Changed temperature sensor from Celsius to Kelvin.
Unit conversion should be made during output
processing.
</li>
<li>
August 5, 2008, by Michael Wetter:<br/>
Replaced instances of <code>Delays.DelayFirstOrder</code> with instances of
<code>MixingVolumes.MixingVolume</code>. This allows to extract liquid for a condensing cooling
coil model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,64},{102,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-56},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end PartialEquationFitWaterToWater;
