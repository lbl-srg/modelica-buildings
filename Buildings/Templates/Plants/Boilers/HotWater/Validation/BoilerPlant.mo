within Buildings.Templates.Plants.Boilers.HotWater.Validation;
model BoilerPlant
  "Validation of boiler plant template with G36 controls"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";
  replaceable parameter
    Buildings.Templates.Plants.Boilers.HotWater.Validation.UserProject.Data.AllSystems
    datAll(pla(final cfg=pla.cfg))
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{160,120},{180,140}})));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant pla(
    redeclare final package Medium = Medium,
    nBoiCon_select=2,
    typPumHeaWatPriCon=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Variable,
    typArrPumHeaWatPriCon_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.Condensing,
    nBoiNon_select=2,
    typPumHeaWatPriNon=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Variable,
    typArrPumHeaWatPriNon_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typPumHeaWatSec1_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final dat=datAll.pla,
    ctl(
      nAirHan=1,
      nEquZon=0,
      have_senDpHeaWatRemWir=true))
    "Boiler plant"
    annotation (Placement(transformation(extent={{-60,-100},{-20,-60}})));

  UserProject.BASControlPoints sigBAS "BAS control points"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Fluid.HeatExchangers.Heater_T           loaHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=pla.cap_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHeaWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=datAll.pla.ctl.dpHeaWatRemSet_max[1] - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirSup(k=293.15, y(final
        unit="K", displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(final
      heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
      final cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.None)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{110,90},{90,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0; 5,0; 7,0;
        12,0.2; 16,1; 22,0.1; 24,0], timeScale=3600)
                    "Source signal for CHW flow ratio"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon(
    k=0.1,
    Ti=60,
    final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo(k=1/pla.mHeaWat_flow_nominal)
    "Normalize flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-20})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THeaWatRet(p=pla.THeaWatSup_nominal
         - pla.THeaWatRet_nominal) "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-108,-30},{-88,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1 "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[2]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](each k=10)
               "Request multiplier factor"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=313.15)
    "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  AirHandlersFans.Interfaces.Bus busAirHan
    "AHU control bus"
    annotation (Placement(transformation(extent={{-40,-60},{0,-20}}),
      iconTransformation(extent={{-340,-140},{-300,-100}})));
  HeatPumps.Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{-140,-90},{-100,-50}}),iconTransformation(
          extent={{-370,-70},{-330,-30}})));
  Fluid.Sensors.RelativePressure dpHeaWatRem[1](redeclare each final package
      Medium = Medium) "HW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-80})));
  Fluid.Sensors.MassFlowRate mHeaWatLoo_flow(redeclare final package Medium =
        Medium) "HW loop mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-80})));
  Fluid.FixedResistances.PressureDrop           pipHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max - max(
         datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{30,-130},{10,-110}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busLooCon if pla.have_boiCon
    "Condensing boiler loop control bus" annotation (Placement(transformation(
          extent={{-160,-40},{-120,0}}),   iconTransformation(extent={{-466,50},
            {-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busLooNon if pla.have_boiNon
    "Non-condensing boiler loop control bus" annotation (Placement(
        transformation(extent={{-160,-60},{-120,-20}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
equation
  connect(TAirSup.y,reqPlaRes. TAirSup) annotation (Line(points={{-158,120},{
          120,120},{120,108},{112,108}}, color={0,0,127}));
  connect(TAirSup.y,reqPlaRes. TAirSupSet) annotation (Line(points={{-158,120},
          {120,120},{120,103},{112,103}}, color={0,0,127}));
  connect(busAirHan, pla.busAirHan[1])
    annotation (Line(points={{-20,-40},{-20,-66}},color={255,204,51},thickness=0.5));
  connect(pla.bus,busPla)
    annotation (Line(points={{-60,-70},{-120,-70}},
                                                  color={255,204,51},thickness=0.5));
  connect(max1.y,loaHeaWat. TSet)
    annotation (Line(points={{-38,0},{60,0},{60,-32},{68,-32}},  color={0,0,127}));
  connect(cst.y,mulInt. u1)
    annotation (Line(points={{88,140},{60,140},{60,106},{22,106}},
                                                               color={255,127,0}));
  connect(ratFlo.y[1],ctlEquZon. u_s)
    annotation (Line(points={{-158,60},{88,60}},   color={0,0,127}));
  connect(norFlo.y,ctlEquZon. u_m) annotation (Line(points={{180,-8},{180,20},{
          100,20},{100,48}},
                         color={0,0,127}));
  connect(ctlEquZon.y,valDisHeaWat. y)
    annotation (Line(points={{112,60},{120,60},{120,-28}},   color={0,0,127}));
  connect(con.y,max1. u1) annotation (Line(points={{-158,20},{-80,20},{-80,6},{
          -62,6}},   color={0,0,127}));
  connect(THeaWatRet.y, max1.u2) annotation (Line(points={{-86,-20},{-80,-20},{
          -80,-6},{-62,-6}}, color={0,0,127}));
  connect(mHeaWatLoo_flow.port_b, dpHeaWatRem[1].port_b) annotation (Line(
        points={{160,-90},{160,-120},{60,-120},{60,-90}}, color={0,127,255}));
  connect(pla.port_b,loaHeaWat. port_a) annotation (Line(points={{-19.8,-80},{0,
          -80},{0,-40},{70,-40}},   color={0,127,255}));
  connect(sigBAS.bus, busPla) annotation (Line(
      points={{-160,-70},{-120,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(mHeaWatLoo_flow.m_flow, norFlo.u)
    annotation (Line(points={{171,-80},{180,-80},{180,-32}}, color={0,0,127}));
  connect(valDisHeaWat.port_b, mHeaWatLoo_flow.port_a) annotation (Line(points={
          {130,-40},{160,-40},{160,-70}}, color={0,127,255}));
  connect(loaHeaWat.port_b, valDisHeaWat.port_a)
    annotation (Line(points={{90,-40},{110,-40}}, color={0,127,255}));
  connect(mHeaWatLoo_flow.port_b, pipHeaWat.port_a) annotation (Line(points={{160,
          -90},{160,-120},{30,-120}}, color={0,127,255}));
  connect(pipHeaWat.port_b, pla.port_a) annotation (Line(points={{10,-120},{0,-120},
          {0,-90},{-19.8,-90}}, color={0,127,255}));
  connect(dpHeaWatRem[1].port_a, loaHeaWat.port_a)
    annotation (Line(points={{60,-70},{60,-40},{70,-40}}, color={0,127,255}));
  connect(valDisHeaWat.y_actual, reqPlaRes.uHeaCoiSet) annotation (Line(points={{125,-33},
          {140,-33},{140,92},{112,92}},           color={0,0,127}));
  connect(mulInt[1].y, busAirHan.reqPlaHeaWat)
    annotation (Line(points={{-2,100},{-20,100},{-20,-40}},
                                                          color={255,127,0}));
  connect(mulInt[2].y, busAirHan.reqResHeaWat)
    annotation (Line(points={{-2,100},{-20,100},{-20,-40}},
                                                          color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[1].u2) annotation (Line(points={{88,92},
          {80,92},{80,94},{22,94}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[2].u2) annotation (Line(points={{88,97},
          {80,97},{80,94},{22,94}}, color={255,127,0}));
  connect(dpHeaWatRem.p_rel, busPla.dpHeaWatRem) annotation (Line(points={{51,
          -80},{40,-80},{40,-50},{-120,-50},{-120,-70}}, color={0,0,127}));
  connect(busLooNon.THeaWatPriSup, THeaWatRet.u) annotation (Line(
      points={{-140,-40},{-120,-40},{-120,-20},{-110,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(busLooCon.THeaWatPriSup, THeaWatRet.u) annotation (Line(
      points={{-140,-20},{-110,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.looNon, busLooNon) annotation (Line(
      points={{-120,-70},{-140,-70},{-140,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.looCon, busLooCon) annotation (Line(
      points={{-120,-70},{-154,-70},{-154,-20},{-140,-20}},
      color={255,204,51},
      thickness=0.5));
annotation (
  __Dymola_Commands(
    file=
      "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Boilers/HotWater/Validation/BoilerPlant.mos"
      "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
  Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant\">
Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant</a>
by simulating a <i>24</i>-hour period during which the heating loads reach
their peak value.
</p>
<p>
Two equally sized condensing boilers are modeled.
A unique aggregated load is modeled on the HW loop by means of a cooling
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
staging or unstaging the boilers,
</li>
<li>
resetting the supply temperature based on the valve position,
</li>
<li>
staging and controlling the primary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
<p>
A Python script is provided with this model to test all supported system
configurations, see
<code>Buildings/Resources/Scripts/travis/templates/BoilerPlant.py</code>.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-160},{200,160}})));
end BoilerPlant;
