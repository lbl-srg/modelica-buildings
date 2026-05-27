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
      final cfg=pla.cfg)) "Plant parameters"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(
    displayUnit="Pa")=3E4
    "Liquid pressure drop across terminal unit at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")=dpTer_nominal
    "Terminal unit control valve pressure drop at design conditions";
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
  Buildings.Templates.Plants.HeatPumps.AirToWater pla(
    redeclare final package MediumHeaWat=Medium,
    have_hrc_select=true,
    final dat=datAll.pla,
    final have_chiWat=have_chiWat,
    nHp=3,
    typPumHeaWatPri_select1=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
    final allowFlowReversal=allowFlowReversal,
    linearized=true,
    show_T=true,
    ctl(
      nAirHan=1,
      nEquZon=0),
    is_dpBalYPumSetCal=true)
    "Heat pump plant"
    annotation (Placement(transformation(extent={{-80,-100},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-118})));
  Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    if have_chiWat
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-58})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final cooCoi=if have_chiWat then Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
      else Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{90,42},{70,62}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation (Placement(transformation(extent={{-60,40},{-20,80}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  Interfaces.Bus busPla "Plant control bus"
    annotation (Placement(transformation(extent={{-100,-40},{-60,0}}),
      iconTransformation(extent={{-370,-70},{-330,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratLoa(
    table=[
    0, 0, 0;
    5, 0, 0;
    7, 1, 0;
    10, 0.5, 0;
    14, 0, 0.6;
    16, 0, 1;
    18, 0, 0.6;
    22, 0.1, 0.1;
    24, 0, 0],
    timeScale=3600)
    "Fraction of design load – Index 1 for heating, 2 for cooling"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
    redeclare final package Medium=Medium)
    if have_chiWat
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-60})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-120})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[4]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{0,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](
    each k=10) "Request multiplier factor"
    annotation (Placement(transformation(extent={{40,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaLoa(k=true)
    "Load enable"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max -
      max(datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{50,-150},{30,-130}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max -
      max(datAll.pla.ctl.dpChiWatRemSet_max))
    if have_chiWat
    "Piping"
    annotation (Placement(transformation(extent={{50,-90},{30,-70}})));
  Controls.Utilities.PlaceholderInteger ph[2](
    each final have_inp=have_chiWat,
    each final u_internal=0)
    "Placeholder value"
    annotation (Placement(transformation(extent={{40,54},{20,74}})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loaCoo(
    redeclare final package MediumLiq = Medium,
    final energyDynamics=energyDynamics,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling,
    final mLiq_flow_nominal=pla.mChiWat_flow_nominal,
    final dpTer_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=datAll.pla.ctl.dpChiWatRemSet_max[1] - dpTer_nominal - dpValve_nominal,
    final TLiqEnt_nominal=pla.TChiWatSup_nominal,
    final TLiqLvg_nominal=pla.TChiWatRet_nominal,
    con(val(y_start=0)),
    loa(coi(show_T=true))) if have_chiWat
    "Cooling load"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Templates.Components.Loads.LoadTwoWayValve loaHea(
    redeclare final package MediumLiq = Medium,
    final energyDynamics=energyDynamics,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    final mLiq_flow_nominal=pla.mHeaWat_flow_nominal,
    final dpTer_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=datAll.pla.ctl.dpHeaWatRemSet_max[1] - dpTer_nominal - dpValve_nominal,
    final TLiqEnt_nominal=pla.THeaWatSup_nominal,
    final TLiqLvg_nominal=pla.THeaWatRet_nominal,
    con(val(y_start=0)))                          "Heating load"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap*pla.capHea_nominal,
    redeclare package Medium = Medium,
    nPorts=2)                          "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{-10,-100},{10,-120}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=energyDynamics,
    final m_flow_nominal=pla.mChiWat_flow_nominal,
    V=Buildings.Templates.Data.Defaults.ratVLiqByCap*pla.capCoo_nominal,
    redeclare package Medium = Medium,
    nPorts=2) if have_chiWat           "Fluid volume in distribution system"
    annotation (Placement(transformation(extent={{-10,-40},{10,-60}})));
equation
  if have_chiWat then
    connect(mulInt[3].y, busAirHan.reqResChiWat)
      annotation (Line(points={{-22,60},{-40,60}},  color={255,127,0}));
    connect(mulInt[4].y, busAirHan.reqPlaChiWat)
      annotation (Line(points={{-22,60},{-40,60}},  color={255,127,0}));
  end if;
  connect(weaDat.weaBus, pla.busWea)
    annotation (Line(points={{-160,-40},{-60,-40},{-60,-60}},color={255,204,51},thickness=0.5));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation (Line(points={{-158,80},{100,80},{100,60},{92,60}},    color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation (Line(points={{-158,80},{100,80},{100,55},{92,55}},    color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation (Line(points={{-40,60},{-40,-62}}, color={255,204,51},thickness=0.5));
  connect(pla.bus, busPla)
    annotation (Line(points={{-80,-62},{-80,-20}},color={255,204,51},thickness=0.5));
  connect(mChiWat_flow.port_b, dpChiWatRem[1].port_b)
    annotation (Line(points={{160,-70},{160,-80},{60,-80},{60,-68}},  color={0,127,255}));
  connect(mHeaWat_flow.port_b, dpHeaWatRem[1].port_b)
    annotation (Line(points={{160,-130},{160,-140},{60,-140},{60,-128}},color={0,127,255}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{18,100},{6,100},{6,66},{2,66}},  color={255,127,0}));
  connect(mulInt[1].y, busAirHan.reqResHeaWat)
    annotation (Line(points={{-22,60},{-40,60}},  color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqPlaHeaWat)
    annotation (Line(points={{-22,60},{-40,60}},  color={255,127,0}));
  connect(mChiWat_flow.port_b, pipChiWat.port_a)
    annotation (Line(points={{160,-70},{160,-80},{50,-80}},  color={0,127,255}));
  connect(mHeaWat_flow.port_b, pipHeaWat.port_a)
    annotation (Line(points={{160,-130},{160,-140},{50,-140}},color={0,127,255}));
  connect(reqPlaRes.yChiWatResReq, ph[1].u)
    annotation (Line(points={{68,60},{50,60},{50,64},{42,64}},    color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, ph[2].u)
    annotation (Line(points={{68,55},{50,55},{50,64},{42,64}},    color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[1].u2)
    annotation (Line(points={{68,49},{12,49},{12,54},{2,54}},    color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[2].u2)
    annotation (Line(points={{68,44},{12,44},{12,54},{2,54}},    color={255,127,0}));
  connect(ph[1].y, mulInt[3].u2)
    annotation (Line(points={{18,64},{12,64},{12,54},{2,54}},    color={255,127,0}));
  connect(ph[2].y, mulInt[4].u2)
    annotation (Line(points={{18,64},{12,64},{12,54},{2,54}},    color={255,127,0}));
  connect(dpChiWatRem.p_rel, busPla.dpChiWatRem)
    annotation (Line(points={{51,-58},{22,-58},{22,-18},{-80,-18},{-80,-20}},
                                                                       color={0,0,127}),
      Text(string="%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(dpHeaWatRem.p_rel, busPla.dpHeaWatRem)
    annotation (Line(points={{51,-118},{20,-118},{20,-20},{-80,-20}},
      color={0,0,127}),Text(string="%second",index=1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(loaCoo.port_b, mChiWat_flow.port_a) annotation (Line(points={{110,-40},
          {160,-40},{160,-50}}, color={0,127,255}));
  connect(dpChiWatRem[1].port_a, loaCoo.port_a)
    annotation (Line(points={{60,-48},{60,-40},{90,-40}}, color={0,127,255}));
  connect(loaCoo.yVal_actual, reqPlaRes.uCooCoiSet) annotation (Line(points={{112,-32},
          {126,-32},{126,49},{92,49}},      color={0,0,127}));
  connect(loaHea.port_b, mHeaWat_flow.port_a) annotation (Line(points={{110,
          -100},{160,-100},{160,-110}},
                                  color={0,127,255}));
  connect(dpHeaWatRem[1].port_a, loaHea.port_a) annotation (Line(points={{60,-108},
          {60,-100},{90,-100}}, color={0,127,255}));
  connect(ratLoa.y[2], loaCoo.u) annotation (Line(points={{-158,40},{80,40},{80,
          -32},{88,-32}}, color={0,0,127}));
  connect(ratLoa.y[1], loaHea.u) annotation (Line(points={{-158,40},{80,40},{80,
          -92},{88,-92}}, color={0,0,127}));
  connect(loaHea.yVal_actual, reqPlaRes.uHeaCoiSet) annotation (Line(points={{112,-92},
          {130,-92},{130,44},{92,44}},      color={0,0,127}));
  connect(enaLoa.y, loaCoo.u1) annotation (Line(points={{-158,0},{76,0},{76,-36},
          {88,-36}}, color={255,0,255}));
  connect(enaLoa.y, loaHea.u1) annotation (Line(points={{-158,0},{76,0},{76,-96},
          {88,-96}}, color={255,0,255}));
  connect(pla.port_bHeaWat, volHeaWat.ports[1]) annotation (Line(points={{-40,-90},
          {-20,-90},{-20,-100},{-1,-100}},      color={0,127,255}));
  connect(volHeaWat.ports[2], loaHea.port_a)
    annotation (Line(points={{1,-100},{90,-100}}, color={0,127,255}));
  connect(pipHeaWat.port_b, pla.port_aHeaWat) annotation (Line(points={{30,-140},
          {-30,-140},{-30,-98},{-40,-98}}, color={0,127,255}));
  connect(pla.port_bChiWat, volChiWat.ports[1]) annotation (Line(points={{-40,
          -76},{-20,-76},{-20,-40},{-1,-40}}, color={0,127,255}));
  connect(volChiWat.ports[2], loaCoo.port_a)
    annotation (Line(points={{1,-40},{90,-40}}, color={0,127,255}));
  connect(pipChiWat.port_b, pla.port_aChiWat) annotation (Line(points={{30,-80},
          {-40,-80},{-40,-84}}, color={0,127,255}));
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
Three equally sized heat pumps are modeled, which can all be lead/lag alternated.
A heat recovery chiller is included (<code>pla.have_hrc_select=true</code>)
and connected to the HW and CHW return pipes (sidestream integration).
A unique aggregated load is modeled on each loop using a heat exchanger component
exposed to conditioned space air, and a two-way modulating valve.
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
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the AWHPs and the HRC with the associated primary pumps,
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
<p>
Note that the HRC model does not explicitly represent compressor cycling.
As a result, the cycling-based disabling condition specified in
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable\">
Buildings.Templates.Plants.Controls.HeatRecoveryChillers.Enable</a>
is never triggered.
This limitation may lead to overestimating the HRC operating time.
</p>
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
December 2, 2025, by Antoine Gautier:<br/>
Updated load model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4432\">#4432</a>.
</li>
<li>
August 21, 2025, by Antoine Gautier:<br/>
Refactored with load-dependent 2D table data heat pump model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
</li>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added sidestream HRC and refactored the model after updating the HP plant template.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-200,-160},{200,160}})));
end AirToWater;
