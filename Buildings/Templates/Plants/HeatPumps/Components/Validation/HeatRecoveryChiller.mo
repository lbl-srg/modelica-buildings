within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model HeatRecoveryChiller
  "Validation model for heat recovery chiller"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Buildings.Templates.Components.Data.Chiller datHrc(
    final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    redeclare Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Trane_CGWD_207kW_3_99COP_None per,
    cap_nominal=500E3,
    COP_nominal=3.8,
    dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    dpCon_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TConEnt_nominal=Buildings.Templates.Data.Defaults.THeaWatRetMed,
    mChiWat_flow_nominal=datHrc.cap_nominal / abs(datHrc.TChiWatSup_nominal -
      Buildings.Templates.Data.Defaults.TChiWatRet) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    mCon_flow_nominal=datHrc.QCon_flow_nominal / abs(datHrc.TConEnt_nominal -
      Buildings.Templates.Data.Defaults.THeaWatSupMed) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    "HRC parameters"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWatHrc(
    final typ=Buildings.Templates.Components.Types.Pump.Single,
    m_flow_nominal=datHrc.mChiWat_flow_nominal,
    dp_nominal=datHrc.dpChiWat_nominal)
    "HRC CHW pump parameters"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  parameter Buildings.Templates.Components.Data.PumpSingle datPumHeaWatHrc(
    final typ=Buildings.Templates.Components.Types.Pump.Single,
    m_flow_nominal=datHrc.mCon_flow_nominal,
    dp_nominal=datHrc.dpCon_nominal)
    "HRC HW pump parameters"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Templates.Plants.HeatPumps.Components.HeatRecoveryChiller hrc(
    redeclare final package MediumChiWat=Medium,
    redeclare final package MediumHeaWat=Medium,
    final datPumChiWat=datPumChiWatHrc,
    final datPumHeaWat=datPumHeaWatHrc,
    final datHrc=datHrc,
    final energyDynamics=energyDynamics)
    annotation (Placement(transformation(extent={{-60,-56},{60,64}})));
  Fluid.Sources.Boundary_pT inlChiWat(
    redeclare final package Medium=Medium,
    T=datHrc.TChiWatRet_nominal,
    nPorts=1)
    "Boundary conditions for HRC entering CHW"
    annotation (Placement(transformation(extent={{150,30},{130,50}})));
  Fluid.Sources.Boundary_pT inlHeaWat(
    redeclare final package Medium=Medium,
    T=datHrc.TConEnt_nominal,
    nPorts=1)
    "Boundary conditions for HRC entering HW"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Fluid.Sources.Boundary_pT outHeaWat(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Boundary conditions for HRC leaving HW"
    annotation (Placement(transformation(extent={{150,-50},{130,-30}})));
  Fluid.Sources.Boundary_pT outChiWat(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Boundary conditions for HRC leaving CHW"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Templates.Components.Interfaces.Bus busHrc
    "HRC control bus"
    annotation (Placement(transformation(extent={{20,80},{60,120}}),
      iconTransformation(extent={{-300,-80},{-260,-40}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatHrc
    "HRC CHW pump control bus"
    annotation (Placement(transformation(extent={{60,60},{100,100}}),
      iconTransformation(extent={{-300,-80},{-260,-40}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatHrc
    "HRC HW pump control bus"
    annotation (Placement(transformation(extent={{60,100},{100,140}}),
      iconTransformation(extent={{-300,-80},{-260,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[
      0, 0, 0;
      0.1, 1, 1;
      0.5, 1, 0;
      0.9, 0, 0],
    timeScale=1000,
    period=1000)
    "Source for DO signals"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSupSet(
    y(unit="K",
      displayUnit="degC"))
    "HRC supply temperature setpoint"
    annotation (Placement(transformation(extent={{30,150},{50,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    final k=datHrc.TChiWatSup_nominal)
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    final k=datHrc.TConLvg_nominal)
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatLvg(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHrc.mCon_flow_nominal)
    "HRC leaving HW temperature"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatLvg(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHrc.mChiWat_flow_nominal)
    "HRC leaving CHW temperature"
    annotation (Placement(transformation(extent={{-80,30},{-100,50}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,40},{20,80}}),
      iconTransformation(extent={{-480,-120},{-440,-80}})));
equation
  connect(inlHeaWat.ports[1], hrc.port_a1)
    annotation (Line(points={{-130,-40},{-60,-40},{-60,-32}},color={0,127,255}));
  connect(y1.y[1], busPumHeaWatHrc.y1)
    annotation (Line(points={{-38,140},{80,140},{80,120}},color={255,0,255}));
  connect(y1.y[1], busPumChiWatHrc.y1)
    annotation (Line(points={{-38,140},{80,140},{80,80}},color={255,0,255}));
  connect(y1.y[1], busHrc.y1)
    annotation (Line(points={{-38,140},{40,140},{40,100}},color={255,0,255}));
  connect(y1.y[2], busHrc.y1Coo)
    annotation (Line(points={{-38,140},{40,140},{40,100}},color={255,0,255}));
  connect(y1.y[2], TSupSet.u2)
    annotation (Line(points={{-38,140},{20,140},{20,160},{28,160}},color={255,0,255}));
  connect(TChiWatSupSet.y, TSupSet.u1)
    annotation (Line(points={{-108,180},{20,180},{20,168},{28,168}},color={0,0,127}));
  connect(THeaWatSupSet.y, TSupSet.u3)
    annotation (Line(points={{-78,160},{0,160},{0,152},{28,152}},color={0,0,127}));
  connect(TSupSet.y, busHrc.TSupSet)
    annotation (Line(points={{52,160},{60,160},{60,100},{40,100}},color={0,0,127}));
  connect(outHeaWat.ports[1], THeaWatLvg.port_b)
    annotation (Line(points={{130,-40},{100,-40}},color={0,127,255}));
  connect(THeaWatLvg.port_a, hrc.port_b1)
    annotation (Line(points={{80,-40},{60,-40},{60,-32}},color={0,127,255}));
  connect(hrc.port_b2, TChiWatLvg.port_a)
    annotation (Line(points={{-60,40},{-80,40}},color={0,127,255}));
  connect(TChiWatLvg.port_b, outChiWat.ports[1])
    annotation (Line(points={{-100,40},{-130,40}},color={0,127,255}));
  connect(inlChiWat.ports[1], hrc.port_a2)
    annotation (Line(points={{130,40},{60,40}},color={0,127,255}));
  connect(busHrc, bus.hrc)
    annotation (Line(points={{40,100},{0,100},{0,60}},color={255,204,51},thickness=0.5));
  connect(bus, hrc.bus)
    annotation (Line(points={{0,60},{0,26}},color={255,204,51},thickness=0.5));
  connect(busPumChiWatHrc, bus.pumChiWatHrc)
    annotation (Line(points={{80,80},{0,80},{0,60}},color={255,204,51},thickness=0.5));
  connect(busPumHeaWatHrc, bus.pumHeaWatHrc)
    annotation (Line(points={{80,120},{0,120},{0,60}},color={255,204,51},thickness=0.5));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/HeatRecoveryChiller.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=1000.0),
    Documentation(
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.HeatRecoveryChiller\">
Buildings.Templates.Plants.HeatPumps.Components.HeatRecoveryChiller</a>.
</p>
<p>
The CHW and HW return temperatures and flow rates are at their design values.
The HRC supply temperature setpoint is switched from the design CHW 
supply temperature to the design HW supply temperature when the HRC
operating mode is switched from cooling to heating.
</p>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})));
end HeatRecoveryChiller;
