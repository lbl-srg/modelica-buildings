within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model Economizer "Validation model for WSE components"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Modelica.Units.SI.MassFlowRate mChiWatEco_flow_nominal=
    capEco_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TChiWatEcoEnt_nominal - TChiWatEcoLvg_nominal)
    "WSE CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatEco_flow_nominal=
    mChiWatEco_flow_nominal
    "WSE CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal=
    Buildings.Templates.Data.Defaults.dpChiWatEco
    "WSE CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatEco_nominal=
    Buildings.Templates.Data.Defaults.dpConWatEco
    "WSE CW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capEco_nominal(
    final min=0)=1e6
    "WSE cooling capacity (>0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TChiWatEcoEnt_nominal=
    Buildings.Templates.Data.Defaults.TChiWatEcoEnt
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TChiWatEcoLvg_nominal=
    Buildings.Templates.Data.Defaults.TChiWatEcoLvg
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TConWatEcoEnt_nominal=
    Buildings.Templates.Data.Defaults.TConWatEcoEnt
    "CHW supply temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Economizer datEcoVal(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve,
    final mChiWat_flow_nominal=mChiWatEco_flow_nominal,
    final mConWat_flow_nominal=mConWatEco_flow_nominal,
    final cap_nominal=capEco_nominal,
    final TChiWatEnt_nominal=TChiWatEcoEnt_nominal,
    final TConWatEnt_nominal=TConWatEcoEnt_nominal,
    final dpChiWat_nominal=dpChiWatEco_nominal,
    final dpConWat_nominal=dpConWatEco_nominal)
    "Parameters for WSE with valve";
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Economizer datEcoPum(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump,
    final mChiWat_flow_nominal=mChiWatEco_flow_nominal,
    final mConWat_flow_nominal=mConWatEco_flow_nominal,
    final cap_nominal=capEco_nominal,
    final TChiWatEnt_nominal=TChiWatEcoEnt_nominal,
    final TConWatEnt_nominal=TConWatEcoEnt_nominal,
    final dpChiWat_nominal=dpChiWatEco_nominal,
    final dpConWat_nominal=dpConWatEco_nominal)
    "Parameters for WSE with pump";

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yValChiWatEcoByp(table=[0,
        1; 1,1; 1.5,0; 2,0], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,270},{-230,290}})));
  Fluid.Sources.Boundary_pT bouChiWatRet(
    redeclare final package Medium = MediumChiWat,
    p=bouChiWatSup.p + ecoVal.dat.dpValChiWatByp_nominal,
    T=TChiWatEcoEnt_nominal,
    final nPorts=2) "CHW return boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,70})));
  Fluid.Sources.Boundary_pT bouChiWatSup(redeclare final package Medium =
        MediumChiWat, final nPorts=2) "CHW supply boundary condition"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,70})));
  Economizers.HeatExchangerWithValve ecoVal(
    show_T=true,
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datEcoVal) "WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Fluid.Sources.Boundary_pT bouConWatRet(
    redeclare final package Medium=MediumConWat,
    final nPorts=2)
    "CW return boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,210})));
  Fluid.Sources.Boundary_pT bouConWatSup(
    redeclare final package Medium = MediumChiWat,
    p=bouConWatRet.p + ecoVal.dat.dpValConWatIso_nominal,
    T=TConWatEcoEnt_nominal,
    final nPorts=2) "CW supply boundary condition" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,210})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus"
    annotation (Placement(transformation(extent={{-20,220},{20,260}}),
                                  iconTransformation(extent={{-316,184},{-276,
            224}})));
  Interfaces.Bus busPla "Plant control bus"
  annotation (Placement(
        transformation(extent={{-20,200},{20,240}}),iconTransformation(extent={{
            -432,12},{-412,32}})));
  Economizers.HeatExchangerWithPump  ecoPum(
    show_T=true,
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datEcoPum) "WSE with HX pump"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE CHW pump control bus" annotation (Placement(transformation(extent={{-20,
            100},{20,140}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatEco(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CHW pump start/stop signal"
    annotation (Placement(transformation(extent={{-250,310},{-230,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yPumChiWatEco(table=[0,
        0; 1,0; 1.5,1; 2,1], timeScale=1000) "WSE CHW pump speed signal"
    annotation (Placement(transformation(extent={{-250,350},{-230,370}})));
  Interfaces.Bus busPla1
                        "Plant control bus"
  annotation (Placement(
        transformation(extent={{-20,80},{20,120}}), iconTransformation(extent={{
            -432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso
    "WSE CW isolation valve control bus" annotation (Placement(transformation(
          extent={{20,220},{60,260}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso1
    "WSE CW isolation valve control bus" annotation (Placement(transformation(
          extent={{20,100},{60,140}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatEcoIso(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-250,390},{-230,410}})));
equation
  connect(bouChiWatRet.ports[1], ecoVal.port_a) annotation (Line(points={{-81,80},
          {-81,180},{-10,180}}, color={0,127,255}));
  connect(ecoVal.port_b, bouChiWatSup.ports[1])
    annotation (Line(points={{10,180},{79,180},{79,80}}, color={0,127,255}));
  connect(bouConWatSup.ports[1], ecoVal.port_aConWat)
    annotation (Line(points={{79,200},{79,189},{10,189}}, color={0,127,255}));
  connect(ecoVal.port_bConWat, bouConWatRet.ports[1]) annotation (Line(points={{
          -10,189},{-81,189},{-81,200}}, color={0,127,255}));
  connect(busPla, ecoVal.bus) annotation (Line(
      points={{0,220},{0,190}},
      color={255,204,51},
      thickness=0.5));
  connect(yValChiWatEcoByp.y[1], busValChiWatEcoByp.y)
    annotation (Line(points={{-228,280},{0,280},{0,240}}, color={0,0,127}));
  connect(bouConWatSup.ports[2], ecoPum.port_aConWat) annotation (Line(points={{
          81,200},{60,200},{60,89},{10,89}}, color={0,127,255}));
  connect(ecoPum.port_bConWat, bouConWatRet.ports[2]) annotation (Line(points={{
          -10,89},{-36,89},{-36,90},{-60,90},{-60,200},{-79,200}}, color={0,127,
          255}));
  connect(bouChiWatRet.ports[2], ecoPum.port_a)
    annotation (Line(points={{-79,80},{-10,80}}, color={0,127,255}));
  connect(y1PumChiWatEco.y[1], busPumChiWatEco.y1) annotation (Line(points={{-228,
          320},{-200,320},{-200,120},{0,120}}, color={255,0,255}));
  connect(yPumChiWatEco.y[1], busPumChiWatEco.y) annotation (Line(points={{-228,
          360},{-180,360},{-180,124},{0,124},{0,120}}, color={0,0,127}));
  connect(busPumChiWatEco, busPla1.pumChiWatEco) annotation (Line(
      points={{0,120},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, ecoPum.bus) annotation (Line(
      points={{0,100},{0,90}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatEcoIso, busPla.valConWatEcoIso) annotation (Line(
      points={{40,240},{40,220},{0,220}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatEcoIso1, busPla1.valConWatEcoIso) annotation (Line(
      points={{40,120},{40,100},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatEcoByp, busPla.valChiWatEcoByp) annotation (Line(
      points={{0,240},{0,220}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValConWatEcoIso.y[1], busValConWatEcoIso.y1) annotation (Line(
        points={{-228,400},{20,400},{20,240},{40,240}}, color={255,0,255}));
  connect(y1ValConWatEcoIso.y[1], busValConWatEcoIso1.y1) annotation (Line(
        points={{-228,400},{20,400},{20,120},{40,120}}, color={255,0,255}));
  connect(ecoPum.port_b, bouChiWatSup.ports[2])
    annotation (Line(points={{10,80},{81,80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-640},{260,440}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillersToPrimaryPumps.mos"
    "Simulate and plot"));
end Economizer;
