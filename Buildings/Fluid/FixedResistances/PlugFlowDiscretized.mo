within Buildings.Fluid.FixedResistances;
model PlugFlowDiscretized
  "Discretized pipe model using spatialDistribution for temperature delay"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Integer nSeg(min=1) = 1 "Number of axial segment";

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean have_pipCap=true
    "= true, a mixing volume is added to port_b that corresponds
    to the heat capacity of the pipe wall"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Length dh
    "Hydraulic diameter" annotation (Dialog(group="Material"));

  parameter Real ReC=4000
    "Reynolds number where transition to turbulence starts";

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Material"));
  parameter Modelica.SIunits.Length totLen = sum(segLen)
    "Total pipe length (used to compute segment length)"
    annotation (Dialog(group="Material"));
  parameter Modelica.SIunits.Length segLen[nSeg]=fill(totLen/nSeg, nSeg)
    "Pipe segment length"
    annotation (Dialog(group="Material"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Length dIns
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Thermal resistance"));
  parameter Modelica.SIunits.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Thermal resistance"));

  parameter Modelica.SIunits.Length thickness = 0.0035
    "Pipe wall thickness" annotation (Dialog(group="Material"));
  parameter Modelica.SIunits.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel"
    annotation (Dialog(group="Material"));
  parameter Modelica.SIunits.Density rhoPip(displayUnit="kg/m3")=930
    "Density of pipe wall material. 930 for PE, 8000 for steel"
    annotation (Dialog(group="Material"));

  parameter Modelica.SIunits.Temperature T_start_in[nSeg]=
    fill(Medium.T_default, nSeg) "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_start_out[nSeg]=
    T_start_in "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start=0 "Initial value of mass flow rate through pipe"
    annotation (Dialog(tab="Initialization", enable=initDelay));

  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  parameter Modelica.SIunits.MassFlowRate m_flow_small = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[nSeg]
    "Heat transfer to or from surrounding for each pipe segment (positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Modelica.SIunits.HeatFlowRate QEnv_flow = sum(heatPorts.Q_flow)
    "Heat transfer to or from surroundings of total pipe length (positive if pipe is colder than surrounding)";

  Modelica.SIunits.PressureDifference dp(displayUnit="Pa") = res.dp
    "Pressure difference between port_a and port_b";

  Modelica.SIunits.MassFlowRate m_flow = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  final parameter Modelica.SIunits.Velocity
    v_nominal = m_flow_nominal / (APip * rho_default)
    "Velocity at m_flow_nominal";

  Modelica.SIunits.Velocity v = del[1].v "Flow velocity of medium in pipe";

protected
  parameter Modelica.SIunits.Length rInt = dh / 2 "Pipe interior radius";

  parameter Modelica.SIunits.Area APip = Modelica.Constants.pi * rInt^2
    "Pipe hydraulic cross-sectional area";

  parameter Modelica.SIunits.HeatCapacity CPip[nSeg]=
    segLen*((dh + 2*thickness)^2 - dh^2)*Modelica.Constants.pi/4*cPip*rhoPip "Heat capacity of pipe wall";

  final parameter Modelica.SIunits.Volume VEqu[nSeg]=CPip ./ (rho_default*cp_default)
    "Equivalent water volume to represent pipe wall thermal inertia";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)";

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

  parameter Real C(unit="J/(K.m)")=
    rho_default*Modelica.Constants.pi*(dh/2)^2*cp_default
    "Thermal capacity per unit length of water in pipe";

  parameter Real R(unit="(m.K)/W")=1/(kIns*2*Modelica.Constants.pi/
    Modelica.Math.log((dh/2 + thickness + dIns)/(dh/2 + thickness)))
    "Thermal resistance per unit length from fluid to boundary temperature"
    annotation (Dialog(group="Thermal resistance"));

  FixedResistances.HydraulicDiameter res(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dh=dh,
    final from_dp=from_dp,
    final length=totLen,
    final roughness=roughness,
    final fac=fac,
    final ReC=ReC,
    final v_nominal=v_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearized,
    dp(nominal= if rho_default > 500 then totLen * fac * 200 else totLen * fac * 2))
    "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));


  // In the volume, below, we scale down V and use
  // mSenFac. Otherwise, for air, we would get very large volumes
  // which affect the delay of water vapor and contaminants.
  // See also Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.TransportWaterAir
  // for why mSenFac is 10 and not 1000, as this gives more reasonable
  // temperature step response
  Fluid.MixingVolumes.MixingVolume vol[nSeg](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal,
    final V=if rho_default > 500 then VEqu else VEqu/1000,
    each final nPorts=2,
    final T_start=T_start_out,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final mSenFac=if rho_default > 500 then 1 else 10) if have_pipCap
    "Control volume connected to port_b. Represents equivalent pipe wall thermal capacity."
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  LosslessPipe noMixPip[nSeg](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal,
    each final m_flow_small=m_flow_small,
    each final allowFlowReversal=allowFlowReversal) if not have_pipCap
    "Lossless pipe for connecting the outlet port when have_pipCap=false"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));

  BaseClasses.PlugFlow del[nSeg](
    redeclare each final package Medium = Medium,
    each final m_flow_small=m_flow_small,
    each final dh=dh,
    final length=segLen,
    each final allowFlowReversal=allowFlowReversal,
    final T_start_in=T_start_in,
    final T_start_out=T_start_out) "Model for temperature wave propagation"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  BaseClasses.PlugFlowHeatLoss heaLos_a[nSeg](
    redeclare each final package Medium = Medium,
    each final C=C,
    each final R=R,
    each final m_flow_small=m_flow_small,
    final T_start=T_start_in,
    each final m_flow_nominal=m_flow_nominal,
    each final m_flow_start=m_flow_start,
    each final show_T=false,
    each final show_V_flow=false) "Heat loss for flow from port_b to port_a"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  BaseClasses.PlugFlowHeatLoss heaLos_b[nSeg](
    redeclare each final package Medium = Medium,
    each final C=C,
    each final R=R,
    each final m_flow_small=m_flow_small,
    final T_start=T_start_out,
    each final m_flow_nominal=m_flow_nominal,
    each final m_flow_start=m_flow_start,
    each final show_T=false,
    each final show_V_flow=false) "Heat loss for flow from port_a to port_b"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  BaseClasses.PlugFlowTransportDelay timDel[nSeg](
    final length=segLen,
    each final dh=dh,
    each final rho=rho_default,
    each final initDelay=initDelay,
    each final m_flow_nominal=m_flow_nominal,
    each final m_flow_start=m_flow_start) "Time delay"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Sensors.MassFlowRate senMasFlo(
     redeclare final package Medium = Medium)
    "Mass flow sensor"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Routing.Replicator rep(nout=nSeg)
    "Replicates the input signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(res.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaLos_a[1].port_b)
    annotation (Line(points={{-70,0},{-60,0}}, color={0,127,255}));
  for i in 1:nSeg loop
  connect(heaLos_a[i].port_a, del[i].port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(del[i].port_b, heaLos_b[i].port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(heaLos_b[i].port_b, vol[i].ports[1])
    annotation (Line(points={{20,0},{38,0},{38,20}}, color={0,127,255}));
  connect(heaLos_b[i].port_b, noMixPip[i].port_a) annotation (Line(points={{20,0},
          {26,0},{26,-40},{30,-40}}, color={0,127,255}));
  end for;
  // Connections of last to first element
  for i in 1:nSeg-1 loop
    connect(vol[i].ports[2], heaLos_a[i+1].port_b) annotation (Line(points={{42,20},
            {42,20},{42,-20},{-60,-20},{-60,0}},
                                             color={0,127,255}));
    connect(noMixPip[i].port_b, heaLos_a[i+1].port_b) annotation (Line(points={{50,-40},
          {56,-40},{56,-60},{-60,-60},{-60,0}}, color={0,127,255}));
  end for;
  // Connection of last elements to resistance
  connect(noMixPip[nSeg].port_b, res.port_a) annotation (Line(points={{50,-40},{56,
          -40},{56,0},{60,0}}, color={0,127,255}));
  connect(vol[nSeg].ports[2], res.port_a) annotation (Line(points={{42,20},{56,20},
          {56,0},{60,0}},
                      color={0,127,255}));

  // Other connections


  connect(senMasFlo.m_flow, rep.u) annotation (Line(points={{-80,11},{-80,30},{-90,
          30},{-90,50},{-82,50}}, color={0,0,127}));
  connect(rep.y, timDel.m_flow)
    annotation (Line(points={{-59,50},{-42,50}}, color={0,0,127}));
  connect(timDel.tauRev, heaLos_a.tau) annotation (Line(points={{-19,54},{-10,54},
          {-10,30},{-44,30},{-44,10}}, color={0,0,127}));
  connect(timDel.tau, heaLos_b.tau)
    annotation (Line(points={{-19,46},{4,46},{4,10}}, color={0,0,127}));
  connect(heaLos_a.heatPort, heatPorts) annotation (Line(points={{-50,10},{-50,24},
          {-4,24},{-4,100},{0,100}},
                                   color={191,0,0}));
  connect(heaLos_b.heatPort, heatPorts) annotation (Line(points={{10,10},{10,24},
          {2,24},{2,100},{0,100}},
                                 color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-100,-72},{100,-88}},
          lineColor={0,0,0},
          textString="L[ ] = %segLen d = %dh"),
        Rectangle(
          extent={{-100,40},{0,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{0,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{0,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{0,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-64,30},{-34,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Rectangle(
          extent={{0,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{0,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{0,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{0,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{36,30},{66,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Line(
          points={{0,60},{0,-60}},
          color={0,0,0},
          thickness=1,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-56,58},{-44,46}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillPattern=FillPattern.Solid,
          fillColor={162,29,33},
          lineColor={0,0,0}),
        Rectangle(
          extent={{44,58},{56,46}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillPattern=FillPattern.Solid,
          fillColor={162,29,33},
          lineColor={0,0,0}),
        Line(
          points={{-50,52},{-50,70},{50,70},{50,54}},
          color={162,29,33},
          thickness=0.5),
        Line(
          points={{0,100},{0,70}},
          color={162,29,33},
          thickness=0.5)}),
    Documentation(revisions="<html>
<ul>
<li>
May 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Wrapper around <a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a> which allows to specify <code>nSeg</code>
successive segments of pipes (connected in series).
</p>
<p>
This wrapper simplifies use-cases where different segments of the same
pipe might have different boundary conditions. This would be the case,
for instance, for sufficiently long stretches of buried pipes.
</p>
<p>
To reduce coupled nonlinear equations, the pipe flow resistance
is aggregated to a single instance of
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a> rather than being
instantiated separately for each segment.
</p>
</html>"));
end PlugFlowDiscretized;
