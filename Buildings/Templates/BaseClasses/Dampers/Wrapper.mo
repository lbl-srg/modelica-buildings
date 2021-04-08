within Buildings.Templates.BaseClasses.Dampers;
model Wrapper "Wrapper class for damper models"
  extends Buildings.Templates.Interfaces.Damper;

  Modulated mod(redeclare final package Medium = Medium) if
       typ==Buildings.Templates.Types.Damper.Modulated
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  TwoPosition twoPos(redeclare final package Medium = Medium) if
       typ==Buildings.Templates.Types.Damper.TwoPosition
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  None non(redeclare final package Medium = Medium) if
       typ==Buildings.Templates.Types.Damper.None
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Barometric bar(redeclare final package Medium = Medium) if
    typ==Buildings.Templates.Types.Damper.Barometric
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
equation
  connect(port_a, mod.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-20},
          {-10,-20}}, color={0,127,255}));
  connect(mod.port_b, port_b) annotation (Line(points={{10,-20},{60,-20},{60,0},
          {100,0}}, color={0,127,255}));
  connect(twoPos.port_b, port_b) annotation (Line(points={{30,-60},{60,-60},{60,
          0},{100,0}}, color={0,127,255}));
  connect(port_a, twoPos.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -60},{10,-60}}, color={0,127,255}));
  connect(port_a, non.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,20},
          {-30,20}}, color={0,127,255}));
  connect(non.port_b, port_b) annotation (Line(points={{-10,20},{60,20},{60,0},
          {100,0}}, color={0,127,255}));
  connect(mod.busCon, busCon) annotation (Line(
      points={{0,-10},{0,-10},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(twoPos.busCon, busCon) annotation (Line(
      points={{20,-50},{20,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(port_a, bar.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,50},
          {-50,50}}, color={0,127,255}));
  connect(bar.port_b, port_b) annotation (Line(points={{-30,50},{60,50},{60,0},
          {100,0}}, color={0,127,255}));

  annotation (
    Icon(
      graphics={
        Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1),
         Bitmap(
           visible=DynamicSelect(true, typ<>Buildings.Templates.Types.Damper.None and
             typ<>Buildings.Templates.Types.Damper.NoPath),
           extent={{-80,-58},{80,102}},
           fileName="modelica://Buildings/../../../Desktop/Exponential.svg")}));
end Wrapper;
