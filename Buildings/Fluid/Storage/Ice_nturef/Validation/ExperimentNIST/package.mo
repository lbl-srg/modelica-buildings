within Buildings.Fluid.Storage.Ice_nturef.Validation;
package ExperimentNIST "Validation from experimental data"
  extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
<p>
This package contains calibration examples using experimental data from
the Intelligent Building Agents Laboraotry at the National Institute of Standards and Technology (NIST).
The  ice storage  tank  at  NIST  contains 3,105 L of  water and when fully frozen the ice has a capacity of 274 kWh,
designed to be discharged over an eight-hour period with an inlet temperature of 10 °C.
The chilled water that flows through the ice tank is a 30 % PG and 70 % water solution,
and the heat exchanger inside the ice tank is a spiral wound polyethylene tube.
The chiller used for charging has a nominal capacity of 36.1 kW.
However, due to the off-design conditions and wornout, the ice tank has a capacity of abour 264 kWh.
<p>

The experimental data are located at \"IceStorage/Resources/data/Experiment\".

The data are prepared into 5 columns, and the description of each column is explained below.
</p>
<ul>
<li>
1st column: time step in seconds
</li>
<li>
2nd column: measured ice tank inlet temperature in Celsius
</li>
<li>
3rd column: measured ice tank outlet temperature in Celsius
</li>
<li>
4th column: measured ice tank fluid mass flow rate in kg/s
</li>
<li>
5th column: measured dimensionless ice tank state-of-charge
</li>
</ul>
<p>
The data are generated with bypass valve fully closed, and collected an interval of 10 seconds.
</p>
<h4>Calibration</h4>
<p>
The performance curves were calibrated using curve-fitting techniques based on the measurement.
For dishcarging scenario, three experiments were conducted and used for calibration.
The discharging capacity of the ice tank depends on the current state-of-charge, the inlet and outlet temperature of the ice tank.
For charging scenario, one set of experiment data was used in this package.
When under charging, the chiller operated at a constant cooling rate, and therefore the ice tank charging rate was almost constant.
An average of the measured charging rate, 167.79 kW, during the experiment was used for the calibration.
</p>

<h4>Reference</h4>
<p>
Li, Guowen, et al. \"An Ice Storage Tank Modelica Model: Implementation and Validation.\" Modelica Conferences. 2021.
</p>

</html>"));
end ExperimentNIST;
