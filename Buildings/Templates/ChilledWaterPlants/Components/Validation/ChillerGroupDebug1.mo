within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model ChillerGroupDebug1 "Validation model for chiller group"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";
  replaceable package MediumAir = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Integer nChi=3
    "Number of chillers";

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    capChi_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TChiWatRet_nominal-TChiWatSup_nominal)
    "CHW mass flow rate for each chiller"
    annotation (Evaluate=true, Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=
    sum(mChiWatChi_flow_nominal)
    "Primary CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi]=
    capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo)/
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TConWatRet_nominal-TConWatSup_nominal)
    "CW mass flow rate for each water-cooled chiller"
    annotation (Evaluate=true,Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConAirChi_flow_nominal[nChi]=
    capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiAirCoo)*
    Buildings.Templates.Data.Defaults.mConAirByCap
    "Air mass flow rate at condenser for each air-cooled chiller"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal=
    sum(mConWatChi_flow_nominal)
    "CW mass flow rate (total)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpChiWatChi, nChi)
    "CHW pressure drop for each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpConWatChi, nChi)
    "WSE CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Cooling capacity for each chiller (>0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    Buildings.Templates.Data.Defaults.TChiWatSup
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature";
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal=
    Buildings.Templates.Data.Defaults.TConWatSup
    "CW supply temperature";
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal=
    Buildings.Templates.Data.Defaults.TConWatRet
    "CW return temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dp_nominal=1.5*dpChiWatChi_nominal)
    "Parameter record for primary CHW pumps";
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumConWat(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
    dp_nominal=1.5*dpConWatChi_nominal)
    "Parameter record for CW pumps";
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup datChiWatCoo(
    final nChi=nChi,
    final typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mConFluChi_flow_nominal=mConWatChi_flow_nominal,
    final dpChiWatChi_nominal=dpChiWatChi_nominal,
    final dpConFluChi_nominal=dpConWatChi_nominal,
    final capChi_nominal=capChi_nominal,
    final TChiWatChiSup_nominal=fill(TChiWatSup_nominal, nChi),
    PLRChi_min=fill(0.15, nChi),
    redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD per)
    "Parameter record for water-cooled chiller group";

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0,0; 1.2,0; 1.2,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "Chiller, CW pumps and primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,310},{-230,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWat(
    final k=TConWatSup_nominal) "CW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,390},{-230,410}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yValIso[nChi](each
      table=[0,0; 1,0; 1.5,1; 2,1],
    each timeScale=1000)
    "Chiller CW or CHW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-250,270},{-230,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](final k=
        fill(TChiWatSup_nominal, nChi)) "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-180,390},{-160,410}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{30,-150},{10,-130}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(redeclare final package
      Medium = MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(redeclare final package Medium =
        MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Fluid.Sources.Boundary_pT bouChiWat1(redeclare final package Medium =
        MediumChiWat, final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-160})));
  Fluid.Sources.PropertySource_T tow1(redeclare final package Medium =
        MediumConWat, final use_T_in=true)
    "Ideal cooling to input set point (representing cooling tower)"
    annotation (Placement(transformation(extent={{-206,-150},{-186,-130}})));
  ChillerGroups.Compression chi1(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumCon = MediumConWat,
    final dat=datChiWatCoo,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    typCtrHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External,
    typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    typArrPumConWat=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    typCtrSpePumConWat=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Chiller group"
    annotation (Placement(transformation(extent={{-100,-170},{-60,-50}})));

  Buildings.Templates.Components.Pumps.Multiple pumConWat1(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "CW pumps"
    annotation (Placement(transformation(extent={{-150,-150},{-130,-130}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat1(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-170,-150},{-150,-130}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi1(
    redeclare final package Medium = MediumConWat,
    final nPorts=nChi,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi1(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));
  Fluid.Sources.Boundary_pT bouCon1(redeclare final package Medium =
        MediumConWat, nPorts=1) "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-180,-170})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri1(
    redeclare final package Medium = MediumChiWat,
    nPorts_a=nChi,
    have_comLeg=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat1(
    redeclare final package Medium = MediumConWat,
    nPorts_a=nChi,
    have_comLeg=true,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla1
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat1
    "CW pumps control bus" annotation (Placement(transformation(extent={{180,
            -100},{220,-60}}),
                         iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busChi1[nChi]
    "Chiller control bus" annotation (Placement(transformation(extent={{180,-40},
            {220,0}}),   iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    "Chiller CW isolation valves control bus" annotation (Placement(
        transformation(extent={{220,-40},{260,0}}),  iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    "Chiller CHW isolation valves control bus" annotation (Placement(
        transformation(extent={{120,-40},{160,0}}),  iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-80})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa1(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-110})));
equation
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{-20,-80},{-20,-80}},
                                                 color={0,127,255}));
  connect(y1Chi.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,320},
          {160,320},{160,-56},{200,-56},{200,-60}},
                                                color={255,0,255}));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,-60},{-30,-60},{-30,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{0,-80},{20,-80}},
                                              color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{40,-80},{50,-80}},
                                               color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{30,-140},
          {80,-140},{80,-80},{70,-80}},
                                     color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b)
    annotation (Line(points={{0,-150},{0,-140},{10,-140}},
                                                        color={0,127,255}));
  connect(TConWat.y, tow1.T_in) annotation (Line(points={{-228,400},{-200,400},{
          -200,380},{-260,380},{-260,-120},{-200,-120},{-200,-128}},
                     color={0,0,127}));
  connect(tow1.port_b, inlPumConWat1.port_a)
    annotation (Line(points={{-186,-140},{-170,-140}},
                                                     color={0,127,255}));
  connect(pumConWat1.ports_a, inlPumConWat1.ports_b)
    annotation (Line(points={{-150,-140},{-150,-140}},
                                                     color={0,127,255}));
  connect(chi1.ports_bCon, outConWatChi1.ports_b)
    annotation (Line(points={{-100,-80},{-130,-80}},
                                                   color={0,127,255}));
  connect(outConWatChi1.port_a, tow1.port_a) annotation (Line(points={{-150,-80},
          {-220,-80},{-220,-140},{-206,-140}},
                                            color={0,127,255}));
  connect(loa1.port_b, inlChiWatChi1.port_b)
    annotation (Line(points={{10,-140},{-30,-140}},
                                                  color={0,127,255}));
  connect(inlChiWatChi1.ports_a, chi1.ports_aChiWat)
    annotation (Line(points={{-50,-140},{-60,-140}},
                                                   color={0,127,255}));
  connect(chi1.ports_bChiWat, inlPumChiWatPri1.ports_a)
    annotation (Line(points={{-60,-80},{-60,-80}},
                                                 color={0,127,255}));
  connect(inlPumChiWatPri1.ports_b, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40,-80},{-40,-80}},
                                                 color={0,127,255}));
  connect(pumConWat1.ports_b, outPumConWat1.ports_a)
    annotation (Line(points={{-130,-140},{-130,-140}},
                                                     color={0,127,255}));
  connect(outPumConWat1.ports_b, chi1.ports_aCon)
    annotation (Line(points={{-110,-140},{-100,-140}},
                                                     color={0,127,255}));
  connect(tow1.port_b, bouCon1.ports[1]) annotation (Line(points={{-186,-140},{
          -180,-140},{-180,-160}},
                            color={0,127,255}));
  connect(y1Chi.y[1], busPumConWat1.y1) annotation (Line(points={{-228,320},{
          160,320},{160,-80},{200,-80}},
                                   color={255,0,255}));
  connect(busPumConWat1, pumConWat1.bus) annotation (Line(
      points={{200,-80},{200,-120},{-140,-120},{-140,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, chi1.bus) annotation (Line(
      points={{200,-40},{-80,-40},{-80,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Chi.y[1], busChi1.y1) annotation (Line(points={{-228,320},{160,320},
          {160,-20},{200,-20}}, color={255,0,255}));
  connect(TChiWat.y, busChi1.TChiWatSupSet) annotation (Line(points={{-158,400},
          {166,400},{166,-16},{200,-16},{200,-20}}, color={0,0,127}));
  connect(yValIso.y[1], busValChiWatChiIso.y) annotation (Line(points={{-228,280},
          {120,280},{120,-20},{140,-20}},
                                color={0,0,127}));
  connect(yValIso.y[1], busValConWatChiIso.y) annotation (Line(points={{-228,280},
          {120,280},{120,0},{240,0},{240,-20}},     color={0,0,127}));
  connect(busValChiWatChiIso, busPla1.valChiWatChiIso) annotation (Line(
      points={{140,-20},{140,-36},{200,-36},{200,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatChiIso, busPla1.valConWatChiIso) annotation (Line(
      points={{240,-20},{240,-40},{200,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea1.y, comSigLoa1.u)
    annotation (Line(points={{240,-92},{240,-98}},
                                                 color={0,0,127}));
  connect(comSigLoa1.y, loa1.u)
    annotation (Line(points={{240,-122},{240,-134},{32,-134}},
                                                           color={0,0,127}));
  connect(busChi1.y1_actual, booToRea1.u) annotation (Line(
      points={{200,-20},{220,-20},{220,-60},{240,-60},{240,-68}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi1, busPla1.chi) annotation (Line(
      points={{200,-20},{200,-40}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-280,-200},{280,440}}),
        graphics={Rectangle(
          extent={{-240,262},{260,38}},
          lineColor={255,255,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-240,100},{260,18}},
          textColor={255,255,255},
          textString="ChillerGroupDebug1 is built by removing the components inside the colored rectangle.")}),
  experiment(
    StopTime=2000,
    Tolerance=1e-06));
end ChillerGroupDebug1;
