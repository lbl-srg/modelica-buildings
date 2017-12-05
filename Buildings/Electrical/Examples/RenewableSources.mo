within Buildings.Electrical.Examples;
model RenewableSources
  "Example model that shows the impact of renewable sources on the electrical grid"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Frequency f = 60 "Nominal grid frequency";
  parameter Modelica.SIunits.Voltage V_nominal = 480 "Nominal grid voltage";
  parameter Modelica.SIunits.Power PLoa_nominal = 3500
    "Nominal power of a load";
  parameter Modelica.SIunits.Power PWin = PLoa_nominal*4
    "Nominal power of the wind turbine";
  parameter Modelica.SIunits.Power PSun = PLoa_nominal*1.0
    "Nominal power of the PV";
  parameter Modelica.SIunits.DensityOfHeatFlowRate W_m2_nominal = 1000
    "Nominal solar power per unit area";
  parameter Real eff_PV = 0.12*0.85*0.9
    "Nominal solar power conversion efficiency (this should consider converion efficiency, area covered, AC/DC losses)";
  parameter Modelica.SIunits.Area A_PV = PSun/eff_PV/W_m2_nominal
    "Nominal area of a P installation";

  AC.ThreePhasesBalanced.Sources.Grid gri(
    f=f,
    V=V_nominal,
    phiSou=0) "Grid model that provides power to the system"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa1(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.8,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa2(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.9,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa3(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.8,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa4(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.88,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  AC.ThreePhasesBalanced.Lines.Line line1(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=1500,
    V_nominal=V_nominal,
    P_nominal=7*(PLoa_nominal + PSun) + PWin) "Electrical line"
              annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  AC.ThreePhasesBalanced.Lines.Line line2(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=3*(PLoa_nominal + PSun)) "Electrical line"
             annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  AC.ThreePhasesBalanced.Lines.Line line3(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=2*(PLoa_nominal + PSun)) "Electrical line"
             annotation (Placement(transformation(extent={{20,10},{40,30}})));
  AC.ThreePhasesBalanced.Lines.Line line4(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=(PLoa_nominal + PSun)) "Electrical line"
             annotation (Placement(transformation(extent={{60,10},{80,30}})));
  AC.ThreePhasesBalanced.Lines.Line line5(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=3*(PLoa_nominal + PSun) + PWin) "Electrical line"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa5(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.95,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa6(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.8,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa7(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=V_nominal,
    linearized=false,
    use_pf_in=false,
    pf=0.75,
    P_nominal=-PLoa_nominal) "Electrical load"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  AC.ThreePhasesBalanced.Lines.Line line6(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=2*(PLoa_nominal + PSun) + PWin) "Electrical line"
             annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  AC.ThreePhasesBalanced.Lines.Line line7(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=(PLoa_nominal + PSun) + PWin) "Electrical line"
             annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv1(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.85,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.S,
    til=0.5235987755983) "PV"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv2(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.8,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.E,
    til=0.5235987755983) "PV"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv3(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.8,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.W,
    til=0.34906585039887) "PV"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv4(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.9,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.S,
    til=0.5235987755983) "PV"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv5(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.95,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.W,
    til=0.61086523819802) "PV"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv6(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.9,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.E,
    til=0.43633231299858) "PV"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv7(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=V_nominal,
    pf=0.97,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.S,
    til=0.5235987755983) "PV"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  AC.ThreePhasesBalanced.Sources.WindTurbine winTur(
    V_nominal=V_nominal,
    h=15,
    hRef=10,
    pf=0.94,
    eta_DCAC=0.92,
    nWin=0.4,
    tableOnFile=false,
    scale=PWin) "Wind turbine model"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  AC.ThreePhasesBalanced.Lines.Line line8(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=V_nominal,
    P_nominal=PWin)
             annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data model"
    annotation (Placement(transformation(extent={{-100,74},{-80,94}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{120,28},{140,48}})));
  Modelica.Blocks.Sources.CombiTimeTable pow1(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2,0.1;
        4,0.1; 6,0.1; 8,0.8; 10,0.7; 12,0.3; 14,0.3;
        16,0.3; 18,0.8; 20,0.7; 22,0.3; 24,0.1],
    timeScale=3600)
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{-2,34},{-14,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow2(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2,0.1;
        4,0.1; 6,0.1; 8,0.8; 10,0.7; 12,0.3; 14,0.3;
        16,0.3; 18,0.8; 20,0.7; 22,0.3; 24,0.1],
    timeScale=3600)
    "Power consumption profile for load 2"
    annotation (Placement(transformation(extent={{36,34},{24,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow3(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2,0.1;
        4,0.1; 6,0.1; 8,0.8; 10,0.7; 12,0.3; 14,0.3;
        16,0.3; 18,0.8; 20,0.7; 22,0.3; 24,0.1],
    timeScale=3600)
    "Power consumption profile for load 3"
    annotation (Placement(transformation(extent={{76,34},{64,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow4(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.2; 2,0.2;
        4,0.2; 6,0.2; 8,0.8; 10,0.8; 12,0.6; 14,0.3;
        16,0.3; 18,0.8; 20,0.8; 22,0.3; 24,0.3],
    timeScale=3600)
    "Power consumption profile for load 4"
    annotation (Placement(transformation(extent={{116,34},{104,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow5(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2,0.1;
        4,0.1; 6,0.1; 8,0.5; 10,0.2; 12,0.3; 14,0.3;
        16,0.3; 18,0.9; 20,0.4; 22,0.2; 24,0.1],
    timeScale=3600)
    "Power consumption profile for load 5"
    annotation (Placement(transformation(extent={{16,-46},{4,-34}})));
  Modelica.Blocks.Sources.CombiTimeTable pow6(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2,0.1;
        4,0.1; 6,0.1; 8,0.8; 10,0.7; 12,0.3; 14,0.3;
        16,0.3; 18,0.8; 20,0.7; 22,0.3; 24,0.1],
    timeScale=3600)
    "Power consumption profile for load 6"
    annotation (Placement(transformation(extent={{56,-46},{44,-34}})));
  Modelica.Blocks.Sources.CombiTimeTable pow7(extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.2; 2,0.1;
        4,0.1; 6,0.1; 8,0.4; 10,0.7; 12,0.3; 14,0.3;
        16,0.3; 18,0.2; 20,0.7; 22,0.3; 24,0.2],
    timeScale=3600)
    "Power consumption profile for load 7"
    annotation (Placement(transformation(extent={{96,-46},{84,-34}})));
  AC.ThreePhasesBalanced.Sensors.Probe sen1(V_nominal=V_nominal, perUnit=true)
    "Voltage probe"
    annotation (Placement(transformation(extent={{-70,0},{-50,-20}})));
  AC.ThreePhasesBalanced.Sensors.Probe sen2(V_nominal=V_nominal, perUnit=true)
    "Voltage probe" annotation (Placement(transformation(extent={{-10,10},{10,-10}},
          origin={90,8})));
  AC.ThreePhasesBalanced.Sensors.Probe sen3(V_nominal=V_nominal, perUnit=true)
    "Voltage probe" annotation (Placement(transformation(extent={{-10,10},{10,-10}},
          origin={110,-40})));
  Modelica.Blocks.Continuous.Integrator EWin
    "Energy produced by the wind turbine"
    annotation (Placement(transformation(extent={{200,-14},{220,6}})));
  Modelica.Blocks.Math.MultiSum PSol(nu=7, y(unit="W"))
    "Total produced solar power"
    annotation (Placement(transformation(extent={{174,64},{186,76}})));
  Modelica.Blocks.Continuous.Integrator ESol
    "Energy produced by the solar panels"
    annotation (Placement(transformation(extent={{200,60},{220,80}})));
  Modelica.Blocks.Sources.RealExpression PLoa(
    y=PLoa_nominal*(pow1.y[1] + pow2.y[1] + pow3.y[1] + pow4.y[1] + pow5.y[1] + pow6.y[1] + pow7.y[1]))
    "Total power consumed by the loads"
    annotation (Placement(transformation(extent={{170,-70},{190,-50}})));
  Modelica.Blocks.Continuous.Integrator ELoa(y_start=1E-10)
    "Energy consumed by the loads"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}})));
  Modelica.Blocks.Math.Add EPro "Total produced power by renewables"
    annotation (Placement(transformation(extent={{240,20},{260,40}})));
  Modelica.Blocks.Math.Division ERat "Ratio of produced over consumed energy"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
equation
  connect(gri.terminal, line1.terminal_n) annotation (Line(
      points={{-90,40},{-90,20},{-80,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, loa1.terminal) annotation (Line(
      points={{-60,20},{-40,20},{-40,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, line2.terminal_n) annotation (Line(
      points={{-60,20},{-20,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, loa2.terminal) annotation (Line(
      points={{0,20},{0,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, line3.terminal_n) annotation (Line(
      points={{0,20},{20,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, loa3.terminal) annotation (Line(
      points={{40,20},{40,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, line4.terminal_n) annotation (Line(
      points={{40,20},{60,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line4.terminal_p, loa4.terminal) annotation (Line(
      points={{80,20},{80,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, line5.terminal_n) annotation (Line(
      points={{-60,20},{-40,20},{-40,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa5.terminal, line5.terminal_p) annotation (Line(
      points={{-20,-40},{-20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line5.terminal_p, line6.terminal_n) annotation (Line(
      points={{-20,-10},{0,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line6.terminal_p, line7.terminal_n) annotation (Line(
      points={{20,-10},{40,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa6.terminal, line6.terminal_p) annotation (Line(
      points={{20,-40},{20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa7.terminal, line7.terminal_p) annotation (Line(
      points={{60,-40},{60,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, pv1.terminal) annotation (Line(
      points={{-60,20},{-40,20},{-40,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, pv2.terminal) annotation (Line(
      points={{0,20},{0,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, pv3.terminal) annotation (Line(
      points={{40,20},{40,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line4.terminal_p, pv4.terminal) annotation (Line(
      points={{80,20},{80,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pv5.terminal, line5.terminal_p) annotation (Line(
      points={{-20,-70},{-20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pv6.terminal, loa6.terminal) annotation (Line(
      points={{20,-70},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pv7.terminal, loa7.terminal) annotation (Line(
      points={{60,-70},{60,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line7.terminal_p, line8.terminal_n) annotation (Line(
      points={{60,-10},{80,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line8.terminal_p, winTur.terminal) annotation (Line(
      points={{100,-10},{120,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv1.weaBus) annotation (Line(
      points={{-80,84},{-30,84},{-30,79}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv2.weaBus) annotation (Line(
      points={{-80,84},{10,84},{10,79}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv3.weaBus) annotation (Line(
      points={{-80,84},{50,84},{50,79}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv4.weaBus) annotation (Line(
      points={{-80,84},{90,84},{90,79}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,84},{130,84},{130,38}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.winSpe, winTur.vWin) annotation (Line(
      points={{130,38},{130,2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaDat.weaBus, pv5.weaBus) annotation (Line(
      points={{-80,84},{148,84},{148,-54},{-10,-54},{-10,-61}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv6.weaBus) annotation (Line(
      points={{-80,84},{148,84},{148,-54},{30,-54},{30,-61}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv7.weaBus) annotation (Line(
      points={{-80,84},{148,84},{148,-54},{70,-54},{70,-61}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(loa2.y, pow2.y[1]) annotation (Line(
      points={{20,40},{23.4,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pow1.y[1], loa1.y) annotation (Line(
      points={{-14.6,40},{-20,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa3.y, pow3.y[1]) annotation (Line(
      points={{60,40},{63.4,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa4.y, pow4.y[1]) annotation (Line(
      points={{100,40},{103.4,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa5.y, pow5.y[1]) annotation (Line(
      points={{0,-40},{3.4,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa6.y, pow6.y[1]) annotation (Line(
      points={{40,-40},{43.4,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa7.y, pow7.y[1]) annotation (Line(
      points={{80,-40},{83.4,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sen1.term, line1.terminal_p) annotation (Line(
      points={{-60,-1},{-60,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen2.term, line4.terminal_p) annotation (Line(
      points={{90,17},{90,20},{80,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen3.term, line8.terminal_p) annotation (Line(
      points={{110,-31},{110,-10},{100,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(EWin.u, winTur.P) annotation (Line(
      points={{198,-4},{141,-4}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(pv1.P, PSol.u[1]) annotation (Line(
      points={{-19,77},{-12,77},{-12,92},{160,92},{160,73.6},{174,73.6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.u[2], pv2.P) annotation (Line(
      points={{174,72.4},{160,72.4},{160,92},{30,92},{30,77},{21,77}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.u[3], pv3.P) annotation (Line(
      points={{174,71.2},{160,71.2},{160,92},{70,92},{70,77},{61,77}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.u[4], pv4.P) annotation (Line(
      points={{174,70},{160,70},{160,92},{110,92},{110,77},{101,77}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.u[5], pv5.P) annotation (Line(
      points={{174,68.8},{160,68.8},{160,-90},{10,-90},{10,-63},{1,-63}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.y, ESol.u) annotation (Line(
      points={{187.02,70},{198,70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.u[6], pv6.P) annotation (Line(
      points={{174,67.6},{168,67.6},{168,72},{160,72},{160,-90},{50,-90},{50,-63},
          {41,-63}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(PSol.u[7], pv7.P) annotation (Line(
      points={{174,66.4},{168,66.4},{168,68},{160,68},{160,-90},{90,-90},{90,-63},
          {81,-63}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(ELoa.u, PLoa.y) annotation (Line(
      points={{198,-60},{191,-60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(EPro.u1, ESol.y) annotation (Line(
      points={{238,36},{230,36},{230,70},{221,70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(EPro.u2, EWin.y) annotation (Line(
      points={{238,24},{230,24},{230,-4},{221,-4}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(ERat.u1, EPro.y) annotation (Line(
      points={{278,6},{270,6},{270,30},{261,30}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(ERat.u2, ELoa.y) annotation (Line(
      points={{278,-6},{270,-6},{270,-60},{221,-60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  annotation (
    Documentation(revisions="<html>
    <ul>
<li>
October 2, 2015, by Michael Wetter:<br/>
Changed signals for post-processing to avoid using the conditionally
enabled connector <code>loa1.y</code> outside of a <code>connect</code>
statement.
</li>
<li>
March 27, 2015, by Michael Wetter:<br/>
Revised model.
</li>
<li>
March 25, 2015, by Marco Bonvini:<br/>
Added model.
</li>
</ul>
</html>", info="<html>
<p>
This model shows the impact of renewables on the electric grid.
The sensors show how the voltage per unit fluctuates depending on
the building load and the power produced by the PV and the wind turbine.
To the right of the model is the post-processing that computes the
ratio of energy produced by the renewables over the energy consumed
by the loads.
</p>
<h4>Ratio between energy produced by renewables and energy consumed </h4>
<p>
Th image below shows the ratio between the energy produced by renewable energy sources
over the energy consumed by the loads over one year. The solid line indicates the
Net-Zero Energy goal and the blue line indicates the actual ratio for the
neighborhood represented by the model.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Examples/RenewableSources/EnergyRatio.png\"/>
</p>

<h4>Voltage losses due to power generated by renewables</h4>
<p>
The scatter plots show the voltage levels at different locations in the network. In particular,
the plots highlight how the voltage fluctuations are related to the power generated by the
renewable sources, to the wind speed and the global horizontal irradiation.
As expected, voltage increases with the power generated by the renewables,
causing possible instabilities to the electrical grid.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Examples/RenewableSources/VoltageLevel.png\"/>
</p>
</html>"),
experiment(
      StopTime=2678400,
      Tolerance=1e-06),
            __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/Examples/RenewableSources.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{320,
            100}})));
end RenewableSources;
