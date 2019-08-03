within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Validation;
model CoolingCoil "Validation of cooling coil model"
  final parameter Modelica.SIunits.Temperature TSupSet=291.15
    "Supply air temperature setpoint";
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil
    coolingCoil(controllerTypeCooCoi=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      kCooCoi=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.Ramp                        TSup(
    final height=4,
    final offset=TSupSet - 2,
    final duration=3600*8)    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Sources.Constant                        TSupSetSig(final k=
        TSupSet)     "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Logical.Sources.Constant fanStatus(k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Sources.Pulse zonSta(               offset=2, period=3600*2)
                                                               "Zone state"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(TSup.y, coolingCoil.TSup) annotation (Line(points={{-59,-10},{-36,-10},
          {-36,-2},{-12,-2}}, color={0,0,127}));
  connect(TSupSetSig.y, coolingCoil.TSupCoo) annotation (Line(points={{-59,30},{
          -36,30},{-36,2},{-12,2}}, color={0,0,127}));
  connect(fanStatus.y, coolingCoil.uSupFan) annotation (Line(points={{-59,-50},{
          -20,-50},{-20,-8},{-12,-8}}, color={255,0,255}));
  connect(zonSta.y, reaToInt.u)
    annotation (Line(points={{-59,70},{-42,70}}, color={0,0,127}));
  connect(reaToInt.y, coolingCoil.uZonSta) annotation (Line(points={{-19,70},{-14,
          70},{-14,46},{-20,46},{-20,8},{-12,8}}, color={255,127,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=28000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end CoolingCoil;
