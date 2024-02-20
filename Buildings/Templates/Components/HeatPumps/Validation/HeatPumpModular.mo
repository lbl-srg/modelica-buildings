within Buildings.Templates.Components.HeatPumps.Validation;
model HeatPumpModular
  "Validation model for heat pump component with modular model"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW and source fluid medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Data.HeatPump datHpAw(
    final cpHeaWat_default=hpAw.cpHeaWat_default,
    final cpSou_default=hpAw.cpSou_default,
    final typ=hpAw.typ,
    final is_rev=hpAw.is_rev,
    final typMod=hpAw.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal/abs(datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHea_nominal=5E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHpAw.capCoo_nominal/abs(datHpAw.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=5E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaHig,
    redeclare
      Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
      modHea,
    redeclare
      Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
      modCoo) "AWHP performance data"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=datHpAw.TChiWatSup_nominal,
      y(final unit="K", displayUnit="degC")) "CHWST setpoint" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,20})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(k=datHpAw.THeaWatSup_nominal,
      y(final unit="K", displayUnit="degC")) "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Templates.Components.HeatPumps.AirToWaterReversible hpAw(
    hp(use_intSafCtr=false),
    show_T=true,
    redeclare final package MediumHeaWat = Medium,
    final dat=datHpAw,
    final energyDynamics=energyDynamics) "AWHP"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=datHpAw.THeaWatSup_nominal - datHpAw.THeaWatRet_nominal,
    freqHz=3/3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.THeaWatRet_nominal,
    startTime=0) "HW return temperature value"
    annotation (Placement(transformation(extent={{-90,-28},{-70,-8}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[
      0, 0;
      0.5, 1],
    timeScale=1000,
    period=3000)
    "Heat pump Enable signal"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Fluid.Sensors.TemperatureTwoPort TSup(redeclare final package Medium = Medium,
      final m_flow_nominal=datHpAw.mChiWat_flow_nominal) "Supply temperature"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Hea(
    table=[
      0, 0;
      2, 1],
    timeScale=1000,
    period=3000)
    "Heat pump heating mode signal"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSetAct(
    y(final unit="K",
      displayUnit="degC"))
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{190,30},{170,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHpAw.TChiWatRet_nominal - datHpAw.TChiWatSup_nominal,
    freqHz=3/3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.TChiWatRet_nominal,
    startTime=0) "CHW return temperature value"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=2) "Boundary conditions of CHW/HW at HP inlet"
    annotation (Placement(transformation(extent={{10,-54},{30,-34}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl(
    k=sup.p + hpAw.dpHeaWat_nominal)
    "HW inlet pressure"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hpAw.dpChiWat_nominal)
    "CHW inlet pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-80,-140})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Fluid.Sensors.TemperatureTwoPort TRet(redeclare final package Medium = Medium,
      final m_flow_nominal=datHpAw.mChiWat_flow_nominal) "Return temperature"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  WaterToWaterReversible hpWw(
    final energyDynamics=energyDynamics,
    final dat=datHpWw,
    have_preDroChiHeaWat=false,
    have_preDroSou=false)
    "WWHP - CHW/HW and source fluid pressure drops computed externally"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  parameter Data.HeatPump datHpWw(
    final cpHeaWat_default=hpWw.cpHeaWat_default,
    final cpSou_default=hpWw.cpSou_default,
    final typ=hpWw.typ,
    final is_rev=hpWw.is_rev,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.ModularTableData2D,
    mHeaWat_flow_nominal=datHpWw.capHea_nominal/abs(datHpWw.THeaWatSup_nominal
         - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHea_nominal=5E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHpWw.capCoo_nominal/abs(datHpWw.TChiWatSup_nominal
         - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=5E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    mSouWwHea_flow_nominal=(Buildings.Templates.Data.Defaults.COPHpWwHea - 1)
        /Buildings.Templates.Data.Defaults.COPHpWwHea*datHpWw.mHeaWat_flow_nominal,
    dpSouWwHea_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TSouHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TSouHpHea,
    mSouWwCoo_flow_nominal=(Buildings.Templates.Data.Defaults.COPHpWwCoo + 1)
        /Buildings.Templates.Data.Defaults.COPHpWwCoo*datHpWw.mChiWat_flow_nominal,
    redeclare
      Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
      modHea,
    redeclare
      Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
      modCoo) "WWHP performance data"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Fluid.Sources.Boundary_pT inlHpSou(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) "Boundary conditions of source fluid at HP inlet"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Fluid.Sources.Boundary_pT retSou(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at source system return"
    annotation (Placement(transformation(extent={{190,-120},{170,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouHea(
    y(final unit="K", displayUnit="degC"),
    height=4,
    duration=500,
    offset=datHpWw.TSouHea_nominal,
    startTime=2400) "Source fluid supply temperature value"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouCoo(
    y(final unit="K", displayUnit="degC"),
    height=-4,
    duration=500,
    offset=datHpWw.TSouCoo_nominal,
    startTime=1400) "Source fluid supply temperature value"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSouAct
    "Active source fluid supply temperature"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel1
    "Active inlet gaupe pressure"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlHea(k=retSou.p +
        hpWw.dpSouHea_nominal) "Source fluid inlet pressure"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlCoo(k=retSou.p +
        hpWw.dpSouCoo_nominal) "Source fluid inlet pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-100})));
  Fluid.Sensors.TemperatureTwoPort TRet1(redeclare final package Medium =
        Medium, final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Fluid.Sensors.TemperatureTwoPort TSup1(redeclare final package Medium =
        Medium, final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{130,-90},{150,-70}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpWw.mHeaWat_flow_nominal,
    final dp_nominal=datHpWw.dpHeaWat_nominal)
    "CHW/HW pressure drop computed externally"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Fluid.FixedResistances.PressureDrop resSou(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpWw.mSouWwHea_flow_nominal,
    final dp_nominal=datHpWw.dpSouWwHea_nominal)
    "Source fluid pressure drop computed externally"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
protected
  Interfaces.Bus bus
    "HP control bus"
    annotation (Placement(transformation(extent={{60,20},{100,60}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
protected
  Interfaces.Bus bus1
    "HP control bus"
    annotation (Placement(transformation(extent={{60,-60},{100,-20}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
equation
  connect(y1Hea.y[1], TSetAct.u2)
    annotation (Line(points={{-158,100},{-50,100},{-50,60},{-42,60}},color={255,0,255}));
  connect(TChiWatSupSet.y, TSetAct.u3)
    annotation (Line(points={{-68,20},{-60,20},{-60,52},{-42,52}},color={0,0,127}));
  connect(THeaWatSupSet.y, TSetAct.u1)
    annotation (Line(points={{-68,60},{-60,60},{-60,68},{-42,68}},color={0,0,127}));
  connect(TSup.port_b, sup.ports[1])
    annotation (Line(points={{150,0},{160,0},{160,39},{170,39}},        color={0,127,255}));
  connect(THeaWatRet.y, TRetAct.u1)
    annotation (Line(points={{-68,-18},{-60,-18},{-60,-32},{-42,-32}},color={0,0,127}));
  connect(y1Hea.y[1], TRetAct.u2)
    annotation (Line(points={{-158,100},{-50,100},{-50,-40},{-42,-40}},color={255,0,255}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation (Line(points={{-68,-60},{-60,-60},{-60,-48},{-42,-48}},color={0,0,127}));
  connect(hpAw.port_b, TSup.port_a)
    annotation (Line(points={{120,0},{130,0}},      color={0,127,255}));
  connect(TRetAct.y, inlHp.T_in)
    annotation (Line(points={{-18,-40},{8,-40}},                    color={0,0,127}));
  connect(y1Hea.y[1], bus.y1Heat)
    annotation (Line(points={{-158,100},{80,100},{80,40}}, color={255,0,255}));
  connect(y1.y[1], bus.y1)
    annotation (Line(points={{-158,140},{80,140},{80,40}}, color={255,0,255}));
  connect(TSetAct.y, bus.TSet)
    annotation (Line(points={{-18,60},{80,60},{80,40.1},{80.1,40.1}},  color={0,0,127}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation (Line(points={{-18,-120},{-4,-120},{-4,-36},{8,-36}},
                                                                  color={0,0,127}));
  connect(pHeaWatInl.y, pInl_rel.u1)
    annotation (Line(points={{-68,-100},{-60,-100},{-60,-112},{-42,-112}},color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation (Line(points={{-68,-140},{-60,-140},{-60,-128},{-42,-128}},color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel.u2)
    annotation (Line(points={{-158,100},{-158,100.526},{-50,100.526},{-50,-120},{-42,-120}},
      color={255,0,255}));
  connect(bus, hpAw.bus)
    annotation (Line(points={{80,40},{110,40},{110,10}},   color={255,204,51},thickness=0.5));
  connect(weaDat.weaBus, hpAw.busWea)
    annotation (Line(points={{30,30},{104,30},{104,10}},   color={255,204,51},thickness=0.5));
  connect(inlHp.ports[1], TRet.port_a)
    annotation (Line(points={{30,-45},{40,-45},{40,0},{50,0}},        color={0,127,255}));
  connect(TRet.port_b, hpAw.port_a)
    annotation (Line(points={{70,0},{100,0}},      color={0,127,255}));
  connect(bus1, hpWw.bus) annotation (Line(
      points={{80,-40},{110,-40},{110,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(retSou.ports[1], hpWw.port_bSou) annotation (Line(points={{170,-110},
          {96,-110},{96,-90},{100,-90}},
                                       color={0,127,255}));
  connect(y1.y[1], bus1.y1)
    annotation (Line(points={{-158,140},{80,140},{80,-40}},
                                                          color={255,0,255}));
  connect(y1Hea.y[1], bus1.y1Heat)
    annotation (Line(points={{-158,100},{80,100},{80,-40}},
                                                          color={255,0,255}));
  connect(TSetAct.y, bus1.TSet)
    annotation (Line(points={{-18,60},{46,60},{46,-39.9},{80.1,-39.9}},
                                                                     color={0,0,127}));
  connect(TSouHea.y, TSouAct.u1)
    annotation (Line(points={{-158,20},{-150,20},{-150,8},{-132,8}},color={0,0,127}));
  connect(y1Hea.y[1], TSouAct.u2)
    annotation (Line(points={{-158,100},{-140,100},{-140,0},{-132,0}},color={255,0,255}));
  connect(TSouCoo.y, TSouAct.u3)
    annotation (Line(points={{-158,-20},{-140,-20},{-140,-8},{-132,-8}},color={0,0,127}));
  connect(pSouInlHea.y, pInl_rel1.u1)
    annotation (Line(points={{-158,-60},{-148,-60},{-148,-72},{-132,-72}},color={0,0,127}));
  connect(pSouInlCoo.y, pInl_rel1.u3)
    annotation (Line(points={{-158,-100},{-140,-100},{-140,-88},{-132,-88}},
      color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel1.u2)
    annotation (Line(points={{-158,100},{-140,100},{-140,-80},{-132,-80}},color={255,0,255}));
  connect(pInl_rel1.y, inlHpSou.p_in)
    annotation (Line(points={{-108,-80},{0,-80},{0,-92},{8,-92}},color={0,0,127}));
  connect(TSouAct.y, inlHpSou.T_in)
    annotation (Line(points={{-108,0},{-10,0},{-10,-96},{8,-96}},color={0,0,127}));
  connect(hpWw.port_b, TSup1.port_a)
    annotation (Line(points={{120,-80},{130,-80}},
                                               color={0,127,255}));
  connect(TSup1.port_b, sup.ports[2])
    annotation (Line(points={{150,-80},{170,-80},{170,41}},
      color={0,127,255}));
  connect(inlHp.ports[2], TRet1.port_a)
    annotation (Line(points={{30,-43},{40,-43},{40,-80},{50,-80}},
                                                              color={0,127,255}));
  connect(TRet1.port_b, res.port_a)
    annotation (Line(points={{70,-80},{70,-80}},
                                             color={0,127,255}));
  connect(res.port_b, hpWw.port_a)
    annotation (Line(points={{90,-80},{100,-80}},
                                               color={0,127,255}));
  connect(inlHpSou.ports[1], resSou.port_a)
    annotation (Line(points={{30,-100},{70,-100}},
                                                 color={0,127,255}));
  connect(resSou.port_b, hpWw.port_aSou) annotation (Line(points={{90,-100},{
          124,-100},{124,-90},{120,-90}},
                                     color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-200,-180},{200,180}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/HeatPumps/Validation/HeatPumpModular.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StartTime=10497600.0,
      StopTime=10505600.0),
    Documentation(
      info="<html>
FIXME: safety controls disabled for now de to a bug,  see #6 in
https://docs.google.com/document/d/130SBzYK3YHHSzFvr5FyW_WOXmNGoXKzUJ3Wahq1rx9U/edit.
<br/>
FIXME: Performance data for modular model of WWHP (currently AWHP data).
<br/>
FIXME: Bug in computation of QCooNoSca_flow_nominal in ModularReversible. This yields
a net heating heat flow in cooling mode, see #1 in above document.
The design capacity is largely exceeded in cooling mode.
<br/>
FIXME: Using TOutHpHeaHig for now (instead of TOutHpHeaLow) due to a bug in HP model
that yields net heating heat flow rate in cooling mode! See
#1 in above document.
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Components.HeatPumps.AirToWaterReversible\">
Buildings.Templates.Components.HeatPumps.AirToWater</a>
in a configuration in which the heat pump components are exposed
to a constant differential pressure and a varying
return temperature.
</p>
<p>
The model is configured to represent either a non-reversible heat pump
(component <code>HpNonRev</code>) or a reversible heat pump
(component <code>HpRev</code>) that switches between cooling and heating
mode.
</p>
<p>
It can be seen that the HW supply temperature setpoint is not met
at minimum HW return temperature because the outdoor air temperature
is below the heat pump selection conditions.
</p>
</html>"));
end HeatPumpModular;
