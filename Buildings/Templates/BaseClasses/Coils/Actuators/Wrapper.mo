within Buildings.Templates.BaseClasses.Coils.Actuators;
model Wrapper "Wrapper class for actuator models"
  extends Buildings.Templates.Interfaces.Actuator;

  None non(
    redeclare final package Medium=Medium) if typ==Buildings.Templates.Types.Actuator.None
    "No actuator"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  ThreeWayValve valThrWay(
    redeclare final package Medium=Medium) if typ==Buildings.Templates.Types.Actuator.ThreeWayValve
    "Three-way valve"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  TwoWayValve valTwoWay(
    redeclare final package Medium=Medium) if typ==Buildings.Templates.Types.Actuator.TwoWayValve
    "Two-way valve"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
equation
  connect(port_aSup, non.port_aSup) annotation (Line(points={{-40,-100},{-40,-80},
          {-4,-80},{-4,-70}}, color={0,127,255}));
  connect(non.port_bRet, port_bRet) annotation (Line(points={{4,-70},{4,-80},{40,
          -80},{40,-100}}, color={0,127,255}));
  connect(port_aSup, valThrWay.port_aSup) annotation (Line(points={{-40,-100},{-40,
          -40},{-4,-40},{-4,-30}}, color={0,127,255}));
  connect(valThrWay.port_bRet, port_bRet) annotation (Line(points={{4,-30},{4,-40},
          {40,-40},{40,-100}}, color={0,127,255}));
  connect(y, valThrWay.y) annotation (Line(points={{-120,0},{-80,0},{-80,-20},{-11,
          -20}}, color={0,0,127}));
  connect(y, non.y) annotation (Line(points={{-120,0},{-80,0},{-80,-60},{-11,-60}},
        color={0,0,127}));
  connect(port_aSup, valTwoWay.port_aSup) annotation (Line(points={{-40,-100},{-40,
          0},{-4,0},{-4,10}}, color={0,127,255}));
  connect(valTwoWay.port_bRet, port_bRet) annotation (Line(points={{4,10},{4,0},
          {40,0},{40,-100}}, color={0,127,255}));
  connect(y, valTwoWay.y) annotation (Line(points={{-120,0},{-80,0},{-80,20},{-11,
          20}}, color={0,0,127}));
  connect(port_bSup, valTwoWay.port_bSup) annotation (Line(points={{-40,100},{-40,
          40},{-4,40},{-4,30}}, color={0,127,255}));
  connect(valTwoWay.port_aRet, port_aRet) annotation (Line(points={{4,30},{4,40},
          {60,40},{60,80},{40,80},{40,100}}, color={0,127,255}));
  connect(valThrWay.port_aRet, port_aRet) annotation (Line(points={{4,-10},{4,-6},
          {60,-6},{60,80},{40,80},{40,100}}, color={0,127,255}));
  connect(non.port_aRet, port_aRet) annotation (Line(points={{4,-50},{4,-46},{60,
          -46},{60,80},{40,80},{40,100}}, color={0,127,255}));
  connect(non.port_bSup, port_bSup) annotation (Line(points={{-4,-50},{-4,-46},{
          -60,-46},{-60,80},{-40,80},{-40,100}}, color={0,127,255}));
  connect(valThrWay.port_bSup, port_bSup) annotation (Line(points={{-4,-10},{-4,
          -6},{-60,-6},{-60,80},{-40,80},{-40,100}}, color={0,127,255}));
end Wrapper;
