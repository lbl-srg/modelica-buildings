within Districts.BuildingLoads.BaseClasses;
model LinearRegression
  "Whole building load model based on linear regression and table look-up"

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K")
    "Outdoor dry-bulb temperature" annotation (Placement(transformation(extent={
            {-140,60},{-100,100}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TDewPoi(unit="K")
    "Outdoor dew-point temperature" annotation (Placement(transformation(extent=
           {{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput IDif(unit="W/m2")
    "Diffuse horizontal solar radiation" annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}}), iconTransformation(extent={{-140,-100},
            {-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput IDirNor(unit="W/m2")
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

  Modelica.Blocks.Tables.CombiTable1Ds coef(
    final tableOnFile=true,
    tableName=tab1,
    final fileName=fileName,
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Table reader with coefficients for linear model"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
protected
  Utilities.SimulationTime           simTim "Simulation time"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
public
  parameter String fileName="NoName" "File where matrix is stored";
equation
  connect(simTim.y, coef.u) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end LinearRegression;
