within Buildings.Templates.BaseClasses.Sensors;
model DifferentialPressure
  extends Buildings.Templates.Interfaces.Sensor(
    final typ=Types.Sensor.DifferentialPressure);

  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium)
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
  Modelica.Blocks.Routing.RealPassThrough pSup_rel
 if Modelica.Utilities.Strings.find(insNam, "pSup")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  Modelica.Blocks.Routing.RealPassThrough dpOut
 if Modelica.Utilities.Strings.find(insNam, "dpOut")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,50})));
  Modelica.Blocks.Routing.RealPassThrough pRet_rel
 if Modelica.Utilities.Strings.find(insNam, "pRet")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,50})));
equation
  connect(port_a, senRelPre.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -40},{-50,-40}}, color={0,127,255}));
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  connect(senRelPre.port_b, port_bRef)
    annotation (Line(points={{-30,-40},{-20,-40},{-20,-90},{0,-90},{0,-100}},
                                                          color={0,127,255}));
  connect(senRelPre.p_rel, pSup_rel.u)
    annotation (Line(points={{-40,-31},{-40,-20},{-8.88178e-16,-20},{
          -8.88178e-16,38}},                      color={0,0,127}));
  connect(senRelPre.p_rel, dpOut.u) annotation (Line(points={{-40,-31},{-40,-20},
          {40,-20},{40,38}}, color={0,0,127}));
  connect(dpOut.y,busCon.inp.dpOut)
    annotation (Line(points={{40,61},{40,80},{2,80},{2,100.1},{0.1,100.1}},
                                        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pSup_rel.y,busCon.inp.pSup_rel)  annotation (Line(points={{6.66134e-16,
          61},{6.66134e-16,80},{0,80},{0,100},{0,100.1},{0.1,100.1}},
                                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senRelPre.p_rel, pRet_rel.u) annotation (Line(points={{-40,-31},{-40,
          38}}, color={0,0,127}));
  connect(pRet_rel.y,busCon.inp.pRet_rel)  annotation (Line(points={{-40,61},{-40,
          80},{-2,80},{-2,100},{0.1,100},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DifferentialPressure;
