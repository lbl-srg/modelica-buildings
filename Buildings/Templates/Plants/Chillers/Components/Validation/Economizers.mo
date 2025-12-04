within Buildings.Templates.Plants.Chillers.Components.Validation;
model Economizers "Validation model for waterside economizers"
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
    "WSE entering CHW temperature";
  parameter Modelica.Units.SI.Temperature TChiWatEcoLvg_nominal=
    Buildings.Templates.Data.Defaults.TChiWatEcoLvg
    "WSE leaving CHW temperature";
  parameter Modelica.Units.SI.Temperature TConWatEcoEnt_nominal=
    Buildings.Templates.Data.Defaults.TConWatEcoEnt
    "WSE entering CW temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.Economizer datEcoVal(
    final typ=Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve,
    final mChiWat_flow_nominal=mChiWatEco_flow_nominal,
    final mConWat_flow_nominal=mConWatEco_flow_nominal,
    final cap_nominal=capEco_nominal,
    final TChiWatEnt_nominal=TChiWatEcoEnt_nominal,
    final TConWatEnt_nominal=TConWatEcoEnt_nominal,
    final dpChiWat_nominal=dpChiWatEco_nominal,
    final dpConWat_nominal=dpConWatEco_nominal)
    "Parameters for WSE with valve";
  parameter Buildings.Templates.Plants.Chillers.Components.Data.Economizer datEcoPum(
    final typ=Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump,
    final mChiWat_flow_nominal=mChiWatEco_flow_nominal,
    final mConWat_flow_nominal=mConWatEco_flow_nominal,
    final cap_nominal=capEco_nominal,
    final TChiWatEnt_nominal=TChiWatEcoEnt_nominal,
    final TConWatEnt_nominal=TConWatEcoEnt_nominal,
    final dpChiWat_nominal=dpChiWatEco_nominal,
    final dpConWat_nominal=dpConWatEco_nominal)
    "Parameters for WSE with pump";

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable yValChiWatEcoByp(table=[0,
        1; 1,1; 1.5,0; 2,0], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Fluid.Sources.Boundary_pT bouChiWatSup(redeclare final package Medium =
        MediumChiWat, final nPorts=2) "CHW supply boundary condition"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,-90})));
  .Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve
    ecoVal(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datEcoVal,
    hex(show_T=true),
    final energyDynamics=energyDynamics,
    final tau=tau)
    "WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-40,10},{40,30}})));
  Fluid.Sources.Boundary_pT bouConWatRet(
    redeclare final package Medium=MediumConWat,
    final nPorts=2)
    "CW return boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,60})));
  Fluid.Sources.Boundary_pT bouConWatSup(
    redeclare final package Medium = MediumChiWat,
    p=bouConWatRet.p + dpConWatEco_nominal,
    T=TConWatEcoEnt_nominal,
    final nPorts=2) "CW supply boundary condition" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,50})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
                                  iconTransformation(extent={{-316,184},{-276,
            224}})));
  .Buildings.Templates.Plants.Chillers.Interfaces.Bus busPla
    "Plant control bus" annotation (Placement(transformation(extent={{-20,40},{
            20,80}}), iconTransformation(extent={{-432,12},{-412,32}})));
  .Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump
    ecoPum(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datEcoPum,
    hex(show_T=true),
    final energyDynamics=energyDynamics,
    final tau=tau) "WSE with HX pump"
    annotation (Placement(transformation(extent={{-40,-90},{40,-70}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE CHW pump control bus" annotation (Placement(transformation(extent={{-20,-40},
            {20,0}}),        iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatEco(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CHW pump Start/Stop signal"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable yPumChiWatEco(table=[0,
        0; 1,0; 1.5,1; 2,1], timeScale=1000) "WSE CHW pump speed signal"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  .Buildings.Templates.Plants.Chillers.Interfaces.Bus busPla1
    "Plant control bus" annotation (Placement(transformation(extent={{-20,-80},
            {20,-40}}), iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso
    "WSE CW isolation valve control bus" annotation (Placement(transformation(
          extent={{20,60},{60,100}}),  iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso1
    "WSE CW isolation valve control bus" annotation (Placement(transformation(
          extent={{20,-60},{60,-20}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValConWatEcoIso(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000) "WSE CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Fluid.Sources.MassFlowSource_T bouChiWatRet1(
    redeclare final package Medium = MediumChiWat,
    m_flow=mChiWatEco_flow_nominal,
    T=TChiWatEcoEnt_nominal,
    final nPorts=1) "CHW return boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,-80})));
  Fluid.Sources.MassFlowSource_T bouChiWatRet(
    redeclare final package Medium = MediumChiWat,
    m_flow=mChiWatEco_flow_nominal,
    T=TChiWatEcoEnt_nominal,
    final nPorts=1) "CHW return boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,20})));
equation
  connect(ecoVal.port_b, bouChiWatSup.ports[1])
    annotation (Line(points={{10,20},{80,20},{80,-80},{79,-80}},
                                                         color={0,127,255}));
  connect(bouConWatSup.ports[1], ecoVal.port_aConWat)
    annotation (Line(points={{79,40},{-40,40},{-40,28}},  color={0,127,255}));
  connect(ecoVal.port_bConWat, bouConWatRet.ports[1]) annotation (Line(points={{-40,12},
          {-61,12},{-61,50}},            color={0,127,255}));
  connect(busPla, ecoVal.bus) annotation (Line(
      points={{0,60},{0,30}},
      color={255,204,51},
      thickness=0.5));
  connect(yValChiWatEcoByp.y[1], busValChiWatEcoByp.y)
    annotation (Line(points={{-108,0},{-100,0},{-100,76},{0,76},{0,100}},
                                                          color={0,0,127}));
  connect(bouConWatSup.ports[2], ecoPum.port_aConWat) annotation (Line(points={{81,40},
          {60,40},{60,-50},{-40,-50},{-40,-72}},
                                             color={0,127,255}));
  connect(ecoPum.port_bConWat, bouConWatRet.ports[2]) annotation (Line(points={{-40,-88},
          {-60,-88},{-60,50},{-59,50}},                            color={0,127,
          255}));
  connect(y1PumChiWatEco.y[1], busPumChiWatEco.y1) annotation (Line(points={{-108,40},
          {-50,40},{-50,-20},{0,-20}},         color={255,0,255}));
  connect(yPumChiWatEco.y[1], busPumChiWatEco.y) annotation (Line(points={{-108,
          -40},{0,-40},{0,-20}},                       color={0,0,127}));
  connect(busPumChiWatEco, busPla1.pumChiWatEco) annotation (Line(
      points={{0,-20},{0,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, ecoPum.bus) annotation (Line(
      points={{0,-60},{0,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatEcoIso, busPla.valConWatEcoIso) annotation (Line(
      points={{40,80},{40,60},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatEcoIso1, busPla1.valConWatEcoIso) annotation (Line(
      points={{40,-40},{40,-60},{0,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatEcoByp, busPla.valChiWatEcoByp) annotation (Line(
      points={{0,100},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValConWatEcoIso.y[1], busValConWatEcoIso.y1) annotation (Line(
        points={{-108,120},{100,120},{100,80},{40,80}}, color={255,0,255}));
  connect(y1ValConWatEcoIso.y[1], busValConWatEcoIso1.y1) annotation (Line(
        points={{-108,120},{100,120},{100,-40},{40,-40}},
                                                        color={255,0,255}));
  connect(ecoPum.port_b, bouChiWatSup.ports[2])
    annotation (Line(points={{10,-80},{81,-80}},
                                               color={0,127,255}));
  connect(bouChiWatRet1.ports[1], ecoPum.port_a) annotation (Line(points={{-70,-80},
          {-10,-80}},                color={0,127,255}));
  connect(bouChiWatRet.ports[1], ecoVal.port_a)
    annotation (Line(points={{-70,20},{-10,20}},          color={0,127,255}));
  annotation (
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Components/Validation/Economizers.mos"
    "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-140,-140},{120,140}})),
    Documentation(info="<html>
<p>
This model validates the waterside economizer models
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump\">
Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump</a>
and
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve\">
Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve</a>
using open-loop controls.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Economizers;
