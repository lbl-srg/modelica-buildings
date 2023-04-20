within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block InputPower
  "Electrical power consumed by the unit"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput Q_flow(
    final quantity="Power",
    final unit="W")
    "Cooling capacity of the coil"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput EIR
    "Energy input ratio"
    annotation (Placement(transformation(extent={{-140,46},{-100,86}})));

  Modelica.Blocks.Interfaces.RealInput SHR(
    final min=0,
    final max=1)
    "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput QSen_flow(
    final quantity="Power",
    final unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput QLat_flow(
    final quantity="Power",
    final unit="W")
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  Modelica.Blocks.Math.Product proQ
    "Multiply SHR by total heat transfer rate to get sensible heat flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Add add(
    final k1=-1)
    "Subtract sensible heat transfer rate from total heat transfer rate to get 
    latent heat flow rate"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Modelica.Blocks.Math.Product proP
    "Multiply EIR by heat transferred to medium to get power consumption"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Blocks.Math.Gain gain(
    final k=-1)
    "Multiply by -1 to get positive value for energy consumption"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

equation
  connect(SHR, proQ.u2) annotation (Line(points={{-120,-60},{-40,-60},{-40,-6},
          {-12,-6}}, color={0,0,127}));
  connect(Q_flow, proQ.u1) annotation (Line(points={{-120,0},{-66,0},{-66,6},{-12,
          6}}, color={0,0,127}));
  connect(proQ.y, QSen_flow)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(add.y, QLat_flow) annotation (Line(points={{61,-30},{66,-30},{66,-60},
        {110,-60}}, color={0,0,127}));
  connect(Q_flow, add.u2) annotation (Line(points={{-120,0},{-50,0},{-50,-36},{38,
        -36}}, color={0,0,127}));
  connect(proQ.y, add.u1) annotation (Line(points={{11,0},{24,0},{24,-24},{38,-24}},
        color={0,0,127}));
  connect(EIR,proP. u1)
    annotation (Line(points={{-120,66},{-12,66}},          color={0,0,127}));
  connect(Q_flow,proP. u2) annotation (Line(points={{-120,0},{-68,0},{-68,54},{
          -12,54}},
                color={0,0,127}));
  connect(gain.y, P)
    annotation (Line(points={{61,60},{110,60}}, color={0,0,127}));
  connect(proP.y, gain.u)
    annotation (Line(points={{11,60},{38,60}},color={0,0,127}));

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
