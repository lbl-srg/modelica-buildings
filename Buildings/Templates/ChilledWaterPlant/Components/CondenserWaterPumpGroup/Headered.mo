within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup;
model Headered
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.CondenserWaterPumpGroup(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup.Headered);

  Fluid.MixingVolumes.MixingVolume vol(nPorts=3)
    "Inlet node mixing volume"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Fluid.Actuators.Valves.TwoWayLinear valChi[nChi] "Chillers valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
  Buildings.Templates.ChilledWaterPlant.Components.BaseClasses.ParallelPumps
                            pumPri "Primary pumps"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Actuators.Valves.TwoWayLinear valWSE if has_wse
    "Waterside economizer valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-60})));
equation
  connect(busCon.out.ySpePumPri, pumPri.y) annotation (Line(
      points={{0,100},{0,18},{-30,18},{-30,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.y_actual, busCon.inp.uStaPumPri) annotation (Line(points={{-19,8},
          {0,8},{0,100}},                       color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yValChi, valChi[1].y) annotation (Line(
      points={{0,100},{0,80},{70,80},{70,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(valChi.port_b, ports_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, pumPri.port_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
  connect(pumPri.port_b, vol.ports[1]) annotation (Line(points={{-20,0},{40,0},
          {40,20},{37.3333,20},{37.3333,40}},
                        color={0,127,255}));
  connect(vol.ports[2:2], valChi.port_a) annotation (Line(points={{40,40},{40,
          40},{40,0},{60,0}},
                          color={0,127,255}));
  connect(valWSE.port_a, vol.ports[3]) annotation (Line(points={{60,-60},{40,
          -60},{40,40},{42.6667,40}}, color={0,127,255}));
  connect(valWSE.port_b, port_wse)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
  connect(busCon.out.yValWSE, valWSE.y) annotation (Line(
      points={{0,100},{0,80},{52,80},{52,-30},{70,-30},{70,-48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,0},{-100,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-8,40},{-60,40},{-60,-40},{-8,-40}},
          color={28,108,200},
          thickness=1),
                    Bitmap(
        extent={{-40,0},{40,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{40,60},{60,60},{60,-20},{40,-20}},
          color={28,108,200},
          thickness=1),
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Headered;
