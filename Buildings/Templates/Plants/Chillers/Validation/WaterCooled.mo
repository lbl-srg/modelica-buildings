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
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
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
      origin={-170,-40})));
  replaceable Buildings.Templates.Plants.Chillers.WaterCooled pla(
    redeclare final package MediumCon = Medium,
    chi(
      have_senTConWatChiSup=true,
      have_senTConWatChiRet_select=true),
    redeclare replaceable
      Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve
      eco "Heat exchanger with bypass valve for CHW flow control",
    ctl(typCtlHea=Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.ByChiller,
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
    annotation (Placement(transformation(extent={{-80,-100},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirSup(k=293.15, y(final
        unit="K", displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-80})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(final
      heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None, final
      cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{120,50},{100,70}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation (Placement(transformation(extent={{-60,40},{-20,80}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  HeatPumps.Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{-100,-40},{-60,0}}),   iconTransformation(
          extent={{-370,-70},{-330,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratLoa(
    table=[
      0, 0;
      5, 0;
      7, 0;
      12, 0.2;
      16, 1;
      22, 0.1;
      24, 0],
    timeScale=3600) "Fraction of design load"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-80})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[2]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    each k=10) "Request multiplier factor"
    annotation (Placement(transformation(extent={{120,90},{100,110}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max - max(datAll.pla.ctl.dpChiWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{40,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant schEna(k=true)
    "Plant enable schedule"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadTwoWayValveControl
    loa(
    redeclare final package MediumLiq=Medium,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling,
    final mLiq_flow_nominal=pla.mChiWat_flow_nominal,
    dpBal1_nominal=datAll.pla.ctl.dpChiWatRemSet_max[1] - loa.dpTer_nominal -
        loa.dpValve_nominal,
    final TLiqEnt_nominal=pla.TChiWatSup_nominal,
    final TLiqLvg_nominal=pla.TChiWatRet_nominal,
    final energyDynamics=energyDynamics)
    "Cooling load"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(final
      integerTrue=Buildings.Fluid.HydronicConfigurations.Controls.OperatingModes.enabled,
      final integerFalse=Buildings.Fluid.HydronicConfigurations.Controls.OperatingModes.disabled)
    "Cast enable schedule to integer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumChiWat,
    final energyDynamics=energyDynamics,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    V=1E-5*pla.cap_nominal,
    nPorts=2) "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  replaceable package MediumChiWat = Media.Water;
equation
  connect(mulInt[1].y, busAirHan.reqResChiWat)
    annotation (Line(points={{-12,60},{-40,60}},  color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaChiWat)
    annotation (Line(points={{-12,60},{-40,60}},  color={255,127,0}));
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-160,-40},{-60,-40},{-60,-60}},color={255,204,51},thickness=0.5));
  connect(TAirSup.y, reqPlaRes.TAirSup) annotation (Line(points={{-158,80},{128,
          80},{128,68},{122,68}},        color={0,0,127}));
  connect(TAirSup.y, reqPlaRes.TAirSupSet) annotation (Line(points={{-158,80},{
          128,80},{128,63},{122,63}},     color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation (Line(points={{-40,60},{-40,-66}}, color={255,204,51},thickness=0.5));
  connect(pla.bus, busPla)
    annotation (Line(points={{-80,-70},{-80,-20}},color={255,204,51},thickness=0.5));
  connect(mChiWat_flow.port_b, dpChiWatRem[1].port_b)
    annotation (Line(points={{160,-90},{160,-120},{60,-120},{60,-90}},  color={0,127,255}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{98,100},{60,100},{60,66},{12,66}},
                                                               color={255,127,0}));
  connect(mChiWat_flow.port_b, pipChiWat.port_a)
    annotation (Line(points={{160,-90},{160,-120},{40,-120}},color={0,127,255}));
  connect(dpChiWatRem.p_rel, busPla.dpChiWatRem)
    annotation (Line(points={{51,-80},{40.5,-80},{40.5,-20},{-80,-20}},color={0,0,127}),
      Text(string="%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(reqPlaRes.yChiWatResReq, mulInt[1].u2) annotation (Line(points={{98,68},
          {80,68},{80,54},{12,54}},   color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, mulInt[2].u2) annotation (Line(points={{98,63},
          {80,63},{80,54},{12,54}},   color={255,127,0}));
  connect(schEna.y, busPla.u1SchEna) annotation (Line(points={{-158,0},{-80,0},{
          -80,-20}},       color={255,0,255}));
  connect(loa.port_b, mChiWat_flow.port_a) annotation (Line(points={{120,-40},{160,
          -40},{160,-70}}, color={0,127,255}));
  connect(pla.port_b, loa.port_a) annotation (Line(points={{-39.8,-80},{-20,-80},
          {-20,-40},{100,-40}}, color={0,127,255}));
  connect(ratLoa.y[1], loa.u) annotation (Line(points={{-158,40},{80,40},{80,-32},
          {98,-32}}, color={0,0,127}));
  connect(loa.yVal_actual, reqPlaRes.uCooCoiSet) annotation (Line(points={{122,-32},
          {140,-32},{140,57},{122,57}}, color={0,0,127}));
  connect(schEna.y, booToInt.u)
    annotation (Line(points={{-158,0},{-12,0}}, color={255,0,255}));
  connect(booToInt.y, loa.mode) annotation (Line(points={{12,0},{76,0},{76,-36},
          {98,-36}}, color={255,127,0}));
  connect(dpChiWatRem[1].port_a, loa.port_a)
    annotation (Line(points={{60,-70},{60,-40},{100,-40}}, color={0,127,255}));
  connect(pipChiWat.port_b, vol.ports[1])
    annotation (Line(points={{20,-120},{-1,-120}}, color={0,127,255}));
  connect(vol.ports[2], pla.port_a) annotation (Line(points={{1,-120},{-20,-120},
          {-20,-90},{-39.8,-90}}, color={0,127,255}));
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
A unique aggregated load is modeled on the CHW loop using a heat exchanger
component exposed to conditioned space air, and a two-way modulating valve.
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
<h5>Actuators within the plant</h5>
<p>
By default, all valves within the plant are modeled considering a linear
variation of pressure drop with flow rate (<code>pla.linearized=true</code>),
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
        extent={{-200,-160},{200,160}})));
end WaterCooled;
