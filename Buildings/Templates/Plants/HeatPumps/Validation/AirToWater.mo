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
    pla(final cfg=pla.cfg))
    "Plant parameters"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
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
    tau=300,
    QMin_flow=-pla.capHea_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Fluid.HeatExchangers.Heater_T loaChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=pla.capCoo_nominal)
    if have_chiWat
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage     valDisHeaWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=datAll.pla.ctl.dpHeaWatRemSet_max[1] - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage     valDisChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=datAll.pla.ctl.dpChiWatRemSet_max[1] - 3E4)
    if have_chiWat
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Templates.Plants.HeatPumps.AirToWater pla(
    redeclare final package MediumHeaWat=Medium,
    final dat=datAll.pla,
    final have_chiWat=have_chiWat,
    nHp=3,
    typPumHeaWatPri_select2=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
    typPumChiWatPri_select1=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    show_T=true,
    ctl(
      nAirHan=1,
      nEquZon=0,
      have_senVHeaWatPri_select=true,
      have_senVChiWatPri_select=true,
      have_senTHeaWatPriRet_select=true,
      have_senTChiWatPriRet_select=true,
      have_senTHeaWatSecRet=true,
      have_senTChiWatSecRet=true,
      have_senDpHeaWatRemWir=true))
    "Heat pump plant"
    annotation (Placement(transformation(extent={{-80,-100},{-40,-60}})));
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
    redeclare final package Medium = Medium) if have_chiWat
                      "CHW differential pressure at one remote location"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-60})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased, final
      cooCoi=if have_chiWat then Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
         else Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{90,102},{70,122}})));
  AirHandlersFans.Interfaces.Bus busAirHan "AHU control bus" annotation (
      Placement(transformation(extent={{-60,100},{-20,140}}),
                                                           iconTransformation(
          extent={{-340,-140},{-300,-100}})));
  Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{-100,-40},{-60,0}}),  iconTransformation(extent
          ={{-370,-70},{-330,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter dpChiWatRem(nin=pla.cfg.nSenDpChiWatRem,
      nout=pla.cfg.nSenDpChiWatRem) if have_chiWat
    "Gather all remote CHW differential pressure signals"
    annotation (Placement(transformation(extent={{10,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter dpHeaWatRem(nin=pla.cfg.nSenDpHeaWatRem,
      nout=pla.cfg.nSenDpHeaWatRem)
    "Gather all remote HW differential pressure signals"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 5,0,0;
        7,1,0; 12,0.2,0.2; 16,0,1; 22,0.1,0.1; 24,0,0], timeScale=3600)
    "Source signal for flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[if have_chiWat then 2 else 1](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[if have_chiWat
     then 2 else 1](k=if have_chiWat then {1/pla.mHeaWat_flow_nominal,1/pla.mChiWat_flow_nominal}
         else {1/pla.mHeaWat_flow_nominal}) "Normalize flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,0})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
   redeclare final package Medium = Medium) if have_chiWat
                                            "CHW mass flow rate"
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
  Buildings.Controls.OBC.CDL.Reals.AddParameter TChiWatRet(p=pla.TChiWatRet_nominal
         - pla.TChiWatSup_nominal) if have_chiWat
                                   "Prescribed CHW return temperature"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THeaWatRet(p=pla.THeaWatRet_nominal
         - pla.THeaWatSup_nominal) "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2 "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1 if have_chiWat
                                            "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[4]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{0,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](each k=10)
    "Constant"
    annotation (Placement(transformation(extent={{40,150},{20,170}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium =Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    final dp_nominal=max(
      max(datAll.pla.pumHeaWatPri.dp_nominal),
      max(datAll.pla.pumHeaWatSec.dp_nominal)) - datAll.pla.ctl.dpHeaWatRemSet_max[1])
    "Piping"
    annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium =Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    final dp_nominal=max(
      max(datAll.pla.pumChiWatPri.dp_nominal),
      max(datAll.pla.pumChiWatSec.dp_nominal)) - datAll.pla.ctl.dpChiWatRemSet_max[1])
    if have_chiWat
    "Piping"
    annotation (Placement(transformation(extent={{10,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=293.15)
    "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Controls.Utilities.PlaceholderInteger ph[2](each final have_inp=have_chiWat,
      each final u_internal=0) "Placeholder value"
    annotation (Placement(transformation(extent={{40,114},{20,134}})));
equation
  if have_chiWat then
    connect(mulInt[3].y, busAirHan.reqResChiWat)
      annotation (Line(points={{-22,120},{-40,120}}, color={255,127,0}));
    connect(mulInt[4].y, busAirHan.reqPlaChiWat)
      annotation (Line(points={{-22,120},{-40,120}}, color={255,127,0}));
  end if;
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-160,-40},{-60,-40},{-60,-60}},
                                                           color={255,204,51},thickness=0.5));
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
  connect(loaChiWat.port_a, dpChiWatRem_1.port_a)
    annotation (Line(points={{70,-40},{40,-40},{40,-50}}, color={0,127,255}));
  connect(dpHeaWatRem_1.port_a, loaHeaWat.port_a) annotation (Line(points={{40,-110},
          {40,-100},{70,-100}}, color={0,127,255}));
  connect(TDum.y, reqPlaRes.TAirSup) annotation (Line(points={{-158,140},{100,
          140},{100,120},{92,120}},color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet) annotation (Line(points={{-158,140},{
          100,140},{100,115},{92,115}},
                                   color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1]) annotation (Line(
      points={{-40,120},{-40,-62}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.bus, busPla) annotation (Line(
      points={{-80,-62},{-80,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(dpHeaWatRem.y, busPla.dpHeaWatRem)
    annotation (Line(points={{-12,-20},{-80,-20}}, color={0,0,127}));
  connect(dpChiWatRem.y, busPla.dpChiWatRem)
    annotation (Line(points={{-12,20},{-20,20},{-20,-18},{-80,-18},{-80,-20}},
                                                           color={0,0,127}));
  connect(valDisChiWat.y_actual, reqPlaRes.uCooCoiSet) annotation (Line(points={{125,-33},
          {140,-33},{140,109},{92,109}},          color={0,0,127}));
  connect(valDisHeaWat.y_actual, reqPlaRes.uHeaCoiSet) annotation (Line(points={{125,-93},
          {136,-93},{136,104},{92,104}},          color={0,0,127}));
  connect(dpHeaWatRem_1.p_rel, dpHeaWatRem.u[1]) annotation (Line(points={{31,-120},
          {20,-120},{20,-20},{12,-20}},
                                      color={0,0,127}));
  connect(dpChiWatRem_1.p_rel, dpChiWatRem.u[1]) annotation (Line(points={{31,-60},
          {22,-60},{22,20},{12,20}},
                                   color={0,0,127}));
  connect(valDisChiWat.port_b, mChiWat_flow.port_a) annotation (Line(points={{130,-40},
          {160,-40},{160,-50}},      color={0,127,255}));
  connect(mChiWat_flow.port_b, dpChiWatRem_1.port_b) annotation (Line(points={{160,
          -70},{160,-80},{40,-80},{40,-70}}, color={0,127,255}));
  connect(valDisHeaWat.port_b, mHeaWat_flow.port_a) annotation (Line(points={{130,
          -100},{160,-100},{160,-110}}, color={0,127,255}));
  connect(mHeaWat_flow.port_b, dpHeaWatRem_1.port_b) annotation (Line(points={{160,
          -130},{160,-140},{40,-140},{40,-130}}, color={0,127,255}));
  connect(mHeaWat_flow.m_flow, norFlo[1].u) annotation (Line(points={{171,-120},
          {180,-120},{180,-12}}, color={0,0,127}));
  connect(mChiWat_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{171,-60},{180,-60},{180,-12}}, color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m) annotation (Line(points={{180,12},{180,60},{80,
          60},{80,68}}, color={0,0,127}));
  connect(ratFlo.y[1:(if have_chiWat then 2 else 1)], ctlEquZon.u_s)
    annotation (Line(points={{-158,80},{68,80}}, color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChiWat.y) annotation (Line(points={{92,80},{100,
          80},{100,-20},{120,-20},{120,-28}}, color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHeaWat.y) annotation (Line(points={{92,80},{100,
          80},{100,-84},{120,-84},{120,-88}}, color={0,0,127}));
  connect(busPla.THeaWatPriSup, THeaWatRet.u) annotation (Line(
      points={{-80,-20},{-140,-20},{-140,0},{-132,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.TChiWatPriSup, TChiWatRet.u) annotation (Line(
      points={{-80,-20},{-140,-20},{-140,40},{-132,40}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWatRet.y,min1. u1) annotation (Line(points={{-108,40},{-100,40},{-100,
          46},{-92,46}}, color={0,0,127}));
  connect(min1.y, loaChiWat.TSet) annotation (Line(points={{-68,40},{62,40},{62,
          -32},{68,-32}}, color={0,0,127}));
  connect(max2.y, loaHeaWat.TSet) annotation (Line(points={{-68,0},{60,0},{60,-92},
          {68,-92}}, color={0,0,127}));
  connect(cst.y, mulInt.u1) annotation (Line(points={{18,160},{6,160},{6,126},{2,
          126}}, color={255,127,0}));
  connect(mulInt[1].y, busAirHan.reqResHeaWat) annotation (Line(points={{-22,120},
          {-30,120},{-30,120},{-40,120}}, color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaHeaWat)
    annotation (Line(points={{-22,120},{-40,120}}, color={255,127,0}));
  connect(pipHeaWat.port_b, pla.port_aHeaWat) annotation (Line(points={{-10,-140},
          {-30,-140},{-30,-98},{-40,-98}}, color={0,127,255}));
  connect(pipChiWat.port_b, pla.port_aChiWat) annotation (Line(points={{-10,-80},
          {-20,-80},{-20,-84},{-40,-84}}, color={0,127,255}));
  connect(mChiWat_flow.port_b, pipChiWat.port_a) annotation (Line(points={{160,-70},
          {160,-80},{10,-80}}, color={0,127,255}));
  connect(mHeaWat_flow.port_b, pipHeaWat.port_a) annotation (Line(points={{160,-130},
          {160,-140},{10,-140}}, color={0,127,255}));
  connect(con.y, min1.u2) annotation (Line(points={{-158,20},{-100,20},{-100,34},
          {-92,34}}, color={0,0,127}));
  connect(con.y, max2.u1) annotation (Line(points={{-158,20},{-100,20},{-100,6},
          {-92,6}}, color={0,0,127}));
  connect(THeaWatRet.y, max2.u2) annotation (Line(points={{-108,0},{-100,0},{
          -100,-6},{-92,-6}}, color={0,0,127}));
  connect(reqPlaRes.yChiWatResReq, ph[1].u) annotation (Line(points={{68,120},{
          50,120},{50,124},{42,124}}, color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, ph[2].u) annotation (Line(points={{68,115},{50,
          115},{50,124},{42,124}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[1].u2) annotation (Line(points={{68,
          109},{12,109},{12,114},{2,114}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[2].u2) annotation (Line(points={{68,
          104},{12,104},{12,114},{2,114}}, color={255,127,0}));
  connect(ph[1].y, mulInt[3].u2) annotation (Line(points={{18,124},{12,124},{12,
          114},{2,114}}, color={255,127,0}));
  connect(ph[2].y, mulInt[4].u2) annotation (Line(points={{18,124},{12,124},{12,
          114},{2,114}}, color={255,127,0}));
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
by simulating a <i>24</i>-hour period with overlapping heating and
cooling loads.
The heating loads reach their peak value first, the cooling loads reach it last.
</p>
<p>
Three equally sized heat pumps are modeled. All can be lead/lag alternated.
A unique aggregated load is modeled on each loop by means of a cooling or heating
component controlled to maintain a constant <i>&Delta;T</i>
and a modulating valve controlled to track a prescribed flow rate.
An importance multiplier of <i>10</i> is applied to the plant requests 
and reset requests generated from the valve position.
</p>
<p>
The user can toggle the top-level parameter <code>have_chiWat</code>
to switch between a cooling and heating system (the default setting) 
to a heating-only system.
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
<p>
Simulating this model shows how the plant responds to the load by 
</p>
<ul>
<li>
staging or unstaging the AWHPs and associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure 
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging and controlling the secondary pumps to meet the 
remote differential pressure setpoint.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})));
end AirToWater;
