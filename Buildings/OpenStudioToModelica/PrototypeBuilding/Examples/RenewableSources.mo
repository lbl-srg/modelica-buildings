within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model RenewableSources
  "Example model that shows the impact of renewable sources on the electrical grid"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Frequency f = 60 "Nominal grid frequency";
  parameter Modelica.SIunits.Voltage V_nominal = 1200 "Nominal grid voltage";
  parameter Modelica.SIunits.Power P_hvac_nominal = 20e3
    "Nominal HVAC cooling/heating power";
  parameter Real COP_nominal = 3
    "Nominal coefficient of performance of HVAC systems";
  parameter Modelica.SIunits.Power PPluLig_nominal = 12e3
    "Nominal power consumption of plug loads and lights";
  parameter Modelica.SIunits.Power PLoa_nominal = P_hvac_nominal/COP_nominal + PPluLig_nominal
    "Nominal power of a building load";
  parameter Modelica.SIunits.Power PWin = PLoa_nominal*3
    "Nominal power of the wind turbine";
  parameter Modelica.SIunits.Power PSun = PLoa_nominal*2.0
    "Nominal power of the PV";
  parameter Modelica.SIunits.DensityOfHeatFlowRate W_m2_nominal = 1000
    "Nominal solar power per unit area";
  parameter Real eff_PV = 0.12*0.89*0.9
    "Nominal solar power conversion efficiency (this should consider converion efficiency, area covered, AC/DC losses)";
  parameter Modelica.SIunits.Area A_PV = PSun/eff_PV/W_m2_nominal
    "Nominal area of a P installation";
  parameter Real frac_PV[7] = {0.5, 0.2, 1.7, 1.8, 0.2, 2.5, 0.3}
    "Redistribution of the PV among the different buildings";

  Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(
    f=f,
    V=V_nominal,
    phiSou=0) "Grid model that provides power to the system"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line1(
    V_nominal=V_nominal,
    P_nominal=7*(PLoa_nominal) + PWin,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=1500) "Electrical line"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line2(
    V_nominal=V_nominal,
    P_nominal=3*(PLoa_nominal),
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300) "Electrical line"
    annotation (Placement(transformation(extent={{-18,2},{2,22}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line3(
    V_nominal=V_nominal,
    P_nominal=2*(PLoa_nominal),
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300) "Electrical line"
    annotation (Placement(transformation(extent={{34,2},{54,22}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line4(
    V_nominal=V_nominal,
    P_nominal=(PLoa_nominal),
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300) "Electrical line"
    annotation (Placement(transformation(extent={{142,2},{162,22}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line5(
    V_nominal=V_nominal,
    P_nominal=3*(PLoa_nominal) + PWin,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300) "Electrical line"
    annotation (Placement(transformation(extent={{-46,18},{-26,38}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line6(
    V_nominal=V_nominal,
    P_nominal=2*(PLoa_nominal) + PWin,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300) "Electrical line"
    annotation (Placement(transformation(extent={{-4,18},{16,38}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line7(
    V_nominal=V_nominal,
    P_nominal=(PLoa_nominal) + PWin,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300) "Electrical line"
    annotation (Placement(transformation(extent={{70,18},{90,38}})));
  Electrical.AC.ThreePhasesBalanced.Sources.WindTurbine winTur(
    V_nominal=V_nominal,
    h=15,
    hRef=10,
    pf=0.94,
    eta_DCAC=0.92,
    nWin=0.4,
    tableOnFile=false,
    scale=PWin) "Wind turbine model"
    annotation (Placement(transformation(extent={{216,10},{236,30}})));
  Electrical.AC.ThreePhasesBalanced.Lines.Line line8(
    V_nominal=V_nominal,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
          commercialCable = Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10(),
    l=300,
    P_nominal=PWin) "Electrical line"
    annotation (Placement(transformation(extent={{150,18},{170,38}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam="modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data model"
    annotation (Placement(transformation(extent={{-100,74},{-80,94}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{216,74},{236,94}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen1(V_nominal=V_nominal,
      perUnit=true) "Voltage probe"
    annotation (Placement(transformation(extent={{-70,0},{-50,-20}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen7(V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent=
           {{-10,10},{10,-10}}, origin={170,-10})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen8(V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent=
           {{-10,10},{10,-10}}, origin={200,-10})));
  Modelica.Blocks.Continuous.Integrator EWin
    "Energy produced by the wind turbine"
    annotation (Placement(transformation(extent={{272,16},{292,36}})));
  Modelica.Blocks.Continuous.Integrator ESol
    "Energy produced by the solar panels"
    annotation (Placement(transformation(extent={{282,66},{302,86}})));
  Modelica.Blocks.Sources.RealExpression PLoa(y=bui1.PHvac + bui2.PHvac + bui3.PHvac
         + bui4.PHvac + bui5.PHvac + bui6.PHvac + bui7.PHvac + bui1.PLigPlu +
        bui2.PLigPlu + bui3.PLigPlu + bui4.PLigPlu + bui5.PLigPlu + bui6.PLigPlu
         + bui7.PLigPlu)
    "Total power consumed by the HVAC, lights and plug loads"
    annotation (Placement(transformation(extent={{240,-40},{260,-20}})));
  Modelica.Blocks.Continuous.Integrator ELoa(y_start=1E-10)
    "Energy consumed by the loads"
    annotation (Placement(transformation(extent={{272,-40},{292,-20}})));
  Modelica.Blocks.Math.Add EPro "Total produced power by renewables"
    annotation (Placement(transformation(extent={{320,22},{340,42}})));
  Modelica.Blocks.Math.Division ERat "Ratio of produced over consumed energy"
    annotation (Placement(transformation(extent={{356,-12},{376,8}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui1(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    azi_pv=Buildings.Types.Azimuth.S,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    pfPV=0.85,
    pf=0.8,
    A=frac_PV[1]*A_PV,
    til_pv=0.5235987755983) "Office building 1"
    annotation (Placement(transformation(extent={{-32,40},{-52,60}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui3(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    azi_pv=Buildings.Types.Azimuth.W,
    pfPV=0.8,
    pf=0.8,
    A=frac_PV[3]*A_PV,
    til_pv=0.34906585039887) "Office building 3"
    annotation (Placement(transformation(extent={{48,40},{28,60}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui5(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    azi_pv=Buildings.Types.Azimuth.W,
    pfPV=0.95,
    pf=0.95,
    A=frac_PV[5]*A_PV,
    til_pv=0.61086523819802) "Office building 5"
    annotation (Placement(transformation(extent={{128,40},{108,60}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui7(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    azi_pv=Buildings.Types.Azimuth.S,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    pfPV=0.97,
    pf=0.75,
    A=frac_PV[7]*A_PV,
    til_pv=0.5235987755983) "Office building 7"
    annotation (Placement(transformation(extent={{208,40},{188,60}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui2(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    pf=0.9,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    azi_pv=Buildings.Types.Azimuth.E,
    pfPV=0.8,
    A=frac_PV[2]*A_PV,
    til_pv=0.5235987755983) "Office building 2"
    annotation (Placement(transformation(extent={{8,40},{-12,60}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui4(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    azi_pv=Buildings.Types.Azimuth.S,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    pfPV=0.9,
    pf=0.88,
    A=frac_PV[4]*A_PV,
    til_pv=0.5235987755983) "Office building 4"
    annotation (Placement(transformation(extent={{88,40},{68,60}})));
  Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeControlled bui6(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    V_nominal=V_nominal,
    P_hvac_nominal=P_hvac_nominal,
    COP_nominal=COP_nominal,
    a=a,
    azi_pv=Buildings.Types.Azimuth.E,
    pfPV=0.9,
    pf=0.8,
    A=frac_PV[6]*A_PV,
    til_pv=0.43633231299858) "Office building 6"
    annotation (Placement(transformation(extent={{168,40},{148,60}})));
  Modelica.Blocks.Sources.RealExpression PSol(y=bui1.PPv + bui2.PPv + bui3.PPv +
        bui4.PPv + bui5.PPv + bui6.PPv + bui7.PPv)
    "Total power produced by PVs"
    annotation (Placement(transformation(extent={{242,66},{262,86}})));
  parameter Real a[:]={0.3,0.7}
    "Coefficients for efficiency curve (need p(a=a, y=1)=1)";
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen4(V_nominal=V_nominal,
      perUnit=true) "Voltage probe"
    annotation (Placement(transformation(extent={{50,0},{70,-20}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen5(V_nominal=V_nominal,
      perUnit=true) "Voltage probe"
    annotation (Placement(transformation(extent={{90,0},{110,-20}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen6(V_nominal=V_nominal,
      perUnit=true) "Voltage probe"
    annotation (Placement(transformation(extent={{130,0},{150,-20}})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen2(V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent=
           {{-10,10},{10,-10}}, origin={-20,-10})));
  Electrical.AC.ThreePhasesBalanced.Sensors.Probe sen3(V_nominal=V_nominal,
      perUnit=true) "Voltage probe" annotation (Placement(transformation(extent=
           {{-10,10},{10,-10}}, origin={20,-10})));
equation
  connect(gri.terminal, line1.terminal_n) annotation (Line(
      points={{-90,40},{-90,20},{-80,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, line2.terminal_n) annotation (Line(
      points={{-60,20},{-46,20},{-46,12},{-18,12}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, line3.terminal_n) annotation (Line(
      points={{2,12},{34,12}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, line4.terminal_n) annotation (Line(
      points={{54,12},{142,12}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, line5.terminal_n) annotation (Line(
      points={{-60,20},{-46,20},{-46,28}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line5.terminal_p, line6.terminal_n) annotation (Line(
      points={{-26,28},{-4,28}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line6.terminal_p, line7.terminal_n) annotation (Line(
      points={{16,28},{70,28}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,84},{226,84}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.winSpe, winTur.vWin) annotation (Line(
      points={{226,84},{226,32}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(sen1.term, line1.terminal_p) annotation (Line(
      points={{-60,-1},{-60,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sen7.term, line4.terminal_p) annotation (Line(
      points={{170,-1},{170,12},{162,12}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(EWin.u, winTur.P) annotation (Line(
      points={{270,26},{237,26}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(ELoa.u, PLoa.y) annotation (Line(
      points={{270,-30},{261,-30}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(EPro.u1, ESol.y) annotation (Line(
      points={{318,38},{312,38},{312,76},{303,76}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(EPro.u2, EWin.y) annotation (Line(
      points={{318,26},{293,26}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(ERat.u1, EPro.y) annotation (Line(
      points={{354,4},{348,4},{348,32},{341,32}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(ERat.u2, ELoa.y) annotation (Line(
      points={{354,-8},{348,-8},{348,-30},{293,-30}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(bui3.term, line2.terminal_p) annotation (Line(points={{27,47.1429},{
          27,50},{20,50},{20,12},{2,12}},
                                   color={0,120,120}));
  connect(weaDat.weaBus, bui1.weaBus) annotation (Line(
      points={{-80,84},{-32,84},{-32,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, bui3.weaBus) annotation (Line(
      points={{-80,84},{-26,84},{48,84},{48,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(line3.terminal_p, bui5.term) annotation (Line(points={{54,12},{100,12},
          {100,47.1429},{107,47.1429}},
                              color={0,120,120}));
  connect(line4.terminal_p,bui7. term) annotation (Line(points={{162,12},{180,
          12},{180,47.1429},{187,47.1429}},
                            color={0,120,120}));
  connect(PSol.y, ESol.u)
    annotation (Line(points={{263,76},{263,76},{280,76}}, color={0,0,127}));
  connect(weaDat.weaBus,bui7. weaBus) annotation (Line(
      points={{-80,84},{16,84},{208,84},{208,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, bui5.weaBus) annotation (Line(
      points={{-80,84},{-2,84},{128,84},{128,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(line5.terminal_p, bui2.term) annotation (Line(points={{-26,28},{-20,
          28},{-20,47.1429},{-13,47.1429}},
                              color={0,120,120}));
  connect(line6.terminal_p, bui4.term) annotation (Line(points={{16,28},{60,28},
          {60,47.1429},{67,47.1429}},
                            color={0,120,120}));
  connect(line1.terminal_p, bui1.term) annotation (Line(points={{-60,20},{-60,
          20},{-60,47.1429},{-53,47.1429}},
                              color={0,120,120}));
  connect(sen8.term, winTur.terminal) annotation (Line(points={{200,-1},{200,-1},
          {200,20},{216,20}},color={0,120,120}));
  connect(weaDat.weaBus, bui2.weaBus) annotation (Line(
      points={{-80,84},{-36,84},{8,84},{8,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, bui4.weaBus) annotation (Line(
      points={{-80,84},{4,84},{88,84},{88,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, bui6.weaBus) annotation (Line(
      points={{-80,84},{44,84},{168,84},{168,52.8571}},
      color={255,204,51},
      thickness=0.5));
  connect(line7.terminal_p, line8.terminal_n)
    annotation (Line(points={{90,28},{120,28},{150,28}}, color={0,120,120}));
  connect(line7.terminal_p, bui6.term) annotation (Line(points={{90,28},{140,28},
          {140,47.1429},{147,47.1429}},
                              color={0,120,120}));
  connect(line8.terminal_p, winTur.terminal) annotation (Line(points={{170,28},{
          200,28},{200,20},{216,20}}, color={0,120,120}));
  connect(sen4.term, line7.terminal_n) annotation (Line(points={{60,-1},{60,20},
          {60,28},{70,28}}, color={0,120,120}));
  connect(sen5.term, bui5.term)
    annotation (Line(points={{100,-1},{100,47.1429},{107,47.1429}},
                                                          color={0,120,120}));
  connect(sen6.term, line8.terminal_n)
    annotation (Line(points={{140,-1},{140,28},{150,28}}, color={0,120,120}));
  connect(sen2.term, line6.terminal_n)
    annotation (Line(points={{-20,-1},{-20,28},{-4,28}}, color={0,120,120}));
  connect(sen3.term, line3.terminal_n)
    annotation (Line(points={{20,-1},{20,12},{34,12}}, color={0,120,120}));
  annotation (
    Documentation(revisions="<html>
<ul>
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
      StopTime=3.1536e+07,
      Interval=1800,
      Tolerance=1e-05,
      __Dymola_Algorithm="Radau"),
            __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/Examples/RenewableSources.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{380,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end RenewableSources;
