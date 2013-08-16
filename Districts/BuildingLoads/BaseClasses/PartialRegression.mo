within Districts.BuildingLoads.BaseClasses;
partial block PartialRegression "Partial model for regression of building load"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer nU = 4 "Dimension of input vector";
  parameter Integer nY = 9 "Dimension of output vector";

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K")
    "Outdoor dry-bulb temperature" annotation (Placement(transformation(extent={
            {-140,60},{-100,100}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TDewPoi(unit="K")
    "Outdoor dew-point temperature" annotation (Placement(transformation(extent=
           {{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput HDif(unit="W/m2")
    "Diffuse horizontal solar radiation" annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}}), iconTransformation(extent={{-140,-100},
            {-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput HDirNor(unit="W/m2")
    "Direct normal solar radiation" annotation (Placement(transformation(extent=
           {{-140,-60},{-100,-20}}), iconTransformation(extent={{-140,-60},{-100,
            -20}})));

  Modelica.Blocks.Interfaces.RealOutput QCoo(unit="W")
    "Cooling provided at the coil" annotation (Placement(transformation(extent={
            {100,80},{120,100}}), iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput QHea(unit="W")
    "Heating provided at the coils" annotation (Placement(transformation(extent={
            {100,60},{120,80}}), iconTransformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput PLigInd(unit="W")
    "Indoor lighting power" annotation (Placement(transformation(extent={
            {100,40},{120,60}}), iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput PPlu(unit="W") "Plug loads"
                 annotation (Placement(transformation(extent={
            {100,20},{120,40}}), iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(unit="W")
    "Supply (and exhaust if present) fan power consumption" annotation (Placement(transformation(extent={
            {100,0},{120,20}}), iconTransformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PDX(unit="W")
    "Electrical power of DX coil compressor and condenser fan" annotation (Placement(transformation(extent={
            {100,-20},{120,0}}), iconTransformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Interfaces.RealOutput PLigOut(unit="W")
    "Power of outdoor lighting" annotation (Placement(transformation(extent={
            {100,-40},{120,-20}}), iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput PTot(unit="W")
    "Total building electricity consumption" annotation (Placement(transformation(extent={
            {100,-60},{120,-40}}), iconTransformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput PGas(unit="W")
    "Total building gas consumption" annotation (Placement(transformation(extent={
            {100,-80},{120,-60}}), iconTransformation(extent={{100,-80},{120,-60}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
          Documentation(info="<html>
This is a partial class that declares the input and output signals
for the linear regression model.
</html>", revisions="<html>
<ul>
<li>
April 22, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialRegression;
