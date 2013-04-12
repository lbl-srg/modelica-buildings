within Buildings.Fluid.SolarCollectors.Controls;
model SolarPumpController
  "Controller which activates a circulation pump when solar radiation is above a critical level"
  import Buildings;
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Real conDel "Width of the smoothHeaviside function";
  Modelica.Blocks.Interfaces.RealInput TIn(
  final unit = "K") "Water temperature entering the collector"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic         per
    "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},{80,80}})));
public
  Modelica.Blocks.Interfaces.RealOutput conSig
    "On/off control signal from the pump"
    annotation (Placement(transformation(extent={{100,-18},{136,18}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data input"
    annotation (Placement(transformation(extent={{-112,50},{-92,70}})));
  BaseClasses.GCritCalc gCritCalc(slope=per.slope, y_intercept=per.y_intercept)
    "Calculates the critical insolation based on collector design and current weather conditions"
    annotation (Placement(transformation(extent={{-64,-18},{-44,2}})));
  Buildings.Utilities.Math.SmoothHeaviside smoothHeaviside(delta=conDel)
    "Creates a smooth 1/0 output"
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    "Compares the current insolation to the critical insolation"
    annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));

equation
  connect(TIn, gCritCalc.TIn) annotation (Line(
      points={{-120,-40},{-84,-40},{-84,-14},{-66,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, gCritCalc.TEnv) annotation (Line(
      points={{-102,60},{-84,60},{-84,-2},{-66,-2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(gCritCalc.GCrit, add.u2) annotation (Line(
      points={{-42.4,-8},{-32,-8},{-32,-6},{-24,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.HDirNor, add.u1) annotation (Line(
      points={{-102,60},{-34,60},{-34,6},{-24,6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(smoothHeaviside.y, conSig) annotation (Line(
      points={{49,0},{118,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, smoothHeaviside.u) annotation (Line(
      points={{-1,0},{26,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
  defaultComponentName = "pumpCon",
  Documentation(info = "<html>
  <p>
  This component models a pump controller which might be used in a solar thermal system. It sets a flow rate for the system and controls whether the pump is active or inactive.
  The pump is activated when the incident solar radiation is greater than the critical radiation and the inlet temperature is lower than a user specified value.
  </p>
  <h4>Equations</h4>
  <p>
  The critical radiation is defined per Duffie and Beckman. It is calculated using Equation 6.8.2.
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  G<sub>TC</sub>=(F<sub>R</sub>U<sub>L</sub>*(T<sub>i</sub>-T<sub>a</sub>))/(F<sub>R</sub>(&tau;&alpha;))
  </p>
  <h4>References</h4>
  <p>
  J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.
  </p>
  </html>",
  revisions = "<html>
  <ul>
  <li>
  January 15, 2013 by Peter Grant <br>
  First implementation
  </li>
  </ul>
  </html>"));
end SolarPumpController;
