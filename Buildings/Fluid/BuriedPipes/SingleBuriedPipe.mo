within Buildings.Fluid.BuriedPipes;
model SingleBuriedPipe
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)";

  parameter Modelica.SIunits.Length dh=sqrt(4*m_flow_nominal/rho_default/v_nominal/Modelica.Constants.pi)
    "Hydraulic diameter (assuming a round cross section area)";

  parameter Modelica.SIunits.Velocity v_nominal = 1.5
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)";

  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts";

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)";

  parameter Modelica.SIunits.Length length "Pipe length";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate m_flow_small = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow";

  parameter Modelica.SIunits.Length dIns
    "Thickness of pipe insulation, used to compute R";

  parameter Modelica.SIunits.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R";

  parameter Modelica.SIunits.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel";

  parameter Modelica.SIunits.Density rhoPip(displayUnit="kg/m3")=930
    "Density of pipe wall material. 930 for PE, 8000 for steel";

  parameter Modelica.SIunits.Length thickness = 0.0035
    "Pipe wall thickness";

  parameter Modelica.SIunits.Temperature T_start_in(start=Medium.T_default)=
    Medium.T_default "Initialization temperature at pipe inlet";
  parameter Modelica.SIunits.Temperature T_start_out(start=Medium.T_default)=
    T_start_in "Initialization temperature at pipe outlet";
  parameter Boolean initDelay(start=false) = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0";
  parameter Modelica.SIunits.MassFlowRate m_flow_start=0 "Initial value of mass flow rate through pipe";

  parameter Real R(unit="(m.K)/W")=1/(kIns*2*Modelica.Constants.pi/
    Modelica.Math.log((dh/2 + thickness + dIns)/(dh/2 + thickness)))
    "Thermal resistance per unit length from fluid to boundary temperature";

  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate";


  FixedResistances.PlugFlowPipe pip(
    from_dp=from_dp,
    dh=2*rInt,
    v_nominal=v_nominal,
    ReC=ReC,
    roughness=roughness,
    length=length,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=m_flow_small,
    dIns=dIns,
    kIns=kIns,
    cPip=cPip,
    rhoPip=rhoPip,
    thickness=thickness,
    T_start_in=T_start_in,
    T_start_out=T_start_out,
    initDelay=initDelay,
    m_flow_start=m_flow_start,
    R=R,
    fac=fac,
    linearized=linearized)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    undisturbedSoilTemperature
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  HeatTransfer.Conduction.SingleLayerCylinder lay1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,38})));
equation
  connect(pip.heatPort, lay1.port_a)
    annotation (Line(points={{0,10},{0,28}}, color={191,0,0}));
  connect(lay1.port_b, undisturbedSoilTemperature.port)
    annotation (Line(points={{0,48},{0,70.2}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleBuriedPipe;
