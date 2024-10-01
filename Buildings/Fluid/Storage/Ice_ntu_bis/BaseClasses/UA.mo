within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses;
model UA
  UA_active ua_charging(coeff=per.coeCha)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  UA_active ua_discharging(coeff=per.coeDisCha)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Data.Tank.Experiment per
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealOutput UAhx
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput SOC "State of charge"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput Tin
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(
      threshold=273.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(add.y, UAhx)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(ua_charging.UAhx, add.u1) annotation (Line(points={{41,30},{50,30},{
          50,6},{58,6}}, color={0,0,127}));
  connect(ua_discharging.UAhx, add.u2) annotation (Line(points={{41,-10},{48,-10},
          {48,-6},{58,-6}}, color={0,0,127}));
  connect(SOC, ua_discharging.x) annotation (Line(points={{-120,-50},{0,-50},{
          0,-15},{18,-15}}, color={0,0,127}));
  connect(SOC, ua_charging.x) annotation (Line(points={{-120,-50},{0,-50},{0,25},
          {18,25}}, color={0,0,127}));
  connect(greaterEqualThreshold.y, not1.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={255,0,255}));
  connect(not1.y, ua_charging.active) annotation (Line(points={{-19,0},{-10,0},
          {-10,35},{18,35}}, color={255,0,255}));
  connect(greaterEqualThreshold.y, ua_discharging.active) annotation (Line(
        points={{-59,0},{-50,0},{-50,-20},{-10,-20},{-10,-5},{18,-5}}, color={
          255,0,255}));
  connect(Tin, greaterEqualThreshold.u) annotation (Line(points={{-120,50},{-92,
          50},{-92,0},{-82,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end UA;
