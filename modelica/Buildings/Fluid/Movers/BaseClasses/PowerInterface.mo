within Buildings.Fluid.Movers.BaseClasses;
partial model PowerInterface
  "Partial model to compute power draw and heat dissipation of fans and pumps"

  import Modelica.Constants;

  parameter Boolean use_powerCharacteristic = false
    "Use powerCharacteristic (vs. efficiencyCharacteristic)"
     annotation(Evaluate=true,Dialog(group="Characteristics"));

  parameter Boolean motorCooledByFluid = true
    "If true, then motor heat is added to fluid stream"
    annotation(Dialog(group="Characteristics"));
  replaceable function motorEfficiency =
    Characteristics.constantEfficiency(eta_nominal = 0.9) constrainedby
    Characteristics.baseEfficiency "Efficiency vs. normalized volume flow rate"
    annotation(Dialog(group="Characteristics"),
               enable = not use_powerCharacteristic,
               choicesAllMatching=true);
  replaceable function hydraulicEfficiency =
    Characteristics.constantEfficiency(eta_nominal = 0.9) constrainedby
    Characteristics.baseEfficiency "Efficiency vs. normalized volume flow rate"
    annotation(Dialog(group="Characteristics"),
               enable = not use_powerCharacteristic,
               choicesAllMatching=true);

  parameter Modelica.SIunits.Density rho_nominal "Nominal fluid density";

  Modelica.SIunits.Power PEle "Electrical power input";
  Modelica.SIunits.Power WHyd
    "Hydraulic power input (converted to flow work and heat)";
  Modelica.SIunits.Power WFlo "Flow work";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat input from fan or pump to medium";
  Real eta(min=0, max=1) "Global efficiency";
  Real etaHyd(min=0, max=1) "Hydraulic efficiency";
  Real etaMot(min=0, max=1) "Motor efficiency";

  Real r_V(start=1)
    "Ratio V_flow/V_flow_max = V_flow/V_flow(dp=0, N=N_nominal)";

  Modelica.SIunits.Pressure dpMachine(displayUnit="Pa") "Pressure increase";
  Modelica.SIunits.VolumeFlowRate VMachine_flow "Volume flow rate";
protected
  parameter Modelica.SIunits.VolumeFlowRate V_flow_max(fixed=false)
    "Maximum volume flow rate";
  Modelica.SIunits.HeatFlowRate QThe_flow "Heat input into the medium";
  parameter Modelica.SIunits.VolumeFlowRate delta_V_flow = 1E-3*V_flow_max
    "Factor used for setting heat input into medium to zero at very small flows";
equation
  r_V = VMachine_flow/V_flow_max;

  eta    = etaHyd * etaMot;
  WFlo = eta * PEle;
  // Flow work
  WFlo   = dpMachine*VMachine_flow;
  // Hydraulic power (transmitted by shaft), etaHyd = WFlo/WHyd
  etaHyd * WHyd   = WFlo;
  // Heat input into medium
  QThe_flow +  WFlo = if motorCooledByFluid then PEle else WHyd;
  // At m_flow = 0, the solver may still obtain positive values for QThe_flow.
  // The next statement sets the heat input into the medium to zero for very small flow rates.
  Q_flow = Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                       x=abs(VMachine_flow)-2*delta_V_flow, deltax=delta_V_flow);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
<p>This is an interface that implements the functions to compute the power draw and the
heat dissipation of fans and pumps. It is used by the model 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
</p>
<p>
If <code>addHeatToMedium = false</code>, then no heat will be added to the medium.
This can lead to simpler equations.
</p>
</html>",
      revisions="<html>
<ul>
<li><i>March 1, 2010</i>
    by Michael Wetter:<br>
    Revised implementation to allow <code>N=0</code>.
<li><i>October 1, 2009</i>
    by Michael Wetter:<br>
    Changed model so that it is based on total pressure in Pascals instead of the pump head in meters.
    This change is needed if the device is used with air as a medium. The original formulation in Modelica.Fluid
    converts head to pressure using the density medium.d. Therefore, for fans, head would be converted to pressure
    using the density of air. However, for fans, manufacturers typically publish the head in 
    millimeters water (mmH20). Therefore, to avoid confusion and to make this model applicable for any medium,
    the model has been changed to use total pressure in Pascals instead of head in meters.
</li>
<li><i>Dec 2008</i>
    by R&uuml;diger Franke:<br>
    <ul>
    <li>Replaced simplified mass and energy balances with rigorous formulation (base class PartialLumpedVolume)</li>
    <li>Introduced optional HeatTransfer model defining Qb_flow</li>
    <li>Enabled events when the checkValve is operating to support the opening of a discrete valve before port_a</li>
    </ul></li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
end PowerInterface;
