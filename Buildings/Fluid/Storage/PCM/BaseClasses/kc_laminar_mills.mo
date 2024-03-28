within Buildings.Fluid.Storage.PCM.BaseClasses;
function kc_laminar_mills
  "Mean heat transfer coefficient of straight pipe | uniform wall temperature or uniform heat flux | hydrodynamically developed or undeveloped laminar flow regime"
  extends Modelica.Icons.Function;
  //input records
  input
    Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_laminar_IN_con
    IN_con "Input record for function kc_laminar_KC"
    annotation (Dialog(group="Constant inputs"));
  input
    Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_laminar_IN_var
    IN_var "Input record for function kc_laminar_KC"
    annotation (Dialog(group="Variable inputs"));

  //output variables
  output Modelica.Units.SI.CoefficientOfHeatTransfer kc
    "Output for function kc_laminar_KC";


protected
  Modelica.Units.SI.Area A_cross=Modelica.Constants.pi*IN_con.d_hyd^2/4
    "Circular cross sectional area";
  Real MIN=Modelica.Constants.eps;
  Modelica.Units.SI.Velocity velocity=abs(IN_var.m_flow)/max(MIN, IN_var.rho*
      A_cross) "Mean velocity";
  Modelica.Units.SI.ReynoldsNumber Re=(IN_var.rho*velocity*IN_con.d_hyd/max(MIN,
      IN_var.eta));
  Modelica.Units.SI.PrandtlNumber Pr=abs(IN_var.eta*IN_var.cp/max(MIN, IN_var.lambda));

  Modelica.Units.SI.NusseltNumber Nu=3.66+0.065*Re*Pr*IN_con.d_hyd/IN_con.L/(1+0.04*(Re*Pr*IN_con.d_hyd/IN_con.L)^(2/3)) "Mean Nusselt number";


algorithm
  kc := Nu*IN_var.lambda/max(MIN, IN_con.d_hyd);
annotation (Inline=false, Documentation(info="<html>
<p>
Calculation of mean convective heat transfer coefficient <strong>kc</strong> of a straight pipe at an uniform wall temperature <strong>or</strong> uniform heat flux <strong>and</strong> for a hydrodynamically developed <strong>or</strong> undeveloped laminar fluid flow. <a href=\"modelica://Modelica.Fluid.Dissipation.Utilities.SharedDocumentation.HeatTransfer.StraightPipe.kc_laminar\">See more information</a> .
</p>
</html>",
    revisions="<html>
<p>2014-08-05 Stefan Wischhusen: Corrected term for Uniform heat flux in developed fluid flow (Nu3).</p>
<p>2016-04-11 Stefan Wischhusen: Removed singularity for Re at zero mass flow rate.</p>
</html>"),
     smoothOrder(normallyConstant=IN_con) = 2);
end kc_laminar_mills;
