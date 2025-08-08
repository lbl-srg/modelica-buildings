within Buildings.Templates.Plants.Chillers.Validation;
model WaterCooled "Validation of water-cooled chiller plant template"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and CW)";
  replaceable parameter
    Buildings.Templates.Plants.Chillers.Validation.UserProject.Data.AllSystemsWaterCooled
    datAll(pla(cfg=pla.cfg))
    "Plant parameters"
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true, Dialog(tab="Dynamics",group="Conservation equations"));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-170,-60})));
  Buildings.Fluid.HeatExchangers.Heater_T loaChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=pla.cap_nominal)
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=datAll.pla.ctl.dpChiWatRemSet_max[1] - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));
  replaceable Buildings.Templates.Plants.Chillers.WaterCooled pla(
    redeclare final package MediumCon = Medium,
    chi(
      have_senTConWatChiSup=true,
      have_senTConWatChiRet_select=true),
    redeclare replaceable
      Buildings.Templates.Plants.Chillers.Components.Economizers.None eco
      "No waterside economizer",
    ctl(typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.Chiller,
        typCtlFanCoo=Buildings.Templates.Plants.Chillers.Types.CoolerFanSpeedControl.SupplyTemperature))
    constrainedby Buildings.Templates.Plants.Chillers.Interfaces.PartialChilledWaterLoop(
      redeclare final package MediumChiWat = Medium,
      nChi=2,
      nAirHan=1,
      final energyDynamics=energyDynamics,
      final dat=datAll.pla,
      show_T=true,
      linearized=true,
      chi(
        have_senTChiWatChiSup_select=true,
        have_senTChiWatChiRet=true))
    "Chiller plant"
    annotation (Placement(transformation(extent={{-80,-120},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirSup(k=293.15, y(final
        unit="K", displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-100})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(final
      heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None, final
      cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{110,128},{90,148}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation (Placement(transformation(extent={{-60,120},{-20,160}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  HeatPumps.Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{-100,-60},{-60,-20}}), iconTransformation(
          extent={{-370,-70},{-330,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(
    table=[
      0, 0;
      5, 0;
      7, 0;
      12, 0.2;
      16, 1;
      22, 0.1;
      24, 0],
    timeScale=3600) "Source signal for CHW flow ratio"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon(
    k=0.1,
    Ti=60,
    final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo(k=1/pla.mChiWat_flow_nominal)
    "Normalize flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,0})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-100})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TChiWatRet(
    p=pla.TChiWatRet_nominal - pla.TChiWatSup_nominal)
    "Prescribed CHW return temperature"
    annotation (Placement(transformation(extent={{-128,10},{-108,30}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[2]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{10,130},{-10,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    each k=10) "Request multiplier factor"
    annotation (Placement(transformation(extent={{110,170},{90,190}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max - max(datAll.pla.ctl.dpChiWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=293.15) "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant schEna(k=true)
    "Plant enable schedule"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
equation
  connect(mulInt[1].y, busAirHan.reqResChiWat)
    annotation (Line(points={{-12,140},{-40,140}},color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaChiWat)
    annotation (Line(points={{-12,140},{-40,140}},color={255,127,0}));
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-160,-60},{-60,-60},{-60,-80}},color={255,204,51},thickness=0.5));
  connect(loaChiWat.port_b, valDisChiWat.port_a)
    annotation (Line(points={{90,-60},{110,-60}},color={0,127,255}));
  connect(loaChiWat.port_a, dpChiWatRem[1].port_a)
    annotation (Line(points={{70,-60},{60,-60},{60,-90}},color={0,127,255}));
  connect(TAirSup.y, reqPlaRes.TAirSup) annotation (Line(points={{-158,160},{
          120,160},{120,146},{112,146}}, color={0,0,127}));
  connect(TAirSup.y, reqPlaRes.TAirSupSet) annotation (Line(points={{-158,160},
          {120,160},{120,141},{112,141}}, color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation (Line(points={{-40,140},{-40,-86}},color={255,204,51},thickness=0.5));
  connect(pla.bus, busPla)
    annotation (Line(points={{-80,-90},{-80,-40}},color={255,204,51},thickness=0.5));
  connect(valDisChiWat.y_actual, reqPlaRes.uCooCoiSet)
    annotation (Line(points={{125,-53},{140,-53},{140,135},{112,135}}, color={0,0,127}));
  connect(valDisChiWat.port_b, mChiWat_flow.port_a)
    annotation (Line(points={{130,-60},{160,-60},{160,-90}},color={0,127,255}));
  connect(mChiWat_flow.port_b, dpChiWatRem[1].port_b)
    annotation (Line(points={{160,-110},{160,-140},{60,-140},{60,-110}},color={0,127,255}));
  connect(busPla.TChiWatPriSup, TChiWatRet.u)
    annotation (Line(points={{-80,-40},{-140,-40},{-140,20},{-130,20}},color={255,204,51},thickness=0.5));
  connect(min1.y, loaChiWat.TSet)
    annotation (Line(points={{-68,40},{60,40},{60,-52},{68,-52}},color={0,0,127}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{88,180},{60,180},{60,146},{12,146}},
                                                               color={255,127,0}));
  connect(mChiWat_flow.port_b, pipChiWat.port_a)
    annotation (Line(points={{160,-110},{160,-140},{10,-140}},
                                                             color={0,127,255}));
  connect(dpChiWatRem.p_rel, busPla.dpChiWatRem)
    annotation (Line(points={{51,-100},{40.5,-100},{40.5,-40},{-80,-40}},
                                                                       color={0,0,127}),
      Text(string="%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(reqPlaRes.yChiWatResReq, mulInt[1].u2) annotation (Line(points={{88,146},
          {80,146},{80,134},{12,134}},color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, mulInt[2].u2) annotation (Line(points={{88,141},
          {80,141},{80,134},{12,134}},color={255,127,0}));
  connect(ratFlo.y[1], ctlEquZon.u_s)
    annotation (Line(points={{-158,100},{88,100}}, color={0,0,127}));
  connect(mChiWat_flow.m_flow, norFlo.u)
    annotation (Line(points={{171,-100},{180,-100},{180,-12}},
                                                             color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m) annotation (Line(points={{180,12},{180,80},{100,
          80},{100,88}}, color={0,0,127}));
  connect(ctlEquZon.y, valDisChiWat.y)
    annotation (Line(points={{112,100},{120,100},{120,-48}}, color={0,0,127}));
  connect(con.y, min1.u1) annotation (Line(points={{-158,40},{-100,40},{-100,46},
          {-92,46}}, color={0,0,127}));
  connect(TChiWatRet.y, min1.u2) annotation (Line(points={{-106,20},{-100,20},{-100,
          34},{-92,34}}, color={0,0,127}));
  connect(pla.port_a, pipChiWat.port_b) annotation (Line(points={{-39.8,-110},{
          -20,-110},{-20,-140},{-10,-140}},
                                        color={0,127,255}));
  connect(pla.port_b, loaChiWat.port_a) annotation (Line(points={{-39.8,-100},{
          -20,-100},{-20,-60},{70,-60}},
                                    color={0,127,255}));
  connect(schEna.y, busPla.u1SchEna) annotation (Line(points={{-158,-20},{-80,
          -20},{-80,-40}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Validation/WaterCooled.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Chillers.WaterCooled\">
Buildings.Templates.Plants.Chillers.WaterCooled</a>
by simulating a <i>24</i>-hour period during which the cooling loads reach
their peak value.
</p>
<p>
Two equally sized chillers are modeled.
A unique aggregated load is modeled on the CHW loop by means of a heating
component controlled to maintain a constant <i>&Delta;T</i>,
and a modulating valve controlled to track a prescribed flow rate.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the chillers,
</li>
<li>
resetting the supply temperature and remote differential pressure
in the CHW loop based on the valve position,
</li>
<li>
staging and controlling the primary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
<h4>Details</h4>
<p>
By default, all valves within the plant are modeled considering a linear
variation of the pressure drop with the flow rate (<code>pla.linearized=true</code>),
as opposed to the quadratic relationship usually considered for
a turbulent flow regime.
By limiting the size of the system of nonlinear equations, this setting
reduces the risk of solver failure and the time to solution for testing
various plant configurations.
</p>
</html>",
      revisions="<html>
<ul>
<li>
XXXX, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})));
end WaterCooled;
