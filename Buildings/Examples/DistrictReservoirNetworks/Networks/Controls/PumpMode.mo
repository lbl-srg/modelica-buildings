within Buildings.Examples.DistrictReservoirNetworks.Networks.Controls;
model PumpMode
  "Defines m flow of pums. 0 - \"winter mode\", abs (m_flow_BN) - \"summer mode\""
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput massFlowInBN "in kg/s"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput massFlowPumps
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Switch switchMode
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant winterMode(k=0)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold flowDirectionInBN
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Abs summerMode
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(switchMode.y, massFlowPumps)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(winterMode.y, switchMode.u1) annotation (Line(points={{21,40},{40,
          40},{40,8},{58,8}}, color={0,0,127}));
  connect(flowDirectionInBN.y, switchMode.u2)
    annotation (Line(points={{1,0},{58,0}}, color={255,0,255}));
  connect(massFlowInBN, flowDirectionInBN.u)
    annotation (Line(points={{-120,0},{-22,0}}, color={0,0,127}));
  connect(summerMode.y, switchMode.u3) annotation (Line(points={{21,-40},{
          40,-40},{40,-8},{58,-8}}, color={0,0,127}));
  connect(massFlowInBN, summerMode.u) annotation (Line(points={{-120,0},{-40,0},
          {-40,-40},{-2,-40}},        color={0,0,127}));
end PumpMode;
