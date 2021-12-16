within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block BrighteningCoefficient "Circumsolar and horizon brightening coefficients"
  extends Modelica.Blocks.Icons.Block;
  import H = Buildings.Utilities.Math.Functions.regStep;
  Modelica.Blocks.Interfaces.RealInput zen(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Zenith angle of the sun beam"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput skyCle
    "Sky clearness. skyCle=1: overcast sky; skyCle=8 clear sky"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput skyBri "Sky brightness [0,1]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput F1
    "Circumsolar brightening coefficient"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput F2 "Horizon brightening coefficient"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
protected
  Real F11;
  Real F12;
  Real F13;
  Real F21;
  Real F22;
  Real F23;
  Real d=0.01;
  Real a1;
  Real a2;
  Real a3;
  Real a4;
  Real a5;
  Real a6;
  Real a7;
  Real a8;
  Real b1;
  Real b2;
  Real b3;
  Real b4;
  Real b5;
  Real b6;
  Real b7;
  Real b8;
equation
  b1 = H(
    y1=1,
    y2=0,
    x=1.065 - skyCle,
    x_small=d);
  b2 = H(
    y1=1,
    y2=0,
    x=1.23 - skyCle,
    x_small=d);
  b3 = H(
    y1=1,
    y2=0,
    x=1.50 - skyCle,
    x_small=d);
  b4 = H(
    y1=1,
    y2=0,
    x=1.95 - skyCle,
    x_small=d);
  b5 = H(
    y1=1,
    y2=0,
    x=2.80 - skyCle,
    x_small=d);

  b6 = H(
    y1=1,
    y2=0,
    x=4.50 - skyCle,
    x_small=d);
  b7 = H(
    y1=1,
    y2=0,
    x=6.20 - skyCle,
    x_small=d);
  b8 = H(
    y1=1,
    y2=0,
    x=skyCle - 6.20,
    x_small=d);

  a1 = b1;
  a2 = b2 - b1;
  a3 = b3 - b2;
  a4 = b4 - b3;
  a5 = b5 - b4;
  a6 = b6 - b5;
  a7 = b7 - b6;
  a8 = b8;

  F11 = -0.0083117*a1 + 0.1299457*a2 + 0.3296958*a3 + 0.5682053*a4 + 0.8730280*
    a5 + 1.1326077*a6 + 1.0601591*a7 + 0.6777470*a8;
  F12 = 0.5877285*a1 + 0.6825954*a2 + 0.4868735*a3 + 0.1874525*a4 - 0.3920403*
    a5 - 1.2367284*a6 - 1.5999137*a7 - 0.3272588*a8;
  F13 = -0.0620636*a1 - 0.1513725*a2 - 0.2210958*a3 - 0.2951290*a4 - 0.3616149*
    a5 - 0.4118494*a6 - 0.3589221*a7 - 0.2504286*a8;
  F21 = -0.0596012*a1 - 0.0189325*a2 + 0.0554140*a3 + 0.1088631*a4 + 0.2255647*
    a5 + 0.2877813*a6 + 0.2642124*a7 + 0.1561313*a8;
  F22 = 0.0721249*a1 + 0.0659650*a2 - 0.0639588*a3 - 0.1519229*a4 - 0.4620442*
    a5 - 0.8230357*a6 - 1.1272340*a7 - 1.3765031*a8;
  F23 = -0.0220216*a1 - 0.0288748*a2 - 0.0260542*a3 - 0.0139754*a4 + 0.0012448*
    a5 + 0.0558651*a6 + 0.1310694*a7 + 0.2506212*a8;
  F1 = Buildings.Utilities.Math.Functions.smoothMax(
    0,
    F11 + F12*skyBri + F13*zen,
    0.01);
  F2 = F21 + F22*skyBri + F23*zen;
  annotation (
    defaultComponentName="briCoe",
    Documentation(info="<html>
<p>
This component computes the circumsolar and horizon brightening coefficients.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2018, by Michael Wetter:<br/>
Corrected <code>displayUnit</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/912\">IBPSA, issue 912</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
May 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-96,72},{-52,50}},
          textColor={0,0,127},
          textString="skyCle"),
        Text(
          extent={{-96,14},{-52,-8}},
          textColor={0,0,127},
          textString="skyBri"),
        Text(
          extent={{-96,-46},{-52,-68}},
          textColor={0,0,127},
          textString="zen"),
        Text(
          extent={{62,50},{106,28}},
          textColor={0,0,127},
          textString="F1"),
        Text(
          extent={{60,-30},{104,-52}},
          textColor={0,0,127},
          textString="F2")}));
end BrighteningCoefficient;
