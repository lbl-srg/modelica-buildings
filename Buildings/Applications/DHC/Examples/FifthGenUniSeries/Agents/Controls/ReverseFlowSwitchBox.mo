within Buildings.Examples.DistrictReservoirNetworks.Agents.Controls;
model ReverseFlowSwitchBox
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput massFlowHPDHW "in kg/s"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput massFlow
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-72,64},{-52,84}})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Logical.Switch switchMode
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant heatingModeOn(k=0)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Interfaces.RealInput massFlowHPSH "in kg/s"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput massFlowFC "in kg/s"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Math.Add coolingModeOn(k1=-1)
    annotation (Placement(transformation(extent={{0,-84},{20,-64}})));
equation
  connect(greaterEqual.y, switchMode.u2)
    annotation (Line(points={{21,0},{58,0}}, color={255,0,255}));
  connect(add.y, greaterEqual.u1) annotation (Line(points={{-51,74},{-40,74},{
          -40,0},{-2,0}},   color={0,0,127}));
  connect(heatingModeOn.y, switchMode.u1) annotation (Line(points={{21,40},{40,
          40},{40,8},{58,8}},     color={0,0,127}));
  connect(switchMode.y, massFlow)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(massFlowHPSH, add.u1) annotation (Line(points={{-120,80},{-74,80}},
                              color={0,0,127}));
  connect(massFlowHPDHW, add.u2) annotation (Line(points={{-120,0},{-94,0},{-94,
          68},{-74,68}},      color={0,0,127}));
  connect(massFlowFC, greaterEqual.u2) annotation (Line(points={{-120,-80},{-74,
          -80},{-74,-8},{-2,-8}},       color={0,0,127}));
  connect(massFlowFC, coolingModeOn.u2) annotation (Line(points={{-120,-80},{-2,
          -80}},                          color={0,0,127}));
  connect(add.y, coolingModeOn.u1) annotation (Line(points={{-51,74},{-40,74},{
          -40,-68},{-2,-68}},       color={0,0,127}));
  connect(coolingModeOn.y, switchMode.u3) annotation (Line(points={{21,-74},{40,
          -74},{40,-8},{58,-8}},     color={0,0,127}));
end ReverseFlowSwitchBox;
