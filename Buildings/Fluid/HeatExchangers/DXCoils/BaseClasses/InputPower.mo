within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block InputPower "Electrical power consumed by the unit"
  extends Modelica.Blocks.Icons.Block;
   Modelica.Blocks.Interfaces.RealInput Q_flow(
    quantity="Power",
    unit="W") "Cooling capacity of the coil"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput EIR "Energy input ratio"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput SHR(min=0, max=1) "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    unit="W") "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(quantity="Power", unit="W")
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  P = -EIR*Q_flow;
  QSen_flow = Q_flow * SHR;
  QLat_flow = Q_flow - QSen_flow;
  annotation(defaultComponentName="pwr",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-50,44},{56,-40}},
          textColor={0,0,255},
          textString="P")}),
            Documentation(info="<html>
<p>
This block calculates total electrical energy consumed by the unit using
the rate of cooling and the energy input ratio <i>EIR</i>.
</p>
<p>
The electrical energy consumed by the unit is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  P = -Q<sub>cool</sub> EIR
</p>
</html>",
revisions="<html>
<ul>
<li>
September 4, 2012 by Michael Wetter:<br/>
Reimplemented model to avoid having to use the <code>max</code> function,
and to reduce the number of mathematical operations.
Added output connector for latent heat flow rate.
Revised documentation.
</li>
<li>
April 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end InputPower;
