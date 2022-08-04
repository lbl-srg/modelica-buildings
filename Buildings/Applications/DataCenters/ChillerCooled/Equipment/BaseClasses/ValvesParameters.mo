within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model ValvesParameters "Model with parameters for multiple valves"

  parameter Integer numVal "Number of valves";
  parameter Buildings.Fluid.Types.CvTypes CvData=Buildings.Fluid.Types.CvTypes.OpPoint
   "Selection of flow coefficient"
   annotation(Dialog(group = "Two-way valve"));
  parameter Real[numVal] Kv(
    each fixed= if CvData==Buildings.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
    annotation(Dialog(group = "Two-way valve",
      enable = (CvData==Buildings.Fluid.Types.CvTypes.Kv)));
  parameter Real[numVal] Cv(
    each fixed= if CvData==Buildings.Fluid.Types.CvTypes.Cv then true else false)
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]"
    annotation(Dialog(group = "Two-way valve",
      enable = (CvData==Buildings.Fluid.Types.CvTypes.Cv)));
  parameter Modelica.Units.SI.Area[numVal] Av(each fixed=if CvData == Buildings.Fluid.Types.CvTypes.Av
         then true else false) "Av (metric) flow coefficient" annotation (
      Dialog(group="Two-way valve", enable=(CvData == Buildings.Fluid.Types.CvTypes.Av)));
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.Units.SI.MassFlowRate[numVal] m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Two-way valve"));
  parameter Modelica.Units.SI.PressureDifference[numVal] dpValve_nominal(
    each displayUnit="Pa",
    each min=0,
    each fixed=if CvData == Buildings.Fluid.Types.CvTypes.OpPoint then true
         else false) = fill(6000, numVal) "Nominal pressure drop of fully open valve, used if
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint" annotation (Dialog(group=
          "Two-way valve", enable=(CvData == Buildings.Fluid.Types.CvTypes.OpPoint)));
  parameter Modelica.Units.SI.Density[numVal] rhoStd
    "Inlet density for which valve coefficients are defined"
    annotation (Dialog(group="Two-way valve", tab="Advanced"));
protected
  parameter Real[numVal] Kv_SI(
    each min=0,
    each fixed= false)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]"
    annotation(Dialog(group = "Two-way valve",
      enable = (CvData==Buildings.Fluid.Types.CvTypes.OpPoint)));
initial equation
  if  CvData == Buildings.Fluid.Types.CvTypes.OpPoint then
    Kv_SI =           m_flow_nominal./sqrt(dpValve_nominal);
    Kv    =           Kv_SI./(rhoStd/3600/sqrt(1E5));
    Cv    =           Kv_SI./(rhoStd*0.0631/1000/sqrt(6895));
    Av    =           Kv_SI./sqrt(rhoStd);
  elseif CvData == Buildings.Fluid.Types.CvTypes.Kv then
    Kv_SI =           Kv.*rhoStd/3600/sqrt(1E5)
      "Unit conversion m3/(h*sqrt(bar)) to kg/(s*sqrt(Pa))";
    Cv    =           Kv_SI./(rhoStd*0.0631/1000/sqrt(6895));
    Av    =           Kv_SI./sqrt(rhoStd);
    dpValve_nominal =  (m_flow_nominal./Kv_SI).^2;
  elseif CvData == Buildings.Fluid.Types.CvTypes.Cv then
    Kv_SI =           Cv.*rhoStd*0.0631/1000/sqrt(6895)
      "Unit conversion USG/(min*sqrt(psi)) to kg/(s*sqrt(Pa))";
    Kv    =           Kv_SI./(rhoStd/3600/sqrt(1E5));
    Av    =           Kv_SI./sqrt(rhoStd);
    dpValve_nominal =  (m_flow_nominal./Kv_SI).^2;
  else
    assert(CvData == Buildings.Fluid.Types.CvTypes.Av, "Invalid value for CvData.
Obtained CvData = " + String(CvData) + ".");
    Kv_SI =           Av.*sqrt(rhoStd);
    Kv    =           Kv_SI./(rhoStd/3600/sqrt(1E5));
    Cv    =           Kv_SI./(rhoStd*0.0631/1000/sqrt(6895));
    dpValve_nominal =  (m_flow_nominal./Kv_SI).^2;
  end if;
  annotation (Documentation(info="<html>
<p>
Model that computes the flow coefficients of vectored valves. The number of vectored valves is
defined by the parameter <code>numVal</code>.
</p>
<p>
Note that the <code>numVal</code> valves have the same modelling option that can specify the valve
flow coefficient in fully open conditions. Details can be found in
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.ValveParameters\">
Buildings.Fluid.Actuators.BaseClasses.ValveParameters</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValvesParameters;
