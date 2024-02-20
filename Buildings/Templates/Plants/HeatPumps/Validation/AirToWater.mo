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
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
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
      origin={-110,98})));
  Fluid.HeatExchangers.SensibleCooler_T loaHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{60,-52},{80,-32}})));
  Fluid.HeatExchangers.Heater_T loaChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300)
    if have_chiWat
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{60,-12},{80,8}})));
  Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(
    k=pla.THeaWatRet_nominal,
    y(
      final unit="K",
      displayUnit="degC"))
    "Source signal for HW return temperature"
    annotation (Placement(transformation(extent={{-120,-92},{-100,-72}})));
  Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(
    k=pla.TChiWatRet_nominal,
    y(
      final unit="K",
      displayUnit="degC"))
    "Source signal for CHW return temperature"
    annotation (Placement(transformation(extent={{-120,8},{-100,28}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valDisHeaWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dpValve_nominal=1E4,
    dpFixed_nominal=datAll.pla.ctl.dpHeaWatLocSet_nominal - 1E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{90,-52},{110,-32}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valDisChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dpValve_nominal=1E4,
    dpFixed_nominal=datAll.pla.ctl.dpChiWatLocSet_nominal - 1E4)
    if have_chiWat
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{90,-12},{110,8}})));
  Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(
    table=[
      0, 0, 0;
      15, 0, 0;
      25, 0.3, 0.1;
      38, 1, 0.1;
      60, 0.1, 0.1;
      75, 0.1, 1;
      98, 1, 0.3;
      120, 0.1, 0.1;
      135, 0.1, 1;
      158, 0.1, 0.3;
      180, 0, 0;
      195, 0, 1;
      240, 0, 0],
    timeScale=60)
    "Source signal: y[1] for cooling load, y[2] for heating load"
    annotation (Placement(transformation(extent={{-120,48},{-100,68}})));
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
    annotation (Placement(transformation(extent={{-40,-38},{0,2}})));
  // FIXME: Prototype implementation for calculating pump speed to meet design flow.
  parameter Real r_N[pla.nPumHeaWatPri](
    each unit="1",
    each start=1,
    each fixed=false)
    "Relative revolution, r_N=N/N_nominal";
initial equation
  fill(0, pla.nPumHeaWatPri)=Buildings.Templates.Utilities.computeBalancingPressureDrop(
    m_flow_nominal=fill(datAll.pla.hp.mHeaWatHp_flow_nominal, pla.nHp),
    dp_nominal=pla.pumPri.dpValChe_nominal .+ fill(datAll.pla.hp.dpHeaWatHp_nominal, pla.nHp) .+
      fill(Buildings.Templates.Data.Defaults.dpValIso, pla.nHp),
    datPum=datAll.pla.pumHeaWatPriSin,
    r_N=r_N);
equation
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-100,98},{-20,98},{-20,2}},color={255,204,51},thickness=0.5));
  connect(THeaWatRet.y, loaHeaWat.TSet)
    annotation (Line(points={{-98,-82},{50,-82},{50,-34},{58,-34}},color={0,0,127}));
  connect(TChiWatRet.y, loaChiWat.TSet)
    annotation (Line(points={{-98,18},{50,18},{50,6},{58,6}},color={0,0,127}));
  connect(ratFlo.y[1], valDisChiWat.y)
    annotation (Line(points={{-98,58},{100,58},{100,10}},color={0,0,127}));
  connect(ratFlo.y[2], valDisHeaWat.y)
    annotation (Line(points={{-98,58},{120,58},{120,-26},{100,-26},{100,-30}},
      color={0,0,127}));
  connect(pla.port_bChiWat, loaChiWat.port_a)
    annotation (Line(points={{0,-14},{40,-14},{40,-2},{60,-2}},color={0,127,255}));
  connect(loaChiWat.port_b, valDisChiWat.port_a)
    annotation (Line(points={{80,-2},{90,-2}},color={0,127,255}));
  connect(valDisChiWat.port_b, pla.port_aChiWat)
    annotation (Line(points={{110,-2},{140,-2},{140,-22},{0,-22}},color={0,127,255}));
  connect(loaHeaWat.port_b, valDisHeaWat.port_a)
    annotation (Line(points={{80,-42},{90,-42}},color={0,127,255}));
  connect(pla.port_bHeaWat, loaHeaWat.port_a)
    annotation (Line(points={{0,-28},{40,-28},{40,-42},{60,-42}},color={0,127,255}));
  connect(valDisHeaWat.port_b, pla.port_aHeaWat)
    annotation (Line(points={{110,-42},{140,-42},{140,-62},{20,-62},{20,-36},{0,-36}},
      color={0,127,255}));
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
