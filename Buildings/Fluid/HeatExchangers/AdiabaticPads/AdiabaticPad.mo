within Buildings.Fluid.HeatExchangers.AdiabaticPads;
model AdiabaticPad
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Real satEff = 0.75 "Saturation efficiency";
  parameter Real facAre = 0.2 "Face area of the adiabatic pad";
  Real T_a(final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature");
  Real T_b(final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature");

public

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul_a_forFlo(
      redeclare package Medium = Medium)
    "Calculate wetbulb temperature at port a during forward fluid flow"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul_b_forFlo(
      redeclare package Medium = Medium)
    "Calculate wetbulb temperature at port b during forward fluid flow"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul_a_revFlo(
      redeclare package Medium = Medium)
    "Calculate wetbulb temperature at port a during reverse fluid flow"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul_b_revFlo(
      redeclare package Medium = Medium)
    "Calculate wetbulb temperature at port b during reverse fluid flow"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

protected

  Real h_a_forFlo;
  Real h_b_revFlo;
  Real h_b_forFlo;
  Real h_a_revFlo;
  Real Xi_a_forFlo[Medium.nXi];
  Real Xi_b_revFlo[Medium.nXi];
  Real Xi_b_forFlo[Medium.nXi];
  Real Xi_a_revFlo[Medium.nXi];
  Real T_a_forFlo(final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature");
  Real T_b_revFlo(final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature");
  Real T_b_forFlo(final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature");
  Real T_a_revFlo(final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature");

equation
  dp = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=25,
    y2=-25,
    x_small=m_flow_small);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  h_a_forFlo = inStream(port_a.h_outflow);
  h_b_revFlo = inStream(port_b.h_outflow);
  Xi_a_forFlo = inStream(port_a.Xi_outflow);
  Xi_b_revFlo = inStream(port_b.Xi_outflow);

  T_a_forFlo = Medium.temperature(state=
    Medium.setState_phX(p=port_a.p, h=h_a_forFlo, X=Xi_a_forFlo));
  T_b_revFlo = Medium.temperature(state=
    Medium.setState_phX(p=port_b.p, h=h_b_revFlo, X=Xi_b_revFlo));

  T_b_forFlo =T_a_forFlo - satEff*(T_a_forFlo - wetBul_a_forFlo.TWetBul);
  T_a_revFlo =T_b_revFlo - satEff*(T_b_revFlo - wetBul_b_revFlo.TWetBul);

  h_b_forFlo = Medium.specificEnthalpy(state=
    Medium.setState_pTX(p=port_b.p, T=T_b_forFlo, X=Xi_b_forFlo));
  h_a_revFlo = Medium.specificEnthalpy(state=
    Medium.setState_pTX(p=port_a.p, T=T_a_revFlo, X=Xi_a_revFlo));

  wetBul_a_forFlo.TDryBul = T_a_forFlo;
  wetBul_a_forFlo.Xi = Xi_a_forFlo;
  wetBul_a_forFlo.p = port_a.p;
  wetBul_b_revFlo.TDryBul = T_b_revFlo;
  wetBul_b_revFlo.Xi = Xi_b_revFlo;
  wetBul_b_revFlo.p = port_b.p;
  wetBul_b_forFlo.TWetBul =wetBul_a_forFlo.TWetBul;

  wetBul_b_forFlo.TDryBul = T_b_forFlo;
  wetBul_b_forFlo.Xi = Xi_b_forFlo;
  wetBul_b_forFlo.p = port_b.p;
  wetBul_a_revFlo.TDryBul = T_a_revFlo;
  wetBul_a_revFlo.Xi = Xi_a_revFlo;
  wetBul_a_revFlo.p = port_a.p;
  wetBul_a_revFlo.TWetBul =wetBul_b_revFlo.TWetBul;

  T_a = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=T_a_forFlo,
    y2=T_a_revFlo,
    x_small=m_flow_small);

  T_b = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=T_b_forFlo,
    y2=T_b_revFlo,
    x_small=m_flow_small);

  port_a.h_outflow = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=h_a_forFlo,
    y2=h_a_revFlo,
    x_small=m_flow_small);

  port_b.h_outflow = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=h_b_forFlo,
    y2=h_b_revFlo,
    x_small=m_flow_small);

  port_a.Xi_outflow = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=Xi_a_forFlo,
    y2=Xi_a_revFlo,
    x_small=m_flow_small);

  port_b.Xi_outflow = Modelica.Fluid.Utilities.regStep(
    x=port_a.m_flow,
    y1=Xi_b_forFlo,
    y2=Xi_b_revFlo,
    x_small=m_flow_small);

  if not allowFlowReversal then
    assert(m_flow > -m_flow_small,
      "Reverting flow occurs even though allowFlowReversal is false");
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AdiabaticPad;
