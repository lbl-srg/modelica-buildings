within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWater
  "Validation of AWHP plant template"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  parameter Boolean have_chiWat=true
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  inner parameter UserProject.Data.AllSystems datAll(
    pla(
      final cfg=pla.cfg))
    "Plant parameters"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-170,-40})));
  Fluid.HeatExchangers.SensibleCooler_T loaHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Fluid.HeatExchangers.Heater_T loaChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300)
    if have_chiWat
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(
    k=pla.THeaWatRet_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "Source signal for HW return temperature"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(
    k=pla.TChiWatRet_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "Source signal for CHW return temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valDisHeaWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=max(datAll.pla.pumHeaWatSec.dp_nominal) - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valDisChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=max(datAll.pla.pumChiWatSec.dp_nominal) - 3E4)
    if have_chiWat
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Templates.Plants.HeatPumps.AirToWater pla(
    redeclare final package MediumHeaWat=Medium,
    final dat=datAll.pla,
    final have_chiWat=have_chiWat,
    nHp=3,
    typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typPumHeaWatPri_select1=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
    have_pumChiWatPriDed_select=false,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    show_T=true,
    ctl(
      nAirHan=1,
      nEquZon=0,
      have_senVHeaWatPri_select=false,
      have_senVChiWatPri_select=false,
      have_senTHeaWatPriRet_select=true,
      have_senTChiWatPriRet_select=true,
      have_senTHeaWatSecRet=true,
      have_senTChiWatSecRet=true,
      have_senDpHeaWatRemWir=true))
    "Heat pump plant"
    annotation (Placement(transformation(extent={{-80,-100},{-40,-60}})));
  // FIXME: Prototype implementation for calculating pump speed to meet design flow.
  parameter Real r_N[pla.nPumHeaWatPri](
    each unit="1",
    each start=1,
    each fixed=false)
    "Relative revolution, r_N=N/N_nominal";
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Fluid.Sensors.RelativePressure                              dpHeaWatRem_1(
    redeclare final package Medium = Medium)
                      "HW differential pressure at one remote location"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-120})));
  Fluid.Sensors.RelativePressure                              dpChiWatRem_1(
    redeclare final package Medium = Medium)
                      "CHW differential pressure at one remote location"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-60})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(heaCoi=
        Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased, cooCoi=
        Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{10,110},{-10,130}})));
  AirHandlersFans.Interfaces.Bus busAirHan "AHU control bus" annotation (
      Placement(transformation(extent={{-60,100},{-20,140}}),
                                                           iconTransformation(
          extent={{-340,-140},{-300,-100}})));
  Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{-100,-40},{-60,0}}),  iconTransformation(extent
          ={{-370,-70},{-330,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter dpChiWatRem(nin=pla.cfg.nSenDpChiWatRem,
      nout=pla.cfg.nSenDpChiWatRem)
    "Gather all remote CHW differential pressure signals"
    annotation (Placement(transformation(extent={{-10,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter dpHeaWatRem(nin=pla.cfg.nSenDpHeaWatRem,
      nout=pla.cfg.nSenDpHeaWatRem)
    "Gather all remote HW differential pressure signals"
    annotation (Placement(transformation(extent={{-10,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 5,0,0;
        6,1,0; 12,0.2,0.2; 15,0,1; 22,0.1,0.1; 24,0,0], timeScale=3600)
    "Source signal for flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.5,
    each Ti=60,                                                 each final
      reverseActing=true)
    "Zone equipment controller"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[2](k=fill(1, 2) ./
        {pla.mHeaWat_flow_nominal,pla.mChiWat_flow_nominal})
                                   "Normalize flow rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,0})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
   redeclare final package Medium = Medium) "CHW mass flow rate"
                        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-60})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(redeclare final package Medium =
        Medium) "HW mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-120})));
initial equation
  fill(0, pla.nPumHeaWatPri)=Buildings.Templates.Utilities.computeBalancingPressureDrop(
    m_flow_nominal=fill(datAll.pla.hp.mHeaWatHp_flow_nominal, pla.nHp),
    dp_nominal=pla.pumPri.dpValCheHeaWat_nominal .+ fill(datAll.pla.hp.dpHeaWatHp_nominal, pla.nHp) .+
      fill(Buildings.Templates.Data.Defaults.dpValIso, pla.nHp),
    datPum=datAll.pla.pumHeaWatPriSin,
    r_N=r_N);
equation
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-160,-40},{-60,-40},{-60,-60}},
                                                           color={255,204,51},thickness=0.5));
  connect(THeaWatRet.y, loaHeaWat.TSet)
    annotation (Line(points={{-158,0},{60,0},{60,-92},{68,-92}},   color={0,0,127}));
  connect(pla.port_bChiWat, loaChiWat.port_a)
    annotation (Line(points={{-40,-76},{-20,-76},{-20,-40},{70,-40}},
                                                             color={0,127,255}));
  connect(loaChiWat.port_b, valDisChiWat.port_a)
    annotation (Line(points={{90,-40},{110,-40}},
                                            color={0,127,255}));
  connect(loaHeaWat.port_b, valDisHeaWat.port_a)
    annotation (Line(points={{90,-100},{110,-100}},
                                                color={0,127,255}));
  connect(pla.port_bHeaWat, loaHeaWat.port_a)
    annotation (Line(points={{-40,-90},{-20,-90},{-20,-100},{70,-100}},
                                                                 color={0,127,255}));
  connect(TChiWatRet.y, loaChiWat.TSet)
    annotation (Line(points={{-158,40},{62,40},{62,-32},{68,-32}},
                                                             color={0,0,127}));
  connect(loaChiWat.port_a, dpChiWatRem_1.port_a)
    annotation (Line(points={{70,-40},{40,-40},{40,-50}}, color={0,127,255}));
  connect(dpHeaWatRem_1.port_a, loaHeaWat.port_a) annotation (Line(points={{40,-110},
          {40,-100},{70,-100}}, color={0,127,255}));
  connect(TDum.y, reqPlaRes.TAirSup) annotation (Line(points={{-158,140},{20,140},
          {20,128},{12,128}},      color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet) annotation (Line(points={{-158,140},{20,
          140},{20,123},{12,123}}, color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1]) annotation (Line(
      points={{-40,120},{-40,-62}},
      color={255,204,51},
      thickness=0.5));
  connect(reqPlaRes.yChiWatResReq, busAirHan.reqResChiWat) annotation (Line(
        points={{-12,128},{-20,128},{-20,120},{-40,120}}, color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, busAirHan.reqPlaChiWat) annotation (Line(points={{-12,123},
          {-20,123},{-20,120},{-40,120}},           color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, busAirHan.reqResHeaWat) annotation (Line(
        points={{-12,117},{-20,117},{-20,120},{-40,120}},
                                                        color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, busAirHan.reqPlaHeaWat) annotation (Line(
        points={{-12,112},{-20,112},{-20,120},{-40,120}},
                                                        color={255,127,0}));
  connect(pla.bus, busPla) annotation (Line(
      points={{-80,-62},{-80,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(dpHeaWatRem.y, busPla.dpHeaWatRem)
    annotation (Line(points={{-32,-20},{-80,-20}}, color={0,0,127}));
  connect(dpChiWatRem.y, busPla.dpChiWatRem)
    annotation (Line(points={{-32,20},{-80,20},{-80,-20}}, color={0,0,127}));
  connect(valDisChiWat.y_actual, reqPlaRes.uCooCoiSet) annotation (Line(points={{125,-33},
          {140,-33},{140,117},{12,117}},          color={0,0,127}));
  connect(valDisHeaWat.y_actual, reqPlaRes.uHeaCoiSet) annotation (Line(points={{125,-93},
          {136,-93},{136,112},{12,112}},          color={0,0,127}));
  connect(dpHeaWatRem_1.p_rel, dpHeaWatRem.u[1]) annotation (Line(points={{31,-120},
          {0,-120},{0,-20},{-8,-20}}, color={0,0,127}));
  connect(dpChiWatRem_1.p_rel, dpChiWatRem.u[1]) annotation (Line(points={{31,-60},
          {2,-60},{2,20},{-8,20}}, color={0,0,127}));
  connect(valDisChiWat.port_b, mChiWat_flow.port_a) annotation (Line(points={{130,
          -40},{160,-40},{160,-50}}, color={0,127,255}));
  connect(mChiWat_flow.port_b, pla.port_aChiWat) annotation (Line(points={{160,-70},
          {160,-80},{-20,-80},{-20,-84},{-40,-84}}, color={0,127,255}));
  connect(mChiWat_flow.port_b, dpChiWatRem_1.port_b) annotation (Line(points={{160,
          -70},{160,-80},{40,-80},{40,-70}}, color={0,127,255}));
  connect(valDisHeaWat.port_b, mHeaWat_flow.port_a) annotation (Line(points={{130,
          -100},{160,-100},{160,-110}}, color={0,127,255}));
  connect(mHeaWat_flow.port_b, pla.port_aHeaWat) annotation (Line(points={{160,-130},
          {160,-140},{-30,-140},{-30,-98},{-40,-98}}, color={0,127,255}));
  connect(mHeaWat_flow.port_b, dpHeaWatRem_1.port_b) annotation (Line(points={{160,
          -130},{160,-140},{40,-140},{40,-130}}, color={0,127,255}));
  connect(mHeaWat_flow.m_flow, norFlo[1].u) annotation (Line(points={{171,-120},
          {180,-120},{180,-12}}, color={0,0,127}));
  connect(mChiWat_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{171,-60},{180,-60},{180,-12}}, color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m) annotation (Line(points={{180,12},{180,60},{80,
          60},{80,68}}, color={0,0,127}));
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-158,80},{68,80}}, color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChiWat.y) annotation (Line(points={{92,80},{100,
          80},{100,-20},{120,-20},{120,-28}}, color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHeaWat.y) annotation (Line(points={{92,80},{100,
          80},{100,-84},{120,-84},{120,-88}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
Buildings.Templates.Plants.HeatPumps.AirToWater</a>
by simulating four periods of one hour.
The load profile is characterized by
high cooling loads and low heating loads in the first period,
concomitant high cooling and heating loads in the second period,
low cooling loads and high heating loads in the third period,
and no cooling loads (cooling disabled) and high heating loads 
in the last period. 
</p>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})));
end AirToWater;
