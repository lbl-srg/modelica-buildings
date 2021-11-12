within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup;
model Dedicated
  extends
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PrimaryPumpGroup(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Dedicated,
    final has_ParChi=true,
    final has_WSEByp=false);
  Fluid.FixedResistances.Junction splByp(redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Bypass splitter"               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,0})));
  Fluid.Actuators.Valves.TwoWayLinear valByp if has_byp
                                             "Bypass valve" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-60})));
  BaseClasses.DedicatedPrimaryPumps pum(
    redeclare final package Medium = Medium,
    final nPum=nChi) "Pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate V_flow(have_sen=
        has_floSen)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Templates.BaseClasses.PassThroughFluid pas(redeclare each final
      package Medium = Medium) if has_comLeg annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-60})));
equation
  connect(splByp.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(splByp.port_3, valByp.port_a) annotation (Line(points={{80,-10},{80,-40},
          {1.77636e-15,-40},{1.77636e-15,-50}}, color={0,127,255}));
  connect(valByp.port_b, port_byp)
    annotation (Line(points={{-1.83187e-15,-70},{0,-100}}, color={0,127,255}));
  connect(pum.y_actual, busCon.uStaPumPri) annotation (Line(points={{11,8},{20,8},
          {20,80},{0,80},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ports_parallel, pum.ports_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(busCon.yValByp, valByp.y) annotation (Line(
      points={{0,100},{0,80},{-40,80},{-40,-60},{-12,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pum.port_b, V_flow.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(V_flow.port_b, splByp.port_1)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(V_flow.y, busCon.V_flow) annotation (Line(points={{50,12},{50,80},{0,80},
          {0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_byp, pas.port_b) annotation (Line(points={{0,-100},{0,-80},{80,
          -80},{80,-70}}, color={0,127,255}));
  connect(splByp.port_3, pas.port_a)
    annotation (Line(points={{80,-10},{80,-50}}, color={0,127,255}));
  connect(busCon.ySpe, pum.y) annotation (Line(
      points={{0,100},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-40,0},{40,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{-100,20},{-60,20},{-60,40},{-6,40}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-100,-20},{-60,-20},{-60,-40},{-6,-40}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{40,60},{60,60},{60,-20},{40,-20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dedicated;
