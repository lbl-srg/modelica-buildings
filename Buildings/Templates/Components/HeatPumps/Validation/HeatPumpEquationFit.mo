within Buildings.Templates.Components.HeatPumps.Validation;
model HeatPumpEquationFit
  "Validation model for heat pump component with equation fit model"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Buildings.Templates.Components.Data.HeatPump datHpAwNrv(
    final cpHeaWat_default=hpAwNrv.cpHeaWat_default,
    final cpSou_default=hpAwNrv.cpSou_default,
    final typ=hpAwNrv.typ,
    final is_rev=hpAwNrv.is_rev,
    final typMod=hpAwNrv.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal/abs(datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    perFit(hea(
        P=datHpAwNrv.capHea_nominal/Buildings.Templates.Data.Defaults.COPHpAwHea,
        coeQ={-4.2670305442,-0.7381077035,6.0049480456,0,0},
        coeP={-4.9107455513,5.3665308366,0.5447612754,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpHeaLow)))
    "Non-reversible AWHP parameters"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));

  parameter Buildings.Templates.Components.Data.HeatPump datHpAw(
    final cpHeaWat_default=hpAw.cpHeaWat_default,
    final cpSou_default=hpAw.cpSou_default,
    final typ=hpAw.typ,
    final is_rev=hpAw.is_rev,
    final typMod=hpAw.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal/abs(datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHpAw.capCoo_nominal/abs(datHpAw.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    perFit(hea(
        P=datHpAw.capHea_nominal/Buildings.Templates.Data.Defaults.COPHpAwHea,
        coeQ={-4.2670305442,-0.7381077035,6.0049480456,0,0},
        coeP={-4.9107455513,5.3665308366,0.5447612754,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpHeaLow), coo(
        P=datHpAw.capCoo_nominal/Buildings.Templates.Data.Defaults.COPHpAwCoo,
        coeQ={-2.2545246871,6.9089257665,-3.6548225094,0,0},
        coeP={-5.8086010402,1.6894933858,5.1167787436,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.TChiWatRet,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpCoo)))
    "Reversible AWHP parameters parameters"
    annotation (Placement(transformation(extent={{120,22},{140,42}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=datHpAw.TChiWatSup_nominal,
      y(final unit="K", displayUnit="degC")) "CHWST setpoint" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,120})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(k=datHpAw.THeaWatSup_nominal,
      y(final unit="K", displayUnit="degC")) "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));
  AirToWater hpAw(
    is_rev=true,
    show_T=true,
    redeclare final package MediumHeaWat = Medium,
    final dat=datHpAw,
    final energyDynamics=energyDynamics) "Reversible AWHP"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=datHpAw.THeaWatSup_nominal - datHpAw.THeaWatRet_nominal,
    freqHz=3/3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.THeaWatRet_nominal,
    startTime=0) "HW return temperature value"
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
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
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=3)
    "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{190,30},{170,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHpAw.TChiWatRet_nominal - datHpAw.TChiWatSup_nominal,
    freqHz=3/3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.TChiWatRet_nominal,
    startTime=0) "CHW return temperature value"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=3) "Boundary conditions of CHW/HW at HP inlet"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl(
    k=sup.p + hpAw.dpHeaWat_nominal)
    "HW inlet pressure"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hpAw.dpChiWat_nominal)
    "CHW inlet pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-80,-40})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={180,140})));
  Fluid.Sensors.TemperatureTwoPort TRet(redeclare final package Medium = Medium,
      final m_flow_nominal=datHpAw.mChiWat_flow_nominal) "Return temperature"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  AirToWater hpAwNrv(
    is_rev=false,
    final energyDynamics=energyDynamics,
    final dat=datHpAwNrv) "Non reversible AWHP"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Fluid.Sensors.TemperatureTwoPort TRet1(redeclare final package Medium =
        Medium, final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Fluid.Sensors.TemperatureTwoPort TSup1(redeclare final package Medium =
        Medium, final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{130,70},{150,90}})));
  WaterToWater hpWw(
    is_rev=true,
    show_T=true,
    redeclare final package MediumHeaWat = Medium,
    final dat=datHpWw,
    final energyDynamics=energyDynamics) "Reversible WWHP"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  parameter Data.HeatPump datHpWw(
    final cpHeaWat_default=hpWw.cpHeaWat_default,
    final cpSou_default=hpWw.cpSou_default,
    final typ=hpWw.typ,
    final is_rev=hpWw.is_rev,
    final typMod=hpWw.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal/abs(datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHpAw.capCoo_nominal/abs(datHpAw.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TSouHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TSouHpHea,
    dpSouWatHea_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    mSouWatCoo_flow_nominal=datHpWw.mSouWatHea_flow_nominal,
    mSouWatHea_flow_nominal=datHpWw.mHeaWat_flow_nominal,
    perFit(hea(
        P=datHpAw.capHea_nominal/Buildings.Templates.Data.Defaults.COPHpWwHea,
        coeQ={-4.2670305442,-0.7381077035,6.0049480456,0,0},
        coeP={-4.9107455513,5.3665308366,0.5447612754,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TSouHpHea), coo(
        P=datHpAw.capCoo_nominal/Buildings.Templates.Data.Defaults.COPHpWwCoo,
        coeQ={-2.2545246871,6.9089257665,-3.6548225094,0,0},
        coeP={-5.8086010402,1.6894933858,5.1167787436,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.TChiWatRet,
        TRefSou=Buildings.Templates.Data.Defaults.TSouHpCoo)))
    "Reversible WWHP parameters parameters"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Fluid.Sensors.TemperatureTwoPort TRet2(redeclare final package Medium =
        Medium, final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Fluid.Sensors.TemperatureTwoPort TSup2(redeclare final package Medium =
        Medium, final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{130,-90},{150,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouHea(
    y(final unit="K", displayUnit="degC"),
    height=4,
    duration=500,
    offset=datHpWw.TSouHea_nominal,
    startTime=2400) "Source fluid supply temperature value"
    annotation (Placement(transformation(extent={{-92,-90},{-72,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouCoo(
    y(final unit="K", displayUnit="degC"),
    height=-4,
    duration=500,
    offset=datHpWw.TSouCoo_nominal,
    startTime=1400) "Source fluid supply temperature value"
    annotation (Placement(transformation(extent={{-92,-130},{-72,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSouAct
    "Active source fluid supply temperature"
    annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel1
    "Active inlet gaupe pressure"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlHea(k=retSou.p +
        hpWw.dpSouHea_nominal) "Source fluid inlet pressure"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlCoo(k=retSou.p +
        hpWw.dpSouCoo_nominal) "Source fluid inlet pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-160})));
  Fluid.Sources.Boundary_pT inlHpSou(
    redeclare final package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) "Boundary conditions or source side fluid at HP inlet"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Fluid.Sources.Boundary_pT retSou(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at source system return"
    annotation (Placement(transformation(extent={{190,-130},{170,-110}})));
protected
  Interfaces.Bus bus "HP control bus"
    annotation (Placement(transformation(extent={{60,20},{100,60}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
protected
  Interfaces.Bus bus1 "HP control bus"
    annotation (Placement(transformation(extent={{60,100},{100,140}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
protected
  Interfaces.Bus bus2 "HP control bus"
    annotation (Placement(transformation(extent={{60,-60},{100,-20}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
equation
  connect(y1Hea.y[1], TSetAct.u2)
    annotation (Line(points={{-158,100},{-42,100}},color={255,0,255}));
  connect(TChiWatSupSet.y, TSetAct.u3)
    annotation (Line(points={{-68,120},{-64,120},{-64,92},{-42,92}},color={0,0,127}));
  connect(THeaWatSupSet.y, TSetAct.u1)
    annotation (Line(points={{-68,160},{-60,160},{-60,108},{-42,108}},color={0,0,127}));
  connect(TSup.port_b, sup.ports[1])
    annotation (Line(points={{150,0},{170,0},{170,38.6667}},color={0,127,255}));
  connect(THeaWatRet.y, TRetAct.u1)
    annotation (Line(points={{-68,82},{-60,82},{-60,68},{-42,68}},color={0,0,127}));
  connect(y1Hea.y[1], TRetAct.u2)
    annotation (Line(points={{-158,100},{-50,100},{-50,60},{-42,60}},color={255,0,255}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation (Line(points={{-68,40},{-50,40},{-50,52},{-42,52}},color={0,0,127}));
  connect(hpAw.port_b, TSup.port_a)
    annotation (Line(points={{120,0},{130,0}},color={0,127,255}));
  connect(TRetAct.y, inlHp.T_in) annotation (Line(points={{-18,60},{-10,60},{-10,
          4},{8,4}}, color={0,0,127}));
  connect(y1Hea.y[1], bus.y1Hea)
    annotation (Line(points={{-158,100},{-50,100},{-50,120},{80,120},{80,40}},
      color={255,0,255}));
  connect(y1.y[1], bus.y1)
    annotation (Line(points={{-158,140},{-50,140},{-50,120},{80,120},{80,40}},
      color={255,0,255}));
  connect(TSetAct.y, bus.TSet)
    annotation (Line(points={{-18,100},{80,100},{80,40.1},{80.1,40.1}},color={0,0,127}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation (Line(points={{-18,-20},{0,-20},{0,8},{8,8}}, color={0,0,127}));
  connect(pHeaWatInl.y, pInl_rel.u1)
    annotation (Line(points={{-68,0},{-58,0},{-58,-12},{-42,-12}},color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation (Line(points={{-68,-40},{-46,-40},{-46,-28},{-42,-28}},color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel.u2)
    annotation (Line(points={{-158,100},{-158,100.526},{-50,100.526},{-50,-20},{-42,-20}},
      color={255,0,255}));
  connect(bus, hpAw.bus)
    annotation (Line(points={{80,40},{110,40},{110,10}},color={255,204,51},thickness=0.5));
  connect(weaDat.weaBus, hpAw.busWea)
    annotation (Line(points={{170,140},{160,140},{160,16},{104,16},{104,10}},
      color={255,204,51},thickness=0.5));
  connect(inlHp.ports[1], TRet.port_a) annotation (Line(points={{30,-1.33333},{
          40,-1.33333},{40,0},{50,0}}, color={0,127,255}));
  connect(TRet.port_b, hpAw.port_a)
    annotation (Line(points={{70,0},{100,0}},color={0,127,255}));
  connect(bus1, hpAwNrv.bus)
    annotation (Line(points={{80,120},{110,120},{110,90}},color={255,204,51},thickness=0.5));
  connect(y1.y[1], bus1.y1)
    annotation (Line(points={{-158,140},{-50,140},{-50,120},{80,120}},color={255,0,255}));
  connect(hpAwNrv.port_b, TSup1.port_a)
    annotation (Line(points={{120,80},{130,80}},color={0,127,255}));
  connect(TRet1.port_b, hpAwNrv.port_a)
    annotation (Line(points={{70,80},{100,80}},color={0,127,255}));
  connect(TSup1.port_b, sup.ports[2])
    annotation (Line(points={{150,80},{170,80},{170,40}},color={0,127,255}));
  connect(inlHp.ports[2], TRet1.port_a) annotation (Line(points={{30,0},{40,0},
          {40,80},{50,80}}, color={0,127,255}));
  connect(weaDat.weaBus, hpAwNrv.busWea)
    annotation (Line(points={{170,140},{160,140},{160,94},{104,94},{104,90}},
      color={255,204,51},thickness=0.5));
  connect(THeaWatSupSet.y, bus1.TSet)
    annotation (Line(points={{-68,160},{80.1,160},{80.1,120.1}},color={0,0,127}));
  connect(hpWw.port_b, TSup2.port_a)
    annotation (Line(points={{120,-80},{130,-80}}, color={0,127,255}));
  connect(TSup2.port_b, sup.ports[3])
    annotation (Line(points={{150,-80},{170,-80},{170,41.3333}},color={0,127,255}));
  connect(TRet2.port_b, hpWw.port_a)
    annotation (Line(points={{70,-80},{100,-80}}, color={0,127,255}));
  connect(inlHp.ports[3], TRet2.port_a) annotation (Line(points={{30,1.33333},{
          30,0},{40,0},{40,-80},{50,-80}}, color={0,127,255}));
  connect(bus2, hpWw.bus) annotation (Line(
      points={{80,-40},{110,-40},{110,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(TSouHea.y, TSouAct.u1)
    annotation (Line(points={{-70,-80},{-56,-80},{-56,-74},{-42,-74}},color={0,0,127}));
  connect(y1Hea.y[1], TSouAct.u2)
    annotation (Line(points={{-158,100},{-50,100},{-50,-82},{-42,-82}},color={255,0,255}));
  connect(TSouCoo.y, TSouAct.u3)
    annotation (Line(points={{-70,-120},{-46,-120},{-46,-90},{-42,-90}},color={0,0,127}));
  connect(pSouInlHea.y, pInl_rel1.u1)
    annotation (Line(points={{-108,-120},{-102,-120},{-102,-140},{-60,-140},{-60,-132},{-42,-132}},
      color={0,0,127}));
  connect(pSouInlCoo.y, pInl_rel1.u3)
    annotation (Line(points={{-108,-160},{-60,-160},{-60,-148},{-42,-148}},color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel1.u2)
    annotation (Line(points={{-158,100},{-50,100},{-50,-140},{-42,-140}},color={255,0,255}));
  connect(inlHpSou.ports[1], hpWw.port_aSou) annotation (Line(points={{30,-100},
          {120,-100},{120,-90}}, color={0,127,255}));
  connect(retSou.ports[1], hpWw.port_bSou) annotation (Line(points={{170,-120},
          {80,-120},{80,-90},{100,-90}}, color={0,127,255}));
  connect(TSouAct.y, inlHpSou.T_in) annotation (Line(points={{-18,-82},{0,-82},
          {0,-96},{8,-96}}, color={0,0,127}));
  connect(pInl_rel1.y, inlHpSou.p_in) annotation (Line(points={{-18,-140},{-20,
          -140},{-20,-92},{8,-92}}, color={0,0,127}));
  connect(TSetAct.y, bus2.TSet)
    annotation (Line(points={{-18,100},{80,100},{80,50},{80.1,50},{80.1,-39.9}},
      color={0,0,127}));
  connect(y1.y[1], bus2.y1)
    annotation (Line(points={{-158,140},{-50,140},{-50,-40},{80,-40}},color={255,0,255}));
  connect(y1Hea.y[1], bus2.y1Hea)
    annotation (Line(points={{-158,100},{-50,100},{-50,-40},{80,-40}},color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-200,-180},{200,180}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/HeatPumps/Validation/HeatPumpEquationFit.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StartTime=10497600.0,
      StopTime=10505600.0),
    Documentation(
      info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Components.HeatPumps.AirToWater>
Buildings.Templates.Components.HeatPumps.AirToWater</a>
in a configuration in which the heat pump components are exposed
to a constant differential pressure and a varying
return temperature.
</p>
<p>
The model is configured to represent either a non-reversible heat pump
(suffix <code>Nrv</code>) or a reversible heat pump
that switches between cooling and heating mode.
</p>
<p>
It can be seen that the HW supply temperature setpoint is not met
at minimum HW return temperature because the outdoor air temperature
is below the heat pump selection conditions.
</p>
</html>"));
end HeatPumpEquationFit;
