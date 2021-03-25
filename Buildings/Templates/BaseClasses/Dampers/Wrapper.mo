within Buildings.Templates.BaseClasses.Dampers;
model Wrapper
  extends Buildings.Templates.Interfaces.Damper;

  Modulated modulated(
    redeclare final package Medium=Medium) if
       typ==Buildings.Templates.Types.Damper.Modulated
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  TwoPosition twoPosition(
    redeclare final package Medium=Medium) if
       typ==Buildings.Templates.Types.Damper.TwoPosition
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  None none(
    redeclare final package Medium=Medium) if
       typ==Buildings.Templates.Types.Damper.None
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  NoPath noPath(
    redeclare final package Medium=Medium) if
    typ==Buildings.Templates.Types.Damper.NoPath
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Barometric barometric(
    redeclare final package Medium=Medium) if
    typ==Buildings.Templates.Types.Damper.Barometric
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
equation
  connect(port_a, modulated.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -20},{-10,-20}}, color={0,127,255}));
  connect(modulated.port_b, port_b) annotation (Line(points={{10,-20},{60,-20},{
          60,0},{100,0}}, color={0,127,255}));
  connect(twoPosition.port_b, port_b) annotation (Line(points={{30,-60},{60,-60},
          {60,0},{100,0}}, color={0,127,255}));
  connect(port_a, twoPosition.port_a) annotation (Line(points={{-100,0},{-80,0},
          {-80,-60},{10,-60}},  color={0,127,255}));
  connect(port_a, none.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,20},
          {-30,20}}, color={0,127,255}));
  connect(none.port_b, port_b) annotation (Line(points={{-10,20},{60,20},{60,0},
          {100,0}},color={0,127,255}));
  connect(modulated.busCon, busCon) annotation (Line(
      points={{0,-10},{0,-10},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(twoPosition.busCon, busCon) annotation (Line(
      points={{20,-50},{20,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(noPath.port_b, port_b) annotation (Line(points={{-50,80},{60,80},{60,0},
          {100,0}}, color={0,127,255}));
  connect(port_a, noPath.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          80},{-70,80}}, color={0,127,255}));
  connect(port_a, barometric.port_a) annotation (Line(points={{-100,0},{-80,0},{
          -80,50},{-50,50}}, color={0,127,255}));
  connect(barometric.port_b, port_b) annotation (Line(points={{-30,50},{60,50},{
          60,0},{100,0}}, color={0,127,255}));
end Wrapper;
