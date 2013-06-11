within Buildings.Fluid.SolarCollectors.Controls.BaseClasses;
model ICritCalc "Model calculating the critical insolation level"

  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput TIn(unit="K")
    "Temperature of water entering the collector"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput ICrit(unit="W/m2")
    "Critical radiation level"
    annotation (Placement(transformation(extent={{100,-16},{132,16}})));
  Modelica.Blocks.Interfaces.RealInput TEnv(unit="K")
    "Ambient temperature at the collector"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  parameter Real slope(unit="W/(m2.K)") "Slope from ratings data";
  parameter Real y_intercept "y_intercept from ratings data";
equation
ICrit = -slope * (TIn - TEnv) / y_intercept;
  annotation (defaultComponentName="criSol",
  Documentation(info="<html>
   <p>
   This component calculates the solar radiation necessary for the fluid in the collector to gain heat. 
   It is used in the model <a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.SolarPumpController\">
   Buildings.Fluid.SolarCollectors.Controls.SolarPumpController</a>.
   </p>
   <p>
   The critical solar radiation level is calculated using Equation 6.8.2 in Duffie and Beckman (2006). It is:
   </p>
   <p align=\"center\" style=\"font-style:italic;\">
   I<sub>Crit</sub>=F<sub>R</sub>U<sub>L</sub> (T<sub>In</sub>-T<sub>Env</sub>)/(F<sub>R</sub>(&tau;&alpha;))
   </p>
   <h4>References</h4>
   <p>
   J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.<br/>
   </p>
   </html>",
  revisions = "<html>
  <ul>
  <li>
  February 15, 2013 by Peter Grant <br/>
  First implementation
  </li>
  </ul>
  </html>"));
end ICritCalc;
