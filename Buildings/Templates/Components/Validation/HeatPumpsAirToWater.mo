within Buildings.Templates.Components.Validation;
model HeatPumpsAirToWater
  "Validation model for air-to-water heat pump components"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.HeatPump datHeaPumNonRev(
    typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    is_rev=false,
    typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    mHeaWat_flow_nominal=datHeaPumNonRev.capHea_nominal/
      abs(Buildings.Templates.Data.Defaults.THeaWatSupMed-
      Buildings.Templates.Data.Defaults.THeaWatRetMed)/
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    per(hea(
        P=datHeaPumNonRev.capHea_nominal/Buildings.Templates.Data.Defaults.COPHeaPumAirWatHea,
        coeQ={-4.2670305442,-0.7381077035,6.0049480456,0,0},
        coeP={-4.9107455513,5.3665308366,0.5447612754,0,0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHeaPumHeaLow)))
    "Non-reversible heat pump parameters"
    annotation (Placement(transformation(extent={{120,-28},{140,-8}})));

  parameter Buildings.Templates.Components.Data.HeatPump datHeaPumRev(
    typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    is_rev=true,
    typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    mHeaWat_flow_nominal=datHeaPumRev.capHea_nominal/
      abs(Buildings.Templates.Data.Defaults.THeaWatSupMed-
      Buildings.Templates.Data.Defaults.THeaWatRetMed)/
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHeaPumRev.capCoo_nominal/
      abs(Buildings.Templates.Data.Defaults.TChiWatSup-
      Buildings.Templates.Data.Defaults.TChiWatRet)/
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    per(
      hea(
        P=datHeaPumRev.capHea_nominal/Buildings.Templates.Data.Defaults.COPHeaPumAirWatHea,
        coeQ={-4.2670305442, -0.7381077035, 6.0049480456, 0, 0},
        coeP={-4.9107455513, 5.3665308366, 0.5447612754, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHeaPumHeaLow),
      coo(
        P=datHeaPumRev.capCoo_nominal/Buildings.Templates.Data.Defaults.COPHeaPumAirWatCoo,
        coeQ={-2.2545246871, 6.9089257665, -3.6548225094, 0, 0},
        coeP={-5.8086010402, 1.6894933858, 5.1167787436, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.TChiWatRet,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHeaPumCoo)))
    "Reversible heat pump parameters"
    annotation (Placement(transformation(extent={{120,-108},{140,-88}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=datHeaPumRev.TChiWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
    "CHWST setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,20})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=datHeaPumRev.THeaWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Templates.Components.HeatPumps.AirToWater heaPumRev(
    redeclare final package MediumHeaWat=Medium,
    final dat=datHeaPumRev,
    final is_rev=true,
    final energyDynamics=energyDynamics)
    "Reversible heat pump"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Fluid.Sources.Boundary_pT inlHeaPum(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325 +
        datHeaPumNonRev.dpHeaWat_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions at HP inlet"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datHeaPumRev.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp THeaWatRet(
    y(final unit="K", displayUnit="degC"),
    height=4,
    duration=500,
    offset=datHeaPumRev.per.hea.TRefLoa,
    startTime=2400) "HW return temperature value"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 0.5,1],
    timeScale=1000,
    period=3000) "Heat pump Enable signal"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Fluid.Sensors.TemperatureTwoPort TSup1(
    redeclare final package Medium =Medium,
    final m_flow_nominal=datHeaPumRev.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Hea(
    table=[0,0; 2,1],
    timeScale=1000,
    period=3000) "Heat pump heating mode signal"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSetAct(
    y(final unit="K", displayUnit="degC"))
    "Active supply temperature setpoint"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2) "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  HeatPumps.AirToWater heaPumNonRev(
    redeclare final package MediumHeaWat=Medium,
    final dat=datHeaPumNonRev,
    final is_rev=false,
    final energyDynamics=energyDynamics)
    "Non-reversible heat pump"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatRet(
    y(final unit="K", displayUnit="degC"),
    height=-4,
    duration=500,
    offset=datHeaPumRev.per.coo.TRefLoa,
    startTime=1400)
    "CHW return temperature value"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Fluid.Sources.Boundary_pT inlHeaPum1(
    redeclare final package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) "Boundary conditions at HP inlet"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct "Active return temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWat_rel(
    k=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal
     + 101325 + heaPumRev.dpHeaWat_nominal)
    "HW inlet pressure"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWat_rel(
    k=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal
         + 101325 + heaPumRev.dpChiWat_nominal)
    "CHW inlet pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-140})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{30,50},{10,70}})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datHeaPumRev.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Fluid.Sensors.TemperatureTwoPort TRet1(
    redeclare final package Medium =Medium,
    final m_flow_nominal=datHeaPumRev.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
protected
  Interfaces.Bus bus
    "HP control bus"
    annotation (Placement(transformation(
          extent={{-60,0},{-20,40}}),  iconTransformation(extent={{-276,6},{-236,
            46}})));
  Interfaces.Bus bus1
    "HP control bus"
    annotation (Placement(transformation(
          extent={{-60,-80},{-20,-40}}), iconTransformation(extent={{-276,6},{-236,
            46}})));
equation
  connect(y1Hea.y[1], TSetAct.u2) annotation (Line(points={{-118,100},{-100,100},
          {-100,40},{-92,40}},  color={255,0,255}));
  connect(TChiWatSupSet.y, TSetAct.u3) annotation (Line(points={{-118,20},{-100,
          20},{-100,32},{-92,32}},  color={0,0,127}));
  connect(THeaWatSupSet.y, TSetAct.u1) annotation (Line(points={{-118,60},{-110,
          60},{-110,48},{-92,48}},  color={0,0,127}));
  connect(TSup.port_b, sup.ports[1]) annotation (Line(points={{90,-20},{100,-20},
          {100,-61},{120,-61}},
                           color={0,127,255}));
  connect(TSup1.port_b, sup.ports[2]) annotation (Line(points={{90,-100},{100,-100},
          {100,-59},{120,-59}},color={0,127,255}));
  connect(THeaWatRet.y, TRetAct.u1) annotation (Line(points={{-118,-20},{-110,-20},
          {-110,-32},{-92,-32}}, color={0,0,127}));
  connect(y1Hea.y[1], TRetAct.u2) annotation (Line(points={{-118,100},{-100,100},
          {-100,-40},{-92,-40}},  color={255,0,255}));
  connect(TChiWatRet.y, TRetAct.u3) annotation (Line(points={{-118,-60},{-100,-60},
          {-100,-48},{-92,-48}},  color={0,0,127}));
  connect(heaPumNonRev.port_b, TSup.port_a)
    annotation (Line(points={{60,-20},{70,-20}},
                                             color={0,127,255}));
  connect(heaPumRev.port_b, TSup1.port_a)
    annotation (Line(points={{60,-100},{70,-100}},
                                                 color={0,127,255}));
  connect(THeaWatSupSet.y, bus.TSet) annotation (Line(points={{-118,60},{-40,60},
          {-40,20}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(THeaWatRet.y, inlHeaPum.T_in) annotation (Line(points={{-118,-20},{-46,
          -20},{-46,-16},{-32,-16}},
                            color={0,0,127}));
  connect(TRetAct.y, inlHeaPum1.T_in) annotation (Line(points={{-68,-40},{-64,-40},
          {-64,-96},{-32,-96}}, color={0,0,127}));
  connect(y1Hea.y[1], bus1.y1Heat) annotation (Line(points={{-118,100},{-54,100},
          {-54,-56},{-40,-56},{-40,-60}}, color={255,0,255}));
  connect(y1.y[1], bus.y1) annotation (Line(points={{-118,140},{-40,140},{-40,20}},
        color={255,0,255}));
  connect(y1.y[1], bus1.y1) annotation (Line(points={{-118,140},{-40,140},{-40,-60}},
        color={255,0,255}));
  connect(TSetAct.y, bus1.TSet) annotation (Line(points={{-68,40},{-60,40},{-60,
          -60},{-40,-60}}, color={0,0,127}));
  connect(pInl_rel.y, inlHeaPum1.p_in) annotation (Line(points={{-68,-120},{-40,
          -120},{-40,-92},{-32,-92}}, color={0,0,127}));
  connect(pHeaWat_rel.y, pInl_rel.u1) annotation (Line(points={{-118,-100},{-108,
          -100},{-108,-112},{-92,-112}},
                                       color={0,0,127}));
  connect(pChiWat_rel.y, pInl_rel.u3) annotation (Line(points={{-118,-140},{-100,
          -140},{-100,-128},{-92,-128}},  color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel.u2) annotation (Line(points={{-118,100},{-118,100.526},
          {-100,100.526},{-100,-120},{-92,-120}},  color={255,0,255}));
  connect(bus, heaPumNonRev.bus) annotation (Line(
      points={{-40,20},{50,20},{50,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(bus1, heaPumRev.bus) annotation (Line(
      points={{-40,-60},{50,-60},{50,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, heaPumNonRev.busWea) annotation (Line(
      points={{10,60},{0,60},{0,-10},{44,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, heaPumRev.busWea) annotation (Line(
      points={{10,60},{0,60},{0,-90},{44,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHeaPum.ports[1], TRet.port_a)
    annotation (Line(points={{-10,-20},{10,-20}},
                                               color={0,127,255}));
  connect(TRet.port_b, heaPumNonRev.port_a)
    annotation (Line(points={{30,-20},{40,-20}},
                                             color={0,127,255}));
  connect(inlHeaPum1.ports[1], TRet1.port_a)
    annotation (Line(points={{-10,-100},{10,-100}},color={0,127,255}));
  connect(TRet1.port_b, heaPumRev.port_a) annotation (Line(points={{30,-100},{40,
          -100}},                  color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-160},{160,160}})),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/HeatPumpsAirToWater.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=3000),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Components.HeatPumps.AirToWater\">
Buildings.Templates.Components.HeatPumps.AirToWater</a>
in a configuration in which the heat pump components are exposed
to a constant differential pressure and a varying
return temperature.
</p>
<p>
The model is configured to represent either a non-reversible heat pump
(component <code>heaPumNonRev</code>) or a reversible heat pump
(component <code>heaPumRev</code>) that switches between cooling and heating
mode.
</p>
<p>
It can be seen that the HW supply temperature setpoint is not met
at minimum HW return temperature because the outdoor air temperature 
is below the heat pump selection conditions.
</p>
</html>"));
end HeatPumpsAirToWater;
