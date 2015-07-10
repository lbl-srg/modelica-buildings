within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model PowerFactorControl "Test problem for different power factor control"
extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Frequency f = 60 "Nominal grid frequency";
  parameter Modelica.SIunits.Voltage V_nominal = 1200 "Nominal grid voltage";
  parameter Real pfCon = 0.5 "Power factor during active control";

  Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(
    f=f,
    V=V_nominal,
    phiSou=0) "Grid model that provides power to the system"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line1(
    V_nominal=V_nominal,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=1500,
    P_nominal=2e4) "Electrical line"
    annotation (Placement(transformation(extent={{-118,10},{-98,30}})));
  Electrical.AC.ThreePhasesBalanced.Sources.PVSimple pv(
    V_nominal=V_nominal,
    eta_DCAC=0.89,
    use_pf_in=true,
    pf=0.8,
    A=5000) "PV model"
    annotation (Placement(transformation(extent={{10,18},{30,38}})));
  Modelica.Blocks.Continuous.FirstOrder PPfFil(
    initType=Modelica.Blocks.Types.Init.InitialState,
    T=10,
    k=1,
    y_start=0.8) "Filter for power factor"
    annotation (Placement(transformation(extent={{-28,100},{-8,120}})));
  Controls.SetPoints.Table conPF(table=[1.08,0.8; 1.10,pfCon])
    "Controller for power factor of load"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen(V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},           origin={-90,58})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loa(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=V_nominal,
    initMode=Buildings.Electrical.Types.InitMode.zero_current,
    use_pf_in=false,
    pf=0.7) "Electric load representing the building"
                                                     annotation (Placement(transformation(extent={{-26,-14},
            {-2,10}})));
  Modelica.Blocks.Sources.Constant const(k=-2*2e3)
    annotation (Placement(transformation(extent={{28,-12},{8,8}})));
  Electrical.AC.ThreePhasesBalanced.Sources.Grid gri1(
    f=f,
    V=V_nominal,
    phiSou=0) "Grid model that provides power to the system"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line2(
    V_nominal=V_nominal,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=1500,
    P_nominal=2e4) "Electrical line"
    annotation (Placement(transformation(extent={{-118,-110},{-98,-90}})));
  Electrical.AC.ThreePhasesBalanced.Sources.PVSimple pv1(
    V_nominal=V_nominal,
    eta_DCAC=0.89,
    pf=0.8,
    A=5000,
    use_pf_in=false) "PV model"
    annotation (Placement(transformation(extent={{10,-102},{30,-82}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe senUnc(V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent=
           {{-10,-10},{10,10}}, origin={-90,-62})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loa1(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=V_nominal,
    initMode=Buildings.Electrical.Types.InitMode.zero_current,
    use_pf_in=false,
    pf=0.7) "Electric load representing the building"
                                                     annotation (Placement(transformation(extent={{-26,
            -134},{-2,-110}})));
  Modelica.Blocks.Sources.Constant const2(k=-2*2e3)
    annotation (Placement(transformation(extent={{28,-132},{8,-112}})));
  Electrical.AC.ThreePhasesBalanced.Sources.Grid gri2(
    f=f,
    V=V_nominal,
    phiSou=0) "Grid model that provides power to the system"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line3(
    V_nominal=V_nominal,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=1500,
    P_nominal=2e4) "Electrical line"
    annotation (Placement(transformation(extent={{82,10},{102,30}})));
  Electrical.AC.ThreePhasesBalanced.Sources.PVSimple pv2(
    V_nominal=V_nominal,
    eta_DCAC=0.89,
    pf=0.8,
    A=5000,
    use_pf_in=false) "PV model"
    annotation (Placement(transformation(extent={{210,18},{230,38}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen2(
                                                      V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},           origin={110,58})));
  Electrical.AC.ThreePhasesBalanced.Loads.Inductive loa2(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=V_nominal,
    initMode=Buildings.Electrical.Types.InitMode.zero_current,
    use_pf_in=false,
    pf=0.7) "Electric load representing the building"
                                                     annotation (Placement(transformation(extent={{174,-14},
            {198,10}})));
  Modelica.Blocks.Sources.Constant const4(
                                         k=-2*2e3)
    annotation (Placement(transformation(extent={{228,-12},{208,8}})));
  Modelica.Blocks.Sources.Ramp     const5(
    height=1e3,
    duration=100,
    startTime=100,
    offset=0)
    annotation (Placement(transformation(extent={{282,-120},{262,-100}})));
  Electrical.AC.ThreePhasesBalanced.Loads.Capacitive loa3(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=V_nominal,
    initMode=Buildings.Electrical.Types.InitMode.zero_current,
    use_pf_in=false,
    pf=0.01) "Electric load representing the building"
                                                     annotation (Placement(transformation(extent={{158,48},
            {182,72}})));
  Controls.Continuous.LimPID conPID(
    k=100,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    Ti=1)
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Modelica.Blocks.Math.Gain gain(k=0.0001*1e3*500)
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  Modelica.Blocks.Sources.Constant const6(k=1.08)
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Modelica.Blocks.Continuous.FirstOrder PPfFil1(
    initType=Modelica.Blocks.Types.Init.InitialState,
    T=10,
    k=1,
    y_start=0) "Filter for power factor"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Modelica.Blocks.Sources.Constant const7(k=0)
    annotation (Placement(transformation(extent={{212,132},{192,152}})));
equation
  connect(gri.terminal, line1.terminal_n) annotation (Line(points={{-130,40},{-130,
          40},{-130,20},{-118,20}},
                                  color={0,120,120}));
  connect(line1.terminal_p, pv.terminal) annotation (Line(points={{-98,20},{-52,
          20},{-52,28},{10,28}},
                           color={0,120,120}));
  connect(loa.terminal, line1.terminal_p) annotation (Line(points={{-26,-2},{-52,
          -2},{-52,20},{-98,20}},
                            color={0,120,120}));
  connect(sen.term, line1.terminal_p)
    annotation (Line(points={{-90,49},{-90,20},{-98,20}}, color={0,120,120}));
  connect(sen.V, conPF.u) annotation (Line(points={{-83,61},{-78,61},{-78,62},{-74,
          62},{-74,110},{-62,110}},
                                 color={0,0,127}));
  connect(conPF.y, PPfFil.u)
    annotation (Line(points={{-39,110},{-39,110},{-30,110}},
                                               color={0,0,127}));
  connect(PPfFil.y, pv.pf_in) annotation (Line(points={{-7,110},{0,110},{0,46},{
          -30,46},{-30,40},{-30,36},{8,36}},
                                           color={0,0,127}));
  connect(const.y, loa.Pow)
    annotation (Line(points={{7,-2},{6,-2},{-2,-2}},
                                                 color={0,0,127}));
  connect(gri1.terminal, line2.terminal_n) annotation (Line(points={{-130,-80},{
          -130,-80},{-130,-100},{-118,-100}},
                                     color={0,120,120}));
  connect(line2.terminal_p, pv1.terminal) annotation (Line(points={{-98,-100},{-52,
          -100},{-52,-92},{10,-92}},
                                  color={0,120,120}));
  connect(loa1.terminal, line2.terminal_p) annotation (Line(points={{-26,-122},{
          -52,-122},{-52,-100},{-98,-100}},
                                    color={0,120,120}));
  connect(senUnc.term, line2.terminal_p) annotation (Line(points={{-90,-71},{-90,
          -100},{-98,-100}},     color={0,120,120}));
  connect(const2.y, loa1.Pow)
    annotation (Line(points={{7,-122},{6,-122},{-2,-122}},   color={0,0,127}));
  connect(gri2.terminal, line3.terminal_n) annotation (Line(points={{70,40},{70,
          40},{70,20},{82,20}},  color={0,120,120}));
  connect(line3.terminal_p, pv2.terminal) annotation (Line(points={{102,20},{148,
          20},{148,28},{210,28}},     color={0,120,120}));
  connect(loa2.terminal, line3.terminal_p) annotation (Line(points={{174,-2},{148,
          -2},{148,20},{102,20}},     color={0,120,120}));
  connect(sen2.term, line3.terminal_p)
    annotation (Line(points={{110,49},{110,20},{102,20}}, color={0,120,120}));
  connect(const4.y, loa2.Pow)
    annotation (Line(points={{207,-2},{206,-2},{198,-2}}, color={0,0,127}));
  connect(const5.y, pv2.G) annotation (Line(points={{261,-110},{261,-110},{254,
          -110},{254,46},{220,46},{220,40}},
                     color={0,0,127}));
  connect(loa3.terminal, pv2.terminal) annotation (Line(points={{158,60},{158,60},
          {148,60},{148,28},{210,28}},     color={0,120,120}));
  connect(sen2.V, conPID.u_m)
    annotation (Line(points={{117,61},{130,61},{130,98}}, color={0,0,127}));
  connect(const6.y, conPID.u_s)
    annotation (Line(points={{101,110},{118,110}}, color={0,0,127}));
  connect(gain.y, loa3.Pow) annotation (Line(points={{241,110},{246,110},{246,104},
          {246,60},{182,60}},      color={0,0,127}));
  connect(conPID.y, PPfFil1.u)
    annotation (Line(points={{141,110},{150,110},{158,110}}, color={0,0,127}));
  connect(PPfFil1.y, gain.u) annotation (Line(points={{181,110},{199.5,110},{218,
          110}}, color={0,0,127}));
  connect(const5.y, pv.G) annotation (Line(points={{261,-110},{188,-110},{50,
          -110},{50,52},{20,52},{20,40}}, color={0,0,127}));
  connect(const5.y, pv1.G) annotation (Line(points={{261,-110},{158,-110},{50,
          -110},{50,-70},{20,-70},{20,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{300,160}})),
    experiment(
      StopTime=300,
      Tolerance=1e-05,
      __Dymola_Algorithm="Radau"));
end PowerFactorControl;
