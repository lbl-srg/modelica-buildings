within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Validation;
model Chiller
  "Validation of the base subsystem model with heat recovery chiller"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=30,
    mCon_flow_nominal=30,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=276.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=313.15,
    TConEntMin=303.15,
    TConEntMax=333.15)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Chiller chi(
    redeclare final package Medium=Medium,
    final dat=datChi,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3)
    "Subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
  Fluid.Sources.Boundary_pT evaWat(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Evaporator water boundary conditions"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,-62})));
  Fluid.Sources.Boundary_pT conWat(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Condenser water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,-62})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=7+273.15,
    y(final unit="K",
      displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare final package Medium=Medium,
    m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare final package Medium=Medium,
    m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={70,-40})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(
    redeclare final package Medium=Medium,
    m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-80,-80})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(
    redeclare final package Medium=Medium,
    m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={70,-80})));
  Modelica.Blocks.Sources.BooleanExpression uHea(
    y=time < 4000)
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Sources.BooleanExpression uCoo(
    y=time >= 1000)
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.TimeTable THeaWatRet(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,44;
      2,44;
      3,34;
      4.5,34;
      5,14;
      10,14],
    timeScale=1000,
    offset=273.15)
    "Heating water return temperature values"
    annotation (Placement(transformation(extent={{-190,-70},{-170,-50}})));
  Modelica.Blocks.Sources.TimeTable TChiWatRet(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,9;
      1,9;
      2,14;
      3,14;
      4,11;
      5,11],
    timeScale=1000,
    offset=273.15)
    "Chilled water return temperature values"
    annotation (Placement(transformation(extent={{160,-70},{140,-50}})));
equation
  connect(chi.port_bHeaWat,senTHeaWatSup.port_a)
    annotation (Line(points={{10,-56},{20,-56},{20,-40},{-70,-40}},color={0,127,255}));
  connect(senTHeaWatSup.port_b,conWat.ports[1])
    annotation (Line(points={{-90,-40},{-100,-40},{-100,-63}},color={0,127,255}));
  connect(evaWat.ports[1],senTChiWatSup.port_b)
    annotation (Line(points={{100,-63},{100,-40},{80,-40}},color={0,127,255}));
  connect(senTChiWatSup.port_a,chi.port_bChiWat)
    annotation (Line(points={{60,-40},{40,-40},{40,-68},{-10,-68}},color={0,127,255}));
  connect(conWat.ports[2],senTHeaWatRet.port_a)
    annotation (Line(points={{-100,-61},{-100,-80},{-90,-80}},color={0,127,255}));
  connect(senTHeaWatRet.port_b,chi.port_aHeaWat)
    annotation (Line(points={{-70,-80},{-40,-80},{-40,-56},{-10,-56}},color={0,127,255}));
  connect(chi.port_aChiWat,senTChiWatRet.port_b)
    annotation (Line(points={{10,-68},{-20,-68},{-20,-80},{60,-80}},color={0,127,255}));
  connect(senTChiWatRet.port_a,evaWat.ports[2])
    annotation (Line(points={{80,-80},{100,-80},{100,-61}},color={0,127,255}));
  connect(uCoo.y,chi.uCoo)
    annotation (Line(points={{-99,80},{-24,80},{-24,-60},{-12,-60}},color={255,0,255}));
  connect(uHea.y,chi.uHea)
    annotation (Line(points={{-99,100},{-20,100},{-20,-58},{-12,-58}},color={255,0,255}));
  connect(TChiWatSupSet.y,chi.TChiWatSupSet)
    annotation (Line(points={{-98,0},{-34,0},{-34,-64},{-12,-64}},color={0,0,127}));
  connect(THeaWatRet.y,conWat.T_in)
    annotation (Line(points={{-169,-60},{-140,-60},{-140,-58},{-122,-58}},color={0,0,127}));
  connect(TChiWatRet.y,evaWat.T_in)
    annotation (Line(points={{139,-60},{132,-60},{132,-58},{122,-58}},color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-140},{200,140}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Subsystems/Validation/Chiller.mos" "Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Chiller\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Chiller</a>.
</p>
</html>"));
end Chiller;
