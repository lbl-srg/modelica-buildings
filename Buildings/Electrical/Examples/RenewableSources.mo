within Buildings.Electrical.Examples;
model RenewableSources
  "Example model that shows the impact of renewable sources on the electrical grid"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Frequency f = 60 "Nominal grid frequency";
  parameter Modelica.SIunits.Voltage Vn = 480 "Nominal grid voltage";
  parameter Modelica.SIunits.Power P_load_nominal = 3500
    "Nominal power of a load";
  parameter Modelica.SIunits.Power P_wind = P_load_nominal*4
    "Nominal power of the wind turbine";
  parameter Modelica.SIunits.Power P_sun = P_load_nominal*1.0
    "Nominal power of the PV";
  parameter Modelica.SIunits.DensityOfHeatFlowRate W_m2_nominal = 1000
    "Nominal solar power per unit area";
  parameter Real eff_PV = 0.12*0.85*0.9
    "Nominal solar power conversion efficiency (this should consider converion efficiency, area covered, AC/DC losses)";
  parameter Modelica.SIunits.Area A_PV = P_sun/eff_PV/W_m2_nominal
    "Nominal area of a PV installation";
  Modelica.SIunits.Power P_solar = pv1.P + pv2.P + pv3.P + pv4.P + pv5.P + pv6.P + pv7.P
    "Total solar power produced by the PVs";
  Modelica.SIunits.Power P_wind_turb = winTur.P
    "Total solar power produced by the wind turbine";
  Modelica.SIunits.Power P_loads = P_load_nominal*(loa1.y + loa2.y + loa3.y + loa4.y + loa5.y + loa6.y + loa7.y)
    "Total solar power consumed by the loads";
  Modelica.SIunits.Energy E_solar(start = 0);
  Modelica.SIunits.Energy E_loads(start = 10);
  Modelica.SIunits.Energy E_wind(start = 0);
  Real E_ratio;
  AC.ThreePhasesBalanced.Sources.Grid gri(
    f=f,
    V=Vn,
    phiSou=0) "Grid model that provides power to the system"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa1(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.8,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa2(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.9,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa3(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.8,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa4(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.88,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  AC.ThreePhasesBalanced.Lines.Line line1(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=1500,
    V_nominal=Vn,
    P_nominal=7*(P_load_nominal + P_sun) + P_wind)
              annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  AC.ThreePhasesBalanced.Lines.Line line2(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=3*(P_load_nominal + P_sun))
             annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  AC.ThreePhasesBalanced.Lines.Line line3(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=2*(P_load_nominal + P_sun))
             annotation (Placement(transformation(extent={{20,10},{40,30}})));
  AC.ThreePhasesBalanced.Lines.Line line4(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=(P_load_nominal + P_sun))
             annotation (Placement(transformation(extent={{60,10},{80,30}})));
  AC.ThreePhasesBalanced.Lines.Line line5(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=3*(P_load_nominal + P_sun) + P_wind)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa5(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.95,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa6(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.8,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  AC.ThreePhasesBalanced.Loads.Inductive loa7(mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    V_nominal=Vn,
    linearized=false,
    use_pf_in=false,
    pf=0.75,
    P_nominal=-P_load_nominal)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  AC.ThreePhasesBalanced.Lines.Line line6(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=2*(P_load_nominal + P_sun) + P_wind)
             annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  AC.ThreePhasesBalanced.Lines.Line line7(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=(P_load_nominal + P_sun) + P_wind)
             annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv1(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.85,
    lat=weaDat.lat,
    til=0.5235987755983,
    azi=Buildings.Types.Azimuth.S)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv2(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.8,
    lat=weaDat.lat,
    til=0.5235987755983,
    azi=Buildings.Types.Azimuth.E)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv3(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.8,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.W,
    til=0.34906585039887)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv4(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.9,
    lat=weaDat.lat,
    til=0.5235987755983,
    azi=Buildings.Types.Azimuth.S)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv5(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.95,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.W,
    til=0.61086523819802)
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv6(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.9,
    lat=weaDat.lat,
    azi=Buildings.Types.Azimuth.E,
    til=0.43633231299858)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  AC.ThreePhasesBalanced.Sources.PVSimpleOriented pv7(
    eta_DCAC=0.89,
    A=A_PV,
    fAct=0.9,
    eta=0.12,
    linearized=false,
    V_nominal=Vn,
    pf=0.97,
    lat=weaDat.lat,
    til=0.5235987755983,
    azi=Buildings.Types.Azimuth.S)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  AC.ThreePhasesBalanced.Sources.WindTurbine winTur(
    V_nominal=Vn,
    scale=P_wind,
    h=15,
    hRef=10,
    pf=0.94,
    eta_DCAC=0.92,
    nWin=0.4,
    tableOnFile=false) "Wind turbine model"
    annotation (Placement(transformation(extent={{116,-10},{136,10}})));
  AC.ThreePhasesBalanced.Lines.Line line8(mode=Buildings.Electrical.Types.CableMode.automatic,
      l=300,
    V_nominal=Vn,
    P_nominal=P_wind)
             annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam="modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data model"
    annotation (Placement(transformation(extent={{-100,74},{-80,94}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{116,28},{136,48}})));
  Modelica.Blocks.Sources.CombiTimeTable pow1(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2*3600,0.1;
        4*3600,0.1; 6*3600,0.1; 8*3600,0.8; 10*3600,0.7; 12*3600,0.3; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.8; 20*3600,0.7; 22*3600,0.3; 24*3600,0.1])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{-2,34},{-14,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow2(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2*3600,0.1;
        4*3600,0.1; 6*3600,0.1; 8*3600,0.8; 10*3600,0.7; 12*3600,0.3; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.8; 20*3600,0.7; 22*3600,0.3; 24*3600,0.1])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{36,34},{24,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow3(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2*3600,0.1;
        4*3600,0.1; 6*3600,0.1; 8*3600,0.8; 10*3600,0.7; 12*3600,0.3; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.8; 20*3600,0.7; 22*3600,0.3; 24*3600,0.1])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{76,34},{64,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow4(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.2; 2*3600,0.2;
        4*3600,0.2; 6*3600,0.2; 8*3600,0.8; 10*3600,0.8; 12*3600,0.6; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.8; 20*3600,0.8; 22*3600,0.3; 24*3600,0.3])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{116,34},{104,46}})));
  Modelica.Blocks.Sources.CombiTimeTable pow5(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2*3600,0.1;
        4*3600,0.1; 6*3600,0.1; 8*3600,0.5; 10*3600,0.2; 12*3600,0.3; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.9; 20*3600,0.4; 22*3600,0.2; 24*3600,0.1])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{16,-36},{4,-24}})));
  Modelica.Blocks.Sources.CombiTimeTable pow6(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.1; 2*3600,0.1;
        4*3600,0.1; 6*3600,0.1; 8*3600,0.8; 10*3600,0.7; 12*3600,0.3; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.8; 20*3600,0.7; 22*3600,0.3; 24*3600,0.1])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{56,-36},{44,-24}})));
  Modelica.Blocks.Sources.CombiTimeTable pow7(               extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,0.2; 2*3600,0.1;
        4*3600,0.1; 6*3600,0.1; 8*3600,0.4; 10*3600,0.7; 12*3600,0.3; 14*3600,0.3;
        16*3600,0.3; 18*3600,0.2; 20*3600,0.7; 22*3600,0.3; 24*3600,0.2])
    "Power consumption profile for load 1"
    annotation (Placement(transformation(extent={{96,-36},{84,-24}})));
  AC.ThreePhasesBalanced.Sensors.Probe sen(V_nominal=Vn, perUnit=true)
    annotation (Placement(transformation(extent={{-70,2},{-50,-18}})));
  AC.ThreePhasesBalanced.Sensors.Probe sen_a(V_nominal=Vn, perUnit=true)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={98,20})));
  AC.ThreePhasesBalanced.Sensors.Probe sen_b(V_nominal=Vn, perUnit=true)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={124,-26})));
equation
  der(E_solar) = P_solar;
  der(E_loads) = P_loads;
  der(E_wind) = P_wind_turb;
  E_ratio = (E_solar + E_wind)/E_loads;
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
      points={{-60,20},{-40,20},{-40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa5.terminal, line5.terminal_p) annotation (Line(
      points={{-20,-30},{-20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line5.terminal_p, line6.terminal_n) annotation (Line(
      points={{-20,0},{0,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line6.terminal_p, line7.terminal_n) annotation (Line(
      points={{20,0},{40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa6.terminal, line6.terminal_p) annotation (Line(
      points={{20,-30},{20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa7.terminal, line7.terminal_p) annotation (Line(
      points={{60,-30},{60,0}},
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
      points={{-20,-60},{-20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pv6.terminal, loa6.terminal) annotation (Line(
      points={{20,-60},{20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pv7.terminal, loa7.terminal) annotation (Line(
      points={{60,-60},{60,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line7.terminal_p, line8.terminal_n) annotation (Line(
      points={{60,0},{80,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line8.terminal_p, winTur.terminal) annotation (Line(
      points={{100,0},{116,0}},
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
      points={{-80,84},{126,84},{126,38}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.winSpe, winTur.vWin) annotation (Line(
      points={{126,38},{126,12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaDat.weaBus, pv5.weaBus) annotation (Line(
      points={{-80,84},{140,84},{140,-44},{-10,-44},{-10,-51}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv6.weaBus) annotation (Line(
      points={{-80,84},{140,84},{140,-44},{30,-44},{30,-51}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pv7.weaBus) annotation (Line(
      points={{-80,84},{140,84},{140,-44},{70,-44},{70,-51}},
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
      points={{0,-30},{3.4,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa6.y, pow6.y[1]) annotation (Line(
      points={{40,-30},{43.4,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa7.y, pow7.y[1]) annotation (Line(
      points={{80,-30},{83.4,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sen.term, line1.terminal_p) annotation (Line(
      points={{-60,1},{-60,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_a.term, line4.terminal_p) annotation (Line(
      points={{89,20},{80,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen_b.term, line8.terminal_p) annotation (Line(
      points={{115,-26},{100,-26},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
    Documentation(revisions="<html>
<ul>
<li>
March 25, 2014, by Marco Bonvini:<br/>
Added model and user's guide.
</li>
</ul>
</html>", info="<html>
<p>
This model shows the impact of renewables on the electric grid.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,100}})));
end RenewableSources;
