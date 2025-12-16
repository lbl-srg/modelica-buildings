within Buildings.Fluid.CHPs;
package DistrictCHP "Package of CHP models for district energy systems"
  extends Modelica.Icons.VariantsPackage;

  annotation(Documentation(info= "<html>
<p>
This package includes models for combined heat and power (CHP) system in district
energy systems. This combined-cycle CHP system consists of the topping and bottoming
cycles. The model is based on the implementation of
<a href=\"https://publications.ibpsa.org/conference/paper/?id=simbuild2024_2118\">
Z.He et al., 2024</a>.
</p>
<p>
In the topping cycle, the gas turbine converts a portion of the fuel energy into
mechanical work to drive the coupled generator for electricity generation. The
remaining energy, in the form of high-temperature exhaust gas, is transferred to
the bottoming cycle.
</p>
<p>
In the bottoming cycle, exhaust gas enters the heat recovery steam generator (HRSG)
to heat feedwater and produce superheated steam. The steam drives a steam turbine
connected to a generator that produces electricity. The low-pressure superheated
steam exiting the turbine is desuperheated to saturated steam, with energy losses
occurring throughout the process.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/DistrictCHP/CHPCombinedCycle.png\"
     alt=\"Combined-cycle CHP System Schematic\"/>
</p>
<p>
This model assumes that the fuel consumption occurs only in the gas turbine, with no
fuel input to the supplementary duct burner in the HRSG. Minor energy losses,
including mechanical energy and heat losses from the turbines and energy associated with
compressed inlet air, are neglected.
</p>
<h4>Governing Equations</h4>
<p>
As mechanical energy and heat losses in the turbine are neglected, the fuel combustion
energy is considered equal to the sum of the generated electricity and the heat
flow of the exhaust gas. The energy balance equation for the topping cycle is:
</p>
<p align=\"center\">
<i>
Q&#775;<sub>fuel</sub> = P<sub>GTG</sub> + Q&#775;<sub>exhaust</sub>
</i>
</p>
<p>
Where <i>Q&#775;<sub>fuel</sub></i> is the fuel combustion energy flow, <i>P<sub>GTG</sub></i> is
the electrical power output of the gas turbine generator, and <i>Q&#775;<sub>exhaust</sub></i>
is the heat flow of the exhaust gas. The fuel combustion energy flow is calculated by:
</p>
<p align=\"center\">
<i>
Q&#775;<sub>fuel</sub> = m<sub>fuel</sub> × LHV<sub>fuel</sub>
</i>
</p>
<p>
A portion of the fuel combustion energy flow is converted into electricity based on the
gas turbine efficiency <i>η<sub>GTG</sub></i>:
</p>
<p align=\"center\">
<i>
P<sub>GTG</sub> = Q&#775;<sub>fuel</sub> × η<sub>GTG</sub></br>
Q&#775;<sub>exhaust</sub> = Q&#775;<sub>fuel</sub> × (1 - η<sub>GTG</sub>)
</i>
</p>
<p>
In the bottoming cycle, the inputs are the exhaust gas and feedwater energy, while
the outputs include electricity from the steam turbine and heating energy from
saturated steam. Heat losses occur in the exhaust gas stack and during the
desuperheating process. The energy balance for the bottoming cycle is:
</p>
<p align=\"center\">
<i>
Q&#775;<sub>exhaust</sub> + Q&#775;<sub>water</sub> = P<sub>STG</sub> +
Q&#775;<sub>steam,sat</sub> + Q&#775;<sub>exhaust,loss</sub> + Q&#775;<sub>steam,loss</sub>
</i>
</p>
<p>
Where <i>Q&#775;<sub>water</sub></i> is the energy flow from the feedwater, <i>P<sub>STG</sub></i>
is the electricity from the steam turbine generator, <i>Q&#775;<sub>steam,sat</sub></i> is
the heating energy of the saturated steam, and the last two terms represent
respective energy losses.
</p>
<h4>Note</h4>
<p>
All energy flows are time-dependent rates (e.g., Watts).
</p>
</html>", revisions="<html>
<ul>
<li>
February 8, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end DistrictCHP;
