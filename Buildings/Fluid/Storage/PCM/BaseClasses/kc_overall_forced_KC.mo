within Buildings.Fluid.Storage.PCM.BaseClasses;
function kc_overall_forced_KC
  "Mean heat transfer coefficient of straight pipe | uniform wall temperature or uniform heat flux | hydrodynamically developed or undeveloped overall flow regime| pressure loss dependence"
  extends Modelica.Icons.Function;
  import SMOOTH =
    Modelica.Fluid.Dissipation.Utilities.Functions.General.Stepsmoother;

  //input records
  input
    Modelica.Fluid.Dissipation.HeatTransfer.General.kc_approxForcedConvection_IN_con
    IN_con_turb "Input record for function kc_overall_KC"
    annotation (Dialog(group="Constant inputs"));
  input
    Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con
    IN_con_lam "Input record for function kc_overall_KC"
    annotation (Dialog(group="Constant inputs"));
  input
    Modelica.Fluid.Dissipation.HeatTransfer.General.kc_approxForcedConvection_IN_var
    IN_var "Input record for function kc_overall_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output Modelica.Units.SI.CoefficientOfHeatTransfer kc
    "Output for function kc_overall_KC";

protected
  Real MIN=Modelica.Constants.eps;
  Real laminar=2200 "Maximum Reynolds number for laminar regime";
  Real turbulent=1e4 "Minimum Reynolds number for turbulent regime";

  Modelica.Units.SI.Area A_cross=Modelica.Constants.pi*IN_con_lam.d_hyd^2/4
    "Cross sectional area";

  Modelica.Units.SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*
      A_cross) "Mean velocity";
  Modelica.Units.SI.ReynoldsNumber Re=(IN_var.rho*velocity*IN_con_lam.d_hyd/max(MIN,
      IN_var.eta));
  Modelica.Units.SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda));


algorithm
  kc := SMOOTH(laminar, turbulent, Re)*
    Buildings.Fluid.Storage.PCM.BaseClasses.kc_laminar_mills(
    IN_con_lam, IN_var) + SMOOTH(turbulent, laminar, Re)*
    Modelica.Fluid.Dissipation.HeatTransfer.General.kc_approxForcedConvection_KC(
    IN_con_turb, IN_var);

annotation (Inline=false, Documentation(info="<html>
<p>
Calculation of mean convective heat transfer coefficient <strong>kc</strong> of a straight pipe at an uniform wall temperature <strong>or</strong> uniform heat flux <strong>and</strong> for a hydrodynamically developed <strong>or</strong> undeveloped overall fluid flow with neglect <strong>or</strong> consideration of pressure loss influence.<a href=\"modelica://Modelica.Fluid.Dissipation.Utilities.SharedDocumentation.HeatTransfer.StraightPipe.kc_overall\">See more information</a> .
</p>
</html>",
    revisions="<html>
<p>2016-04-11 Stefan Wischhusen: Removed singularity for Re at zero mass flow rate.</p>
</html>"),
     smoothOrder(normallyConstant=IN_con) = 2);
end kc_overall_forced_KC;
