within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block InputPower "Electrical power consumed by the unit"
  extends Modelica.Blocks.Interfaces.BlockIcon;
   Modelica.Blocks.Interfaces.RealInput Q_flow(
    quantity="Power",
    unit="W") "Cooling capacity of the coil"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealInput EIR "Energy Input Ratio"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}},rotation=
            0)));
  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    unit="W") "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,30},{120,50}}, rotation=
            0)));
  Modelica.Blocks.Math.Abs abs
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Product heaToPwr
    "Product of Energy Input Ratio and heat transfer from or to the system"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Math.Product senHea "Calculates sensible cooling capacity"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Interfaces.RealInput SHR "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
                                                                      rotation=
            0)));
  Modelica.Blocks.Interfaces.RealOutput Q_flowSen(quantity="Power", unit="W")
    "Sensible heat "
    annotation (Placement(transformation(extent={{100,-50},{120,-30}},
                                                                     rotation=
            0)));
equation
  connect(heaToPwr.y, P)         annotation (Line(
      points={{41,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EIR, heaToPwr.u1)    annotation (Line(
      points={{-120,60},{-60,60},{-60,46},{18,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.y, heaToPwr.u2)    annotation (Line(
      points={{-19,6.10623e-16},{0,6.10623e-16},{0,34},{18,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SHR, senHea.u2)           annotation (Line(
      points={{-120,-60},{-60,-60},{-60,-46},{18,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senHea.y, Q_flowSen)           annotation (Line(
      points={{41,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow, abs.u) annotation (Line(
      points={{-120,1.11022e-15},{-82,1.11022e-15},{-82,6.66134e-16},{-42,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow, senHea.u1) annotation (Line(
      points={{-120,1.11022e-15},{-83,1.11022e-15},{-83,-34},{18,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(defaultComponentName="pwr", Diagram(graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-50,44},{56,-40}},
          lineColor={0,0,255},
          textString="P")}),
            Documentation(info="<html>
<p>
This block calculates total electrical energy consumed by the unit using cooling capacity and 
energy input ratio <i>EIR</i> of cooling coil at given conditions. <br>
Electrical energy consumed by the unit is identified using the following equations.

<p align=\"center\" style=\"font-style:italic;\">
  COP = | Q<sub>Cooling</sub> (W) | / Electrical energy consumed by the unit (W) 
</p>
<p>
<p align=\"center\" style=\"font-style:italic;\">
  Electrical energy consumed by the unit (W) = Q<sub>Cooling</sub> (W) * EIR
</p>
</p>
<p>
<p align=\"center\" style=\"font-style:italic;\">
  EIR = 1 / COP
</p>
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, May 24, 2012.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end InputPower;
