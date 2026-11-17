within Buildings.Fluid.FixedResistances.Functions;
function convectionResistanceCircularPipe
  "Internal convection resistance per unit length for a circular pipe"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Diameter dh
    "Hydraulic diameter";
  input Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";
  input Modelica.Units.SI.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.Units.SI.DynamicViscosity muMed
    "Dynamic viscosity of the fluid";
  input Modelica.Units.SI.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate";
  input Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  output Real RConv(unit="(m.K)/W")
    "Internal convection resistance per unit pipe length";
  output Real Re(unit="1")
    "Reynolds number";

protected
  Modelica.Units.SI.Radius rInt=dh/2
    "Pipe inner radius";
  Modelica.Units.SI.CoefficientOfHeatTransfer h
    "Convective heat transfer coefficient";
  Modelica.Units.SI.MassFlowRate m_flow_abs=
    Buildings.Utilities.Math.Functions.spliceFunction(
      m_flow,
      -m_flow,
      m_flow,
      max(abs(m_flow_nominal)/30, Modelica.Constants.eps))
    "Regularized absolute mass flow rate";
  Real Pr
    "Prandtl number";
  Real f
    "Darcy-Weisbach friction factor";
  Real Nu
    "Nusselt number";
  Real eps_D=roughness/dh
    "Relative roughness";

  Real NuTurb
    "Gnielinski Nu at Re_turb";
  Real NuTurb_fdp
    "Gnielinski Nu at Re_turb + h_fd";
  Real NuTurb_fdm
    "Gnielinski Nu at Re_turb - h_fd";
  Real dNuTurb_scaled
    "Scaled first derivative at Re_turb";
  Real d2NuTurb_scaled
    "Scaled second derivative at Re_turb";
  Real t
    "Hermite parameter";

  constant Real h_fd=0.5
    "Finite-difference step";
  constant Real Re_lam=2300
    "Upper Reynolds number of laminar regime";
  constant Real Re_turb=4000
    "Lower Reynolds number of turbulent regime";
  constant Real L_trans=1700
    "Transition width";

algorithm
  assert(
    dh > 0,
    "The hydraulic diameter dh must be positive.");

  assert(
    kMed > 0,
    "The fluid thermal conductivity kMed must be positive.");

  assert(
    muMed > 0,
    "The fluid dynamic viscosity muMed must be positive.");

  assert(
    cpMed > 0,
    "The fluid specific heat capacity cpMed must be positive.");

  Re := dh*m_flow_abs/(Modelica.Constants.pi*rInt^2*muMed);
  Pr := cpMed*muMed/kMed;

  if Re >= Re_turb then
    f :=
      Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
        Re=Re,
        eps_D=eps_D);

    Nu :=
      (f/8)*(Re - 1000)*Pr/
      (1 + 12.7*sqrt(f/8)*(Pr^(2/3) - 1));

  else
    NuTurb :=
      (Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
        Re=Re_turb,
        eps_D=eps_D)/8)*(Re_turb - 1000)*Pr/
      (1 + 12.7*sqrt(
        Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
          Re=Re_turb,
          eps_D=eps_D)/8)*(Pr^(2/3) - 1));

    NuTurb_fdp :=
      (Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
        Re=Re_turb + h_fd,
        eps_D=eps_D)/8)*(Re_turb + h_fd - 1000)*Pr/
      (1 + 12.7*sqrt(
        Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
          Re=Re_turb + h_fd,
          eps_D=eps_D)/8)*(Pr^(2/3) - 1));

    NuTurb_fdm :=
      (Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
        Re=Re_turb - h_fd,
        eps_D=eps_D)/8)*(Re_turb - h_fd - 1000)*Pr/
      (1 + 12.7*sqrt(
        Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
          Re=Re_turb - h_fd,
          eps_D=eps_D)/8)*(Pr^(2/3) - 1));

    dNuTurb_scaled :=
      (NuTurb_fdp - NuTurb_fdm)/(2*h_fd)*L_trans;

    d2NuTurb_scaled :=
      (NuTurb_fdp - 2*NuTurb + NuTurb_fdm)/h_fd^2*L_trans^2;

    t := max(0, min(1, (Re - Re_lam)/L_trans));

    Nu :=
      3.66*(1 - 10*t^3 + 15*t^4 - 6*t^5)
      + NuTurb*(10*t^3 - 15*t^4 + 6*t^5)
      + dNuTurb_scaled*(-4*t^3 + 7*t^4 - 3*t^5)
      + d2NuTurb_scaled*(0.5*t^3 - t^4 + 0.5*t^5);
  end if;

  h := Nu*kMed/dh;

  RConv := 1/(Modelica.Constants.pi*dh*h);

  annotation (
    smoothOrder=1,
    Documentation(info="<html>
<p>
This function computes the internal convection resistance per unit pipe length
for a circular pipe.
</p>
<p>
The formulation uses the same Churchill friction-factor and Gnielinski-based
heat-transfer approach as the borefield pipe convection resistance correlation.
The output <code>RConv</code> has unit <code>(m.K)/W</code> and can be added to
pipe-wall and insulation resistances per unit length.
</p>
</html>"));
end convectionResistanceCircularPipe;
