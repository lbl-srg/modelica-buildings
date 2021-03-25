within Buildings.Templates.BaseClasses.Fans;
model Wrapper "Wrapper class for fan models"
  extends Buildings.Templates.Interfaces.Fan;

  MultipleVariable mulVar(
    redeclare final package Medium = Medium,
    final per=per) if typ==Buildings.Templates.Types.Fan.MultipleVariable
    "Multiple fans (identical) - Variable speed"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  SingleVariable sinVar(
    redeclare final package Medium = Medium,
    final per=per) if typ==Buildings.Templates.Types.Fan.SingleVariable
    "Single fan - Variable speed"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  SingleConstant sinCst(
    redeclare final package Medium = Medium,
    final per=per) if typ==Buildings.Templates.Types.Fan.SingleConstant
    "Single fan - Constant speed"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  None non(
    redeclare final package Medium = Medium,
    final per=per) if typ==Buildings.Templates.Types.Fan.None
    "No fan"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

equation
  connect(port_a, non.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,60},
          {-70,60}}, color={0,127,255}));
  connect(port_a, sinCst.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,
          20},{-50,20}}, color={0,127,255}));
  connect(port_a, sinVar.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,
          -20},{-30,-20}}, color={0,127,255}));
  connect(port_a, mulVar.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,
          -60},{-10,-60}}, color={0,127,255}));
  connect(mulVar.port_b, port_b) annotation (Line(points={{10,-60},{80,-60},{80,
          0},{100,0}}, color={0,127,255}));
  connect(sinVar.port_b, port_b) annotation (Line(points={{-10,-20},{80,-20},{80,
          0},{100,0}}, color={0,127,255}));
  connect(sinCst.port_b, port_b) annotation (Line(points={{-30,20},{80,20},{80,0},
          {100,0}}, color={0,127,255}));
  connect(non.port_b, port_b) annotation (Line(points={{-50,60},{80,60},{80,0},{
          100,0}}, color={0,127,255}));
  connect(non.busCon, busCon) annotation (Line(
      points={{-60,70},{-60,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(sinCst.busCon, busCon) annotation (Line(
      points={{-40,30},{-40,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(sinVar.busCon, busCon) annotation (Line(
      points={{-20,-10},{-20,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(mulVar.busCon, busCon) annotation (Line(
      points={{0,-50},{0,100}},
      color={255,204,51},
      thickness=0.5));
end Wrapper;
