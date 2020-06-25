within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Validation;
model Chiller
  "Validation of the base subsystem model with heat recovery chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";
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
    TConEntMax=333.15) "Chiller performance data"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Subsystems.Chiller chi(
    redeclare final package Medium = Medium,
    final dat=datChi,
    dpCon_nominal=15E3,
    dpEva_nominal=15E3) "Subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=45 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Fluid.Sources.Boundary_pT evaWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Evaporator water boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-62})));
  Fluid.Sources.Boundary_pT conWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Condenser water boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-62})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(
    k=7 + 273.15,
    y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatRet(
    offset=9 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=5,
    duration=1000,
    startTime=1000) "Chilled water return temperature"
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatRet(
    offset=44 + 273.15,
    y(final unit="K", displayUnit="degC"),
    height=-10,
    duration=1000,
    startTime=2000) "Heating water return temperature"
    annotation (Placement(transformation(extent={{-190,-90},{-170,-70}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-40})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-80})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(redeclare final package
      Medium =
        Medium, m_flow_nominal=datChi.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dTChiWatRet(
    offset=0,
    y(final unit="K", displayUnit="degC"),
    height=-3,
    duration=1000,
    startTime=3000) "Chilled water return additional deltaT"
    annotation (Placement(transformation(extent={{190,-50},{170,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{150,-70},{130,-50}})));
  Modelica.Blocks.Sources.BooleanExpression uHea(y=time < 4000)
    "Heating enabled signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
    "Sum T and deltaT"
    annotation (Placement(transformation(extent={{-152,-70},{-132,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dTHeaWatRet(
    y(final unit="K", displayUnit="degC"),
    height=-20,
    duration=500,
    startTime=4500) "Heating water return additional deltaT"
    annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
  Modelica.Blocks.Sources.BooleanExpression uCoo(y=time >= 1000)
    "Cooling enabled signal"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
equation
  connect(TChiWatSupSet.y, chi.TChiWatSupPreSet) annotation (Line(points={{-98,
          0},{-32,0},{-32,-65},{-12,-65}}, color={0,0,127}));
  connect(THeaWatSupSet.y, chi.THeaWatSupSet) annotation (Line(points={{-98,40},
          {-28,40},{-28,-63},{-12,-63}}, color={0,0,127}));
  connect(chi.port_bHeaWat, senTHeaWatSup.port_a) annotation (Line(points={{-10,-56},
          {-40,-56},{-40,-40},{-70,-40}},      color={0,127,255}));
  connect(senTHeaWatSup.port_b, conWat.ports[1]) annotation (Line(points={{-90,-40},
          {-100,-40},{-100,-60}},      color={0,127,255}));
  connect(evaWat.ports[1], senTChiWatSup.port_b) annotation (Line(points={{100,
          -60},{100,-40},{80,-40}}, color={0,127,255}));
  connect(senTChiWatSup.port_a, chi.port_bChiWat) annotation (Line(points={{60,-40},
          {40,-40},{40,-56},{10,-56}},     color={0,127,255}));
  connect(conWat.ports[2], senTHeaWatRet.port_a) annotation (Line(points={{-100,
          -64},{-100,-80},{-90,-80}}, color={0,127,255}));
  connect(senTHeaWatRet.port_b, chi.port_aHeaWat) annotation (Line(points={{-70,-80},
          {-40,-80},{-40,-68},{-10,-68}},      color={0,127,255}));
  connect(chi.port_aChiWat, senTChiWatRet.port_b) annotation (Line(points={{10,-68},
          {40,-68},{40,-80},{60,-80}},      color={0,127,255}));
  connect(senTChiWatRet.port_a, evaWat.ports[2]) annotation (Line(points={{80,
          -80},{100,-80},{100,-64}}, color={0,127,255}));
  connect(mulSum.y, evaWat.T_in) annotation (Line(points={{128,-60},{126,-60},{
          126,-58},{122,-58}}, color={0,0,127}));
  connect(dTChiWatRet.y, mulSum.u[1]) annotation (Line(points={{168,-40},{160,
          -40},{160,-60},{156,-60},{156,-59},{152,-59}},
                                     color={0,0,127}));
  connect(TChiWatRet.y, mulSum.u[2]) annotation (Line(points={{168,-80},{160,
          -80},{160,-61},{152,-61}}, color={0,0,127}));
  connect(THeaWatRet.y, mulSum1.u[1]) annotation (Line(points={{-168,-80},{-160,
          -80},{-160,-59},{-154,-59}},
                            color={0,0,127}));
  connect(mulSum1.y, conWat.T_in) annotation (Line(points={{-130,-60},{-128,-60},
          {-128,-58},{-122,-58}}, color={0,0,127}));
  connect(dTHeaWatRet.y, mulSum1.u[2]) annotation (Line(points={{-168,-40},{
          -160,-40},{-160,-61},{-154,-61}}, color={0,0,127}));
  connect(uCoo.y, chi.uCoo) annotation (Line(points={{-99,80},{-24,80},{-24,-61},
          {-12,-61}}, color={255,0,255}));
  connect(uHea.y, chi.uHea) annotation (Line(points={{-99,100},{-20,100},{-20,-59},
          {-12,-59}},      color={255,0,255}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Subsystems/Validation/Chiller.mos"
"Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06),
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>"));
end Chiller;
