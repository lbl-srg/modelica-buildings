within Buildings.Fluid.FixedResistances;
model PlugFlowPipeDiscretized
  "Discretized pipe model using spatialDistribution for temperature delay"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Integer nSeg(min=1) = 1 "Number of axial segment";

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean have_pipCap=true
    "= true, a mixing volume is added to each segment that corresponds 
    to the heat capacity of the pipe segment wall"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean have_symmetry=true
    "= false, the mixing volume is only on port_b of each segment,
    which improve performances, but reduces dynamic accuracy"
    annotation (Dialog(tab="Advanced", enable=have_pipCap));

  parameter Modelica.Units.SI.Length dh "Hydraulic diameter"
    annotation (Dialog(group="Material"));

  parameter Real ReC=4000
    "Reynolds number where transition to turbulence starts";

  parameter Modelica.Units.SI.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Material"));
  parameter Modelica.Units.SI.Length totLen=sum(segLen)
    "Total pipe length (used to compute segment length)"
    annotation (Dialog(group="Material"));
  parameter Modelica.Units.SI.Length segLen[nSeg]=fill(totLen/nSeg, nSeg)
    "Pipe segment length" annotation (Dialog(group="Material"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Thermal resistance"));
  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Thermal resistance"));

  parameter Modelica.Units.SI.Length thickness=0.0035 "Pipe wall thickness"
    annotation (Dialog(group="Material"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel"
    annotation (Dialog(group="Material"));
  parameter Modelica.Units.SI.Density rhoPip(displayUnit="kg/m3") = 930
    "Density of pipe wall material. 930 for PE, 8000 for steel"
    annotation (Dialog(group="Material"));

  parameter Modelica.Units.SI.Temperature T_start_in[nSeg]=fill(Medium.T_default,
      nSeg) "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start_out[nSeg]=T_start_in
    "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=0
    "Initial value of mass flow rate through pipe"
    annotation (Dialog(tab="Initialization", enable=initDelay));

  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  parameter Modelica.Units.SI.MassFlowRate m_flow_small=1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[nSeg]
    "Heat transfer to or from surrounding for each pipe segment (positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Modelica.Units.SI.HeatFlowRate QEnv_flow=sum(heatPorts.Q_flow)
    "Heat transfer to or from surroundings of total pipe length (positive if pipe is colder than surrounding)";

  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa") = res.dp
    "Pressure difference between port_a and port_b";

  Modelica.Units.SI.MassFlowRate m_flow=port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  final parameter Modelica.Units.SI.Velocity v_nominal=m_flow_nominal/(APip*
      rho_default) "Velocity at m_flow_nominal";

  Modelica.Units.SI.Velocity v=pipSeg[1].v "Flow velocity of medium in pipe";

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

protected
  parameter Modelica.Units.SI.Length rInt=dh/2 "Pipe interior radius";

  parameter Modelica.Units.SI.Area APip=Modelica.Constants.pi*rInt^2
    "Pipe hydraulic cross-sectional area";

  parameter Modelica.Units.SI.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)";

  Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowPipe pipSeg[nSeg](
    redeclare each final package Medium = Medium,
    redeclare each final FixedResistances.LosslessPipe res,
    final length=segLen,
    final T_start_in=T_start_in,
    final T_start_out=T_start_out,
    each final dIns=dIns,
    each final kIns=kIns,
    each final cPip=cPip,
    each final rhoPip=rhoPip,
    each final dh=dh,
    each final v_nominal=v_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_nominal=m_flow_nominal,
    each final thickness=thickness,
    each final m_flow_small=m_flow_small,
    each final initDelay=initDelay,
    each final have_pipCap=have_pipCap,
    each final have_symmetry=have_symmetry)
    "Pipe segments"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(res.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));

  for i in 2:nSeg loop
    connect(pipSeg[i-1].port_b, pipSeg[i].port_a);
  end for;

  connect(pipSeg.heatPort, heatPorts)
    annotation (Line(points={{0,10},{0,100}}, color={191,0,0}));
  connect(pipSeg[nSeg].port_b, res.port_a)
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(port_a, pipSeg[1].port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-100,-72},{100,-88}},
          textColor={0,0,0},
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
end PlugFlowPipeDiscretized;
