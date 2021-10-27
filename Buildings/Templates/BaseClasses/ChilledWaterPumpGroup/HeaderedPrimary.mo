within Buildings.Templates.BaseClasses.ChilledWaterPumpGroup;
model HeaderedPrimary
  extends Buildings.Templates.Interfaces.ChilledWaterPumpGroup(
    final typ=Types.ChilledWaterPumpGroup.HeaderedPrimary);

  Fluid.MixingVolumes.MixingVolume vol "Inlet node mixing volume"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Fluid.FixedResistances.Junction splByp(redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg or bypass splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,0})));
  Fluid.Actuators.Valves.TwoWayLinear valByp if has_byp
                                             "Bypass valve" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-60})));
  Fluid.Actuators.Valves.TwoWayLinear valWSE if has_WSEByp
    "Waterside economizer bypass valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-60})));
  Fluid.Actuators.Valves.TwoWayLinear valChi[nChi] if has_ParChi
                                                   "Chillers valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
  BaseClasses.HeaderedPumps pumPri "Primary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(splByp.port_2, port_b)
    annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
  connect(splByp.port_3, valByp.port_a) annotation (Line(points={{40,-10},{40,
          -20},{1.77636e-15,-20},{1.77636e-15,-50}},
                                                color={0,127,255}));
  connect(valByp.port_b, port_byp)
    annotation (Line(points={{-1.83187e-15,-70},{0,-100}}, color={0,127,255}));
  connect(port_series, vol.ports[1]) annotation (Line(points={{-100,60},{-60,60},
          {-60,20},{-40,20},{-40,40}},          color={0,127,255}));
  connect(port_WSEByp, valWSE.port_a)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(valWSE.port_b, vol.ports[2]) annotation (Line(points={{-60,-60},{-40,
          -60},{-40,40}},     color={0,127,255}));
  connect(ports_parallel, valChi.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(valChi.port_b, vol.ports[3:3])
    annotation (Line(points={{-60,0},{-40,0},{-40,40}}, color={0,127,255}));
  connect(vol.ports[4], pumPri.port_a) annotation (Line(points={{-40,40},{-40,0},
          {-10,0}},         color={0,127,255}));
  connect(busCon.out.ySpePumPri, pumPri.y) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.y_actual, busCon.inp.uStaPumPri) annotation (Line(points={{11,8},{
          20,8},{20,80},{0.1,80},{0.1,100.1}},  color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yValChi, valChi[1].y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-70,80},{-70,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.out.yValWSE, valWSE.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-20,80},{-20,-40},{-70,-40},{-70,-48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.yValByp, valByp.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{20,80},{20,-60},{12,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumPri.port_b, splByp.port_1)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(pumPri.V_flow, busCon.inp.VPri_flow) annotation (Line(points={{11,5},{
          28,5},{28,80},{0.1,80},{0.1,100.1}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeaderedPrimary;
