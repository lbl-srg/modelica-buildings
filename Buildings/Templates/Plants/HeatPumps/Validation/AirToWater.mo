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
    annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
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
      origin={-110,100})));
  Fluid.HeatExchangers.SensibleCooler_T loaHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Fluid.HeatExchangers.Heater_T loaChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300)
    if have_chiWat
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(k=pla.THeaWatRet_nominal,
      y(final unit="K", displayUnit="degC"))
    "Source signal for HW return temperature"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(k=pla.TChiWatRet_nominal,
      y(final unit="K", displayUnit="degC"))
    "Source signal for CHW return temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valDisHeaWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dpValve_nominal=1E4,
    dpFixed_nominal=datAll.pla.ctl.dpHeaWatLocSet_nominal - 1E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valDisChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dpValve_nominal=1E4,
    dpFixed_nominal=datAll.pla.ctl.dpChiWatLocSet_nominal - 1E4)
    if have_chiWat
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 15,0,
        0; 25,0.3,0.1; 38,1,0.1; 60,0.1,0.1; 75,0.1,1; 98,1,0.3; 120,0.1,0.1;
        135,0.1,1; 158,0.1,0.3; 180,0,0; 195,0,1; 240,0,0], timeScale=60)
    "Source signal: y[1] for cooling load, y[2] for heating load"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
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
    show_T=true)
    "Heat pump plant"
    annotation (Placement(transformation(extent={{-40,-36},{0,4}})));
  // FIXME: Prototype implementation for calculating pump speed to meet design flow.
  parameter Real r_N[pla.nPumHeaWatPri](
    each unit="1",
    each start=1,
    each fixed=false)
    "Relative revolution, r_N=N/N_nominal";
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests
    mulAHUPlaReq "Plant request generator"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TPla(k=293.15, y(final unit
        ="K", displayUnit="degC")) "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
initial equation
  fill(0, pla.nPumHeaWatPri)=Buildings.Templates.Utilities.computeBalancingPressureDrop(
    m_flow_nominal=fill(datAll.pla.hp.mHeaWatHp_flow_nominal, pla.nHp),
    dp_nominal=pla.pumPri.dpValChe_nominal .+ fill(datAll.pla.hp.dpHeaWatHp_nominal, pla.nHp) .+
      fill(Buildings.Templates.Data.Defaults.dpValIso, pla.nHp),
    datPum=datAll.pla.pumHeaWatPriSin,
    r_N=r_N);
equation
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-100,100},{-20,100},{-20,4}},
                                                         color={255,204,51},thickness=0.5));
  connect(THeaWatRet.y, loaHeaWat.TSet)
    annotation (Line(points={{-98,-80},{50,-80},{50,-32},{58,-32}},color={0,0,127}));
  connect(ratFlo.y[1], valDisChiWat.y)
    annotation (Line(points={{-98,60},{100,60},{100,12}},color={0,0,127}));
  connect(ratFlo.y[2], valDisHeaWat.y)
    annotation (Line(points={{-98,60},{120,60},{120,-24},{100,-24},{100,-28}},
      color={0,0,127}));
  connect(pla.port_bChiWat, loaChiWat.port_a)
    annotation (Line(points={{0,-12},{40,-12},{40,0},{60,0}},  color={0,127,255}));
  connect(loaChiWat.port_b, valDisChiWat.port_a)
    annotation (Line(points={{80,0},{90,0}},  color={0,127,255}));
  connect(valDisChiWat.port_b, pla.port_aChiWat)
    annotation (Line(points={{110,0},{140,0},{140,-20},{0,-20}},  color={0,127,255}));
  connect(loaHeaWat.port_b, valDisHeaWat.port_a)
    annotation (Line(points={{80,-40},{90,-40}},color={0,127,255}));
  connect(pla.port_bHeaWat, loaHeaWat.port_a)
    annotation (Line(points={{0,-26},{40,-26},{40,-40},{60,-40}},color={0,127,255}));
  connect(valDisHeaWat.port_b, pla.port_aHeaWat)
    annotation (Line(points={{110,-40},{140,-40},{140,-60},{20,-60},{20,-34},{0,
          -34}},
      color={0,127,255}));
  connect(TChiWatRet.y, loaChiWat.TSet) annotation (Line(points={{-98,20},{40,
          20},{40,8},{58,8}}, color={0,0,127}));
  connect(ratFlo.y[1], mulAHUPlaReq.uCooCoiSet) annotation (Line(points={{-98,
          60},{0,60},{0,77},{18,77}}, color={0,0,127}));
  connect(ratFlo.y[2], mulAHUPlaReq.uHeaCoiSet) annotation (Line(points={{-98,
          60},{0,60},{0,72},{18,72}}, color={0,0,127}));
  connect(TPla.y, mulAHUPlaReq.TAirSup) annotation (Line(points={{-98,140},{0,
          140},{0,88},{18,88}}, color={0,0,127}));
  connect(TPla.y, mulAHUPlaReq.TAirSupSet) annotation (Line(points={{-98,140},{
          0,140},{0,83},{18,83}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=14400.0),
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
        extent={{-160,-160},{160,160}})));
end AirToWater;
