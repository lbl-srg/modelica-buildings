within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.Examples;
model HeatFlowRate "Test model for the heat flow rate function"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Temperature T_a = 273.15+45
    "Temperature at port_a";
  parameter Modelica.SIunits.Temperature T_b = 273.15+42
    "Temperature at port_b";
  Modelica.SIunits.Temperature T_s "Temperature of solid";
  parameter Modelica.SIunits.Temperature T_f = 273.15+24
    "Temperature of control volume";

  parameter Modelica.SIunits.SpecificHeatCapacity c_p= 4200
    "Specific heat capacity";
  parameter Modelica.SIunits.ThermalConductance UA = 1 "UA value";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= 0.1
    "Nominal mass flow rate from port_a to port_b";

  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate from port_a to port_b";

  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate";

  parameter Modelica.SIunits.HeatCapacity C=0.001
    "Heat capacity of solid state";

initial equation
  T_s = 273.15+25;
equation
  m_flow = 2*(time-0.5)*m_flow_nominal;
  Q_flow = Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.heatFlowRate(
    T_a=T_a,
    T_b=T_b,
    T_s=T_s,
    T_f=T_f,
    c_p=c_p,
    UA=UA,
    m_flow=m_flow,
    m_flow_nominal=m_flow_nominal);
 C*der(T_s) = -Q_flow;
annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/BaseClasses/Functions/Examples/HeatFlowRate.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-120},
            {100,100}})),
Documentation(info="<html>
<p>
This example tests the function that computes the heat flow rate between
the water and the slab as the water flow rate transitions from negative
to positive.
The parameters, including the temperatures, are selected in an unrealistic way
that has been used to test the proper functionality of this function.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 7, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1,
      Tolerance=1e-05));
end HeatFlowRate;
