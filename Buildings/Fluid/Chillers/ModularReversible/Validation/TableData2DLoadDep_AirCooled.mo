within Buildings.Fluid.Chillers.ModularReversible.Validation;
model TableData2DLoadDep_AirCooled
  "Test model for chiller electric reformulated EIR"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric_AirCooled(
    P_nominal=- per.QEva_flow_nominal / per.COP_nominal,
    mEva_flow_nominal=per.mEva_flow_nominal,
    mCon_flow_nominal=per.mCon_flow_nominal,
    sou1(
      nPorts=1),
    sou2(
      nPorts=1));
  Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep chi(
    show_T=true,
    redeclare final package MediumCon=Medium1,
    redeclare final package MediumEva=Medium2,
    use_intSafCtr=false,
    mCon_flow_nominal=per.mCon_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    QCoo_flow_nominal=- 103979,
    datCoo=datCoo,
    CCon=0,
    GConOut=0,
    GConIns=0,
    mEva_flow_nominal=per.mEva_flow_nominal,
    use_conCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    TEva_start=290.15,
    use_evaCap=false,
    TConCoo_nominal=per.TConEnt_nominal,
    TEvaCoo_nominal=per.TEvaLvg_nominal)
    "Chiller"
    annotation (Placement(transformation(extent={{-10.5,-10.5},{10.5,10.5}},
      rotation=0,origin={10.5,-10.5})));
  parameter ModularReversible.Data.TableData2DLoadDep.Generic datCoo(
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Chillers/ModularReversible/Validation/York_YCAL0033EE_101kW_3_1COP_AirCooled.txt"),
    PLRSup={0.1,0.45,0.8,1.,1.15},
    mCon_flow_nominal=per.mCon_flow_nominal,
    mEva_flow_nominal=per.mEva_flow_nominal,
    dpCon_nominal=6000,
    dpEva_nominal=6000,
    devIde="York_YCAL0033EE_101kW_3_1COP_AirCooled",
    use_TEvaOutForTab=true,
    use_TConOutForTab=false,
    tabLowBou=[
      292.15, 276.45;
      336.15, 276.45],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true)
    "Chiller performance data"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled per
    "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.CombiTimeTable ref(
    tableOnFile=true,
    tableName="tab",
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/Chillers/ModularReversible/Validation/ElectricEIR_AirCooled.csv"),
    columns=2:4,
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    "Reference results"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
equation
  connect(greaterThreshold.y, chi.on)
    annotation (Line(points={{-19,90},{-6,90},{-6,-10.5},{-2.31,-10.5}},color={255,0,255}));
  connect(TSet.y, chi.TSet)
    annotation (Line(points={{-59,60},{-12,60},{-12,-8.4},{-2.31,-8.4}},color={0,0,127}));
  connect(sou1.ports[1], chi.port_a1)
    annotation (Line(points={{-40,16},{-20,16},{-20,-4.2},{0,-4.2}},color={0,127,255}));
  connect(sou2.ports[1], chi.port_a2)
    annotation (Line(points={{40,4},{30,4},{30,-16.8},{21,-16.8}},color={0,127,255}));
  connect(chi.port_b2, res2.port_a)
    annotation (Line(points={{0,-16.8},{0,-16},{-10,-16},{-10,-20},{-20,-20}},
      color={0,127,255}));
  connect(chi.port_b1, res1.port_a)
    annotation (Line(points={{21,-4.2},{26,-4.2},{26,40},{32,40}},color={0,127,255}));
  annotation (
    experiment(
      Tolerance=1e-6,
      StartTime=17020800,
      StopTime=17064000),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/ModularReversible/Validation/TableData2DLoadDep_AirCooled.mos"
        "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep</a>
against the polynomial chiller model
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>
for air-cooled chiller applications.
</p>
<ul>
<li>
The validation setup is duplicated from
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.ElectricEIR_AirCooled\">
Buildings.Fluid.Chillers.Examples.ElectricEIR_AirCooled</a>
and the component <code>ref</code> reads the reference results
obtained from that model.
</li>
<li>
The chiller model is configured to interpolate capacity and power
along the evaporator <i>leaving</i> temperature and the condenser
<i>entering</i> temperature.
</li>
<li>
The performance data are generated with the same polynomial equations as
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>,
using polynomial coefficients from the same data record as the one used
in the reference example model, that is
<a href=\"modelica://Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled\">
Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled</a>.
</li>
</ul>
<h4>Results analysis</h4>
<p>
There is good agreement with the reference results, except during
the time interval where the PLR value exceeds <i>1</i>.
In this interval the polynomial model computes a significantly higher
cooling heat flow rate (in negative value) and a slightly higher power.
This discrepancy occurs because the polynomial model calculates the
heat flow rate at <i>PLR &le; 1</i> while calculating power at
<i>PLR &le; per.PLRMax</i>.
Consequently, when PLR increases between <i>1</i> and <i>per.PLRMax</i>,
input power increases according to the polynomial <code>EIRFunPLR</code>,
but the heat flow rate only varies due to the effect of the increasing
leaving temperature as the setpoint is no longer met.
This appears as a deficiency in the polynomial model that is resolved
in the data table model.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-120,-100},{100,120}})));
end TableData2DLoadDep_AirCooled;
