within Buildings.Fluid.Storage.Ice_ntu.BaseClasses.Tests;
model SOC
  extends Modelica.Icons.Example;
  soc_calc soc_calc_c1(Vtank=per.Vtank, Hf=per.Hf)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Data.Tank.Experiment per
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=10000, startTime=
        100000)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=4184*0.5*20)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-4184*0.5*20)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(booleanPulse.y, switch1.u2)
    annotation (Line(points={{-79,10},{-42,10}}, color={255,0,255}));
  connect(realExpression.y, switch1.u1) annotation (Line(points={{-79,40},{-50,
          40},{-50,18},{-42,18}}, color={0,0,127}));
  connect(switch1.y, soc_calc_c1.Q)
    annotation (Line(points={{-19,10},{38,10}}, color={0,0,127}));
  connect(realExpression1.y, switch1.u3) annotation (Line(points={{-79,-30},{
          -50,-30},{-50,2},{-42,2}}, color={0,0,127}));
end SOC;
