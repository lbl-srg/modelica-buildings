within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup;
model Headered
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.CondenserWaterPumpGroup(
      final typ=Types.CondenserWaterPumpGroup.HeaderedPrimary);

  Fluid.MixingVolumes.MixingVolume vol(nPorts=3)
    "Inlet node mixing volume"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Fluid.Actuators.Valves.TwoWayLinear valChi[nChi] "Chillers valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
  BaseClasses.HeaderedPumps pumPri "Primary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Actuators.Valves.TwoWayLinear valWSE if has_wse
    "Waterside economizer valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-60})));
equation
  connect(busCon.out.ySpePumPri, pumPri.y) annotation (Line(
      points={{0,100},{0,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.y_actual, busCon.inp.uStaPumPri) annotation (Line(points={{11,8},{
          20,8},{20,80},{0,80},{0,100}},        color={255,0,255}), Text(
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
  connect(pumPri.V_flow, busCon.inp.VPri_flow) annotation (Line(points={{11,5},{
          28,5},{28,80},{0,80},{0,100}},        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(valChi.port_b, ports_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, pumPri.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pumPri.port_b, vol.ports[1]) annotation (Line(points={{10,0},{40,0},{
          40,40},{37.3333,40}},
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
                    Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Headered;
