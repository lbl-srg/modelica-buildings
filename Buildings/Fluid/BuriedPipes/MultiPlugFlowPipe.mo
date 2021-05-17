within Buildings.Fluid.BuriedPipes;
model MultiPlugFlowPipe
  "Pipe model using spatialDistribution for temperature delay"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Integer nSeg(min=1) = 1 "Number of axial segment";

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Length rInt "Pipe interior radius";

  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts";

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Material"));

  parameter Modelica.SIunits.Length length[nSeg] "Pipe segment length";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate m_flow_small = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Length dIns
    "Thickness of pipe insulation";

  parameter Modelica.SIunits.ThermalConductivity kIns
    "Heat conductivity of pipe insulation";

  parameter Modelica.SIunits.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel";

  parameter Modelica.SIunits.Density rhoPip(displayUnit="kg/m3")=930
    "Density of pipe wall material. 930 for PE, 8000 for steel";

  parameter Modelica.SIunits.Length dPip = 0.0035
    "Pipe wall thickness";

  parameter Modelica.SIunits.Temperature T_start_in(start=Medium.T_default)=
    Medium.T_default "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_start_out(start=Medium.T_default)=
    T_start_in "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay(start=false) = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));

  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[nSeg]
    "Heat transfer to or from surroundings (heat loss from pipe results in a positive heat flow)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  FixedResistances.PlugFlowPipe pipSeg[nSeg](
    length=length,
    each final dh=rInt*2,
    redeclare final package Medium = Medium,
    cor(redeclare final FixedResistances.LosslessPipe res),
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_nominal=m_flow_nominal,
    each final cPip=cPip,
    each final rhoPip=rhoPip,
    each final thickness=dPip,
    each final dIns=dIns,
    each final kIns=kIns,
    each final m_flow_small=m_flow_small,
    each final T_start_in=T_start_in,
    each final T_start_out=T_start_out,
    each final initDelay=initDelay,
    each final nPorts=1)
    "Pipe segments"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  FixedResistances.HydraulicDiameter res(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dh=rInt*2,
    final from_dp=false,
    final length=totLen,
    final roughness=roughness,
    final fac=fac,
    final ReC=ReC,
    final v_nominal=v_nominal,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearized,
    dp(nominal=fac*200*totLen))
    "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  parameter Modelica.SIunits.Velocity
    v_nominal = m_flow_nominal / (Modelica.Constants.pi * rInt^2 * rho_default)
    "Velocity at m_flow_nominal";
  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)";
  parameter Modelica.SIunits.Length totLen = sum(length) "Total pipe length";


equation
  connect(port_a, pipSeg[1].port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  for i in 2:nSeg loop
    connect(pipSeg[i-1].ports_b[1], pipSeg[i].port_a);
  end for;
  connect(pipSeg.heatPort, heatPorts)
    annotation (Line(points={{0,10},{0,100}}, color={191,0,0}));
  connect(pipSeg[nSeg].ports_b[1], res.port_a)
    annotation (Line(points={{10,0},{26,0},{26,0},{40,0}}, color={0,127,255}));
  connect(res.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-100,-72},{100,-88}},
          lineColor={0,0,0},
          textString="L[ ] = %length
d = %dh"),
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
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
</html>"));
end MultiPlugFlowPipe;
