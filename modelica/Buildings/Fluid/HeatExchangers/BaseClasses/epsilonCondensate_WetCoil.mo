within Buildings.Fluid.HeatExchangers.BaseClasses;
function epsilonCondensate_WetCoil "Computes heat transfer effectiveness to determine condensate
  temperature for completely wet coil model"

  input Modelica.SIunits.MassFlowRate m_flow
    "Air mass flow rate (may be negative or zero)";
  input Modelica.SIunits.SpecificHeatCapacity c_p
    "Specific heat capacity of moist air at inlet condition";
  input Modelica.SIunits.ThermalConductance hA
    "hA-value air side (require hA>0)";
  output Real epsilon
    "Effectiveness of heat transer that determines condensate temperature";
protected
  Modelica.SIunits.ThermalConductance delta_C
    "Small number for capacity flow, relative to hA";
  Modelica.SIunits.ThermalConductance C_flow "Capacity flow rate of air";
algorithm
 delta_C :=1E-5*hA;
 C_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    x1=noEvent(abs(m_flow)*c_p),
    x2=delta_C,
    deltaX=delta_C/4);
 epsilon :=1 - Modelica.Math.exp(-hA/C_flow);

  annotation(preferedView="info",
           smoothOrder=1,
           Documentation(info="<html>
This function computes the heat transfer effectiveness for the 
latent heat transfer in the completely wet coil.
</p>
<p>
The implementation allows for zero flow rate.
</html>",
revisions="<html>
<ul>
<li>
February 20, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end epsilonCondensate_WetCoil;
