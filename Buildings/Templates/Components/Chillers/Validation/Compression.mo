within Buildings.Templates.Components.Chillers.Validation;
model Compression
  "Validation model for compression chiller component"
  extends Modelica.Icons.Example;
  replaceable package MediumLiq=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW or CW medium";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Data.Chiller datChiAirCoo(
    final typ=chiAirCoo.typ,
    final use_datDes=true,
    mChiWat_flow_nominal=datChiAirCoo.cap_nominal / abs(datChiAirCoo.TChiWatSup_nominal -
      Buildings.Templates.Data.Defaults.TChiWatRet) / datChiAirCoo.cpChiWat_default,
    cap_nominal=750E3,
    COP_nominal=Buildings.Templates.Data.Defaults.COPChiAirCoo,
    dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TConEnt_nominal=Buildings.Templates.Data.Defaults.TOutChi,
    PLR_min=0.15,
    per(
      capFunT={0.0, 0.1, - 0.0023814154, 0.0628316481, - 0.0009644649, -
        0.0011249224},
      EIRFunT={0.0, 0.0071530312, - 0.0004553574, 0.0188175079, 0.0002623276, -
        0.0012881189},
      EIRFunPLR={- 5.497250E-01, 5.035076E-02, - 1.927855E-05, 1.678371E+00, -
        1.535993E+00, - 4.944902E-02, 0.000000E+00, 1.396972E+00, 0.000000E+00, 0.000000E+00},
      PLRMax=1.15,
      etaMotor=1.0))
    "Air-cooled chiller parameters – Parameterization based on design conditions and direct assignment of performance curves"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  parameter Buildings.Templates.Components.Data.Chiller datChiWatCoo(
    final typ=chiWatCoo.typ,
    final use_datDes=false,
    dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    dpCon_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    redeclare Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD per)
    "Water-cooled chiller parameters – Parameterization based on rating conditions specified in the sub-record per"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=datChiAirCoo.TChiWatSup_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "CHWST setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-110,80})));
  Buildings.Templates.Components.Chillers.Compression chiAirCoo(
    redeclare final package MediumChiWat=MediumLiq,
    redeclare final package MediumCon=MediumAir,
    final typ=Buildings.Templates.Components.Types.Chiller.AirCooled,
    show_T=true,
    final dat=datChiAirCoo,
    final energyDynamics=energyDynamics)
    "Air-cooled chiller"
    annotation (Placement(transformation(extent={{40,16},{20,36}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[
      0, 0;
      0.5, 1],
    timeScale=1000,
    period=3000)
    "Heat pump Enable signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=datChiAirCoo.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare final package Medium=MediumLiq,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at distribution system supply"
    annotation (Placement(transformation(extent={{130,10},{110,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=(datChiAirCoo.TChiWatRet_nominal - datChiAirCoo.TChiWatSup_nominal) /
      2,
    freqHz=2 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=datChiAirCoo.TChiWatSup_nominal +(datChiAirCoo.TChiWatRet_nominal -
      datChiAirCoo.TChiWatSup_nominal) / 2,
    startTime=0)
    "CHW return temperature value"
    annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  Fluid.Sources.Boundary_pT retChiWat(
    redeclare final package Medium=MediumLiq,
    p=supChiWat.p + chiAirCoo.dpChiWat_nominal,
    use_T_in=true,
    nPorts=1)
    "Boundary conditions of CHW at chiller inlet"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=datChiAirCoo.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Templates.Components.Chillers.Compression chiWatCoo(
    redeclare final package MediumChiWat=MediumLiq,
    redeclare final package MediumCon=MediumLiq,
    final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    show_T=true,
    final dat=datChiWatCoo,
    have_dpChiWat=false,
    have_dpCon=false,
    final energyDynamics=energyDynamics)
    "Water-cooled chiller - CHW/CW pressure drops computed externally"
    annotation (Placement(transformation(extent={{40,-104},{20,-84}})));
  Fluid.Sensors.TemperatureTwoPort TRet2(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=datChiAirCoo.mChiWat_flow_nominal)
    "Return temperature"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Fluid.Sensors.TemperatureTwoPort TSup2(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=datChiAirCoo.mChiWat_flow_nominal)
    "Supply temperature"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Fluid.Sources.Boundary_pT supConWat(
    redeclare final package Medium=MediumLiq,
    p=retConWat.p + chiWatCoo.dpCon_nominal,
    T=datChiWatCoo.TConEnt_nominal,
    nPorts=1)
    "Boundary conditions of CW at chiller inlet"
    annotation (Placement(transformation(extent={{130,-70},{110,-50}})));
  Fluid.Sources.Boundary_pT retConWat(
    redeclare final package Medium=MediumLiq,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition of CW at chiller outlet"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Fluid.FixedResistances.PressureDrop resChiWat(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=datChiWatCoo.mChiWat_flow_nominal,
    final dp_nominal=datChiWatCoo.dpChiWat_nominal)
    "CHW pressure drop computed externally"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Fluid.FixedResistances.PressureDrop resConWat(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=datChiWatCoo.mCon_flow_nominal,
    final dp_nominal=datChiWatCoo.dpCon_nominal)
    "CW pressure drop computed externally"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  Fluid.Sources.Boundary_pT sinAir(
    redeclare final package Medium=MediumAir,
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Fluid.Sources.MassFlowSource_T souAir(
    redeclare final package Medium=MediumAir,
    m_flow=datChiAirCoo.mCon_flow_nominal,
    T=datChiAirCoo.TConEnt_nominal,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{130,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet1(
    amplitude=(datChiWatCoo.TChiWatRet_nominal - datChiWatCoo.TChiWatSup_nominal) /
      2,
    freqHz=2 / 3000,
    y(final unit="K",
      displayUnit="degC"),
    offset=datChiWatCoo.TChiWatSup_nominal +(datChiAirCoo.TChiWatRet_nominal -
      datChiWatCoo.TChiWatSup_nominal) / 2,
    startTime=0)
    "CHW return temperature value"
    annotation (Placement(transformation(extent={{-120,-106},{-100,-86}})));
  Fluid.Sources.Boundary_pT retChiWat1(
    redeclare final package Medium=MediumLiq,
    p=supChiWat.p + chiAirCoo.dpChiWat_nominal,
    use_T_in=true,
    nPorts=1)
    "Boundary conditions of CHW at chiller inlet"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet1(
    k=datChiWatCoo.TChiWatSup_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "CHWST setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-110,-40})));
protected
  Interfaces.Bus bus
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-20,60},{20,100}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  Interfaces.Bus bus2
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
initial equation
  Modelica.Utilities.Streams.print("Coef at rating conditions = " + String(Buildings.Utilities.Math.Functions.biquadratic(
    a=datChiWatCoo.per.capFunT,
    x1=Modelica.Units.Conversions.to_degC(datChiWatCoo.per.TEvaLvg_nominal),
    x2=Modelica.Units.Conversions.to_degC(datChiWatCoo.per.TConLvg_nominal))));
equation
  connect(TSup.port_b, supChiWat.ports[1])
    annotation (Line(points={{70,20},{110,20},{110,19}},color={0,127,255}));
  connect(y1.y[1], bus.y1)
    annotation (Line(points={{-98,120},{0,120},{0,80}},color={255,0,255}));
  connect(bus, chiAirCoo.bus)
    annotation (Line(points={{0,80},{30,80},{30,36}},color={255,204,51},thickness=0.5));
  connect(retChiWat.ports[1], TRet.port_a)
    annotation (Line(points={{-50,20},{-40,20},{-40,20},{-30,20}},color={0,127,255}));
  connect(TSup2.port_b, supChiWat.ports[2])
    annotation (Line(points={{70,-100},{100,-100},{100,20},{110,20},{110,21}},
      color={0,127,255}));
  connect(bus2, chiWatCoo.bus)
    annotation (Line(points={{0,-40},{30,-40},{30,-84}},color={255,204,51},thickness=0.5));
  connect(y1.y[1], bus2.y1)
    annotation (Line(points={{-98,120},{0,120},{0,-40}},color={255,0,255}));
  connect(TRet2.port_b, resChiWat.port_a)
    annotation (Line(points={{-10,-100},{-10,-100}},color={0,127,255}));
  connect(supConWat.ports[1], resConWat.port_a)
    annotation (Line(points={{110,-60},{90,-60}},color={0,127,255}));
  connect(TRet.port_b, chiAirCoo.port_a2)
    annotation (Line(points={{-10,20},{20,20}},color={0,127,255}));
  connect(chiAirCoo.port_b2, TSup.port_a)
    annotation (Line(points={{40,20},{50,20}},color={0,127,255}));
  connect(chiWatCoo.port_b2, TSup2.port_a)
    annotation (Line(points={{40,-100},{50,-100}},color={0,127,255}));
  connect(resChiWat.port_b, chiWatCoo.port_a2)
    annotation (Line(points={{10,-100},{20,-100}},color={0,127,255}));
  connect(resConWat.port_b, chiWatCoo.port_a1)
    annotation (Line(points={{70,-60},{40,-60},{40,-88}},color={0,127,255}));
  connect(chiWatCoo.port_b1, retConWat.ports[1])
    annotation (Line(points={{20,-88},{20,-60},{-50,-60}},color={0,127,255}));
  connect(TChiWatRet.y, retChiWat.T_in)
    annotation (Line(points={{-98,24},{-72,24}},color={0,0,127}));
  connect(TChiWatSupSet.y, bus.TSupSet)
    annotation (Line(points={{-98,80},{0,80}},color={0,0,127}));
  connect(sinAir.ports[1], chiAirCoo.port_b1)
    annotation (Line(points={{-50,60},{20,60},{20,32}},color={0,127,255}));
  connect(souAir.ports[1], chiAirCoo.port_a1)
    annotation (Line(points={{110,60},{40,60},{40,32}},color={0,127,255}));
  connect(TChiWatRet1.y, retChiWat1.T_in)
    annotation (Line(points={{-98,-96},{-72,-96}},color={0,0,127}));
  connect(retChiWat1.ports[1], TRet2.port_a)
    annotation (Line(points={{-50,-100},{-30,-100}},color={0,127,255}));
  connect(TChiWatSupSet1.y, bus2.TSupSet)
    annotation (Line(points={{-98,-40},{0,-40}},color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-140,-140},{140,140}})),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Chillers/Validation/Compression.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StartTime=0.0,
      StopTime=8000.0),
    Documentation(
      info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Components.Chillers.Compression\">
Buildings.Templates.Components.Chillers.Compression</a>
in a configuration in which the chiller is exposed
to a constant differential pressure and a varying
return temperature.
</p>
<p>
The chiller model is configured to represent either an air-cooled
chiller (component <code>chiAirCoo</code>) or a water-cooled
chiller (component <code>chiWatCoo</code>).
</p>
<p>
Regarding the parameterization logic described in the documentation of 
<a href=\"modelica://Buildings.Templates.Components.Chillers.Compression\">
Buildings.Templates.Components.Chillers.Compression</a>:
The air-cooled chiller component is parameterized using the 
specified design conditions (<code>datChiAirCoo.use_datDes=true</code>)
and a direct assignment of the performance curves
<code>per.capFunT</code>, <code>per.EIRFunT</code> and <code>per.EIRFunPLR</code>.
The water-cooled chiller component is parameterized using the 
rating conditions specified in the redeclared performance record
(<code>datChiWatCoo.use_datDes=false</code>) and no direct assignment
of the design parameters.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Compression;
