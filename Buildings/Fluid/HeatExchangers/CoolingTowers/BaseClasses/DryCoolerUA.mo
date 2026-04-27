within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
block DryCoolerUA
  "Block that computes UA, effectiveness, and heat transfer of a dry cooler"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
          Buildings.Media.Antifreeze.PropyleneGlycolWater (
            property_T=293.15,
            X_a=0.40)
            "Propylene glycol water, 40% mass fraction")));

  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic dat
    "Performance data record"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of water"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
      m_flow_nominal/dat.ratCooAir_nominal
    "Nominal mass flow rate of air"
    annotation (Dialog(group="Fan"));

  parameter Real yMin(min=0.01, max=1, final unit="1")
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));

  final parameter Modelica.Units.SI.ThermalConductance UA_nominal=
      NTU_nominal*CMin_flow_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal=
      dat.Q_flow_nominal/((dat.TAirIn_nominal - dat.TCooIn_nominal)*CMin_flow_nominal)
    "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min=0)=
      Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
        eps=min(0.99999, max(1E-6, eps_nominal)),
        Z=Z_nominal,
        flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow))
    "Nominal number of transfer units. Fixme: should be cross-flow.";

  final parameter Real Z_nominal(
    min=0,
    max=1) = CMin_flow_nominal/CMax_flow_nominal
    "Ratio of capacity flow rate at nominal condition";

  final parameter Modelica.Units.SI.Temperature TAirOut_nominal=
      dat.TAirIn_nominal - abs(dat.Q_flow_nominal)/CAir_flow_nominal
    "Nominal leaving air drybulb temperature";

  Modelica.Blocks.Interfaces.RealInput y(unit="1")
    "Fan control signal"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
        iconTransformation(extent={{-120,90},{-100,110}})));

  Modelica.Blocks.Interfaces.RealInput mAir_flow(final unit="kg/s")
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput mCoo_flow(final unit="kg/s")
    "Cooling fluid mass flow rate"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));

  Modelica.Blocks.Interfaces.RealInput TCooIn(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealInput TAirIn(
    final min=0,
    final unit="K",
    displayUnit="degC") "Entering air dry bulb temperature" annotation (
      Placement(transformation(extent={{-120,0},{-100,20}}), iconTransformation(
          extent={{-120,0},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput hACoo(final unit="W/K")
    "Convective heat transfer coefficient times area on the coolant side"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput hAAir(final unit="W/K")
    "Convective heat transfer coefficient times area on the air side"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Modelica.Units.SI.Temperature TAirOut(displayUnit="degC")
    "Outlet air temperature";

  Real eps(min=0, max=1, unit="1") "Heat exchanger effectiveness";

  Modelica.Units.SI.SpecificHeatCapacity cpCoo
    "Heat capacity of cooling loop fluid";

  Modelica.Units.SI.ThermalConductance CAir_flow
    "Heat capacity flow rate of air";
  Modelica.Units.SI.ThermalConductance CCoo_flow
    "Heat capacity flow rate of water";
  Modelica.Units.SI.ThermalConductance CMin_flow(min=0)
    "Minimum heat capacity flow rate";

  Modelica.Units.SI.HeatFlowRate QMax_flow
    "Maximum heat flow rate into air";

  Modelica.Units.SI.ThermalConductance UA "Thermal conductance";

  Modelica.Blocks.Interfaces.RealOutput Q_flow
    "Heat removed from water"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  final package Air = Buildings.Media.Air "Package of medium air";

  final parameter Air.ThermodynamicState staAir_default=Air.setState_pTX(
      T=dat.TAirIn_nominal,
      p=Air.p_default,
      X=Air.X_default[1:Air.nXi])
    "Default state for air";
  final parameter Medium.ThermodynamicState staCoo_default=Medium.setState_pTX(
      T=dat.TCooIn_nominal,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi])
    "Default state for water";

  parameter Real delta=1E-3 "Parameter used for smoothing";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_nominal=
      Air.specificHeatCapacityCp(staAir_default)
    "Specific heat capacity of air at nominal condition";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCoo_nominal=
      Medium.specificHeatCapacityCp(staCoo_default)
    "Specific heat capacity of water at nominal condition";
  parameter Modelica.Units.SI.ThermalConductance CAir_flow_nominal=
      mAir_flow_nominal*cpAir_nominal
    "Nominal capacity flow rate of air";
  parameter Modelica.Units.SI.ThermalConductance CCoo_flow_nominal=
      m_flow_nominal*cpCoo_nominal
    "Nominal capacity flow rate of water";
  parameter Modelica.Units.SI.ThermalConductance CMin_flow_nominal=
    min(CAir_flow_nominal, CCoo_flow_nominal)
    "Minimal capacity flow rate at nominal condition";
  parameter Modelica.Units.SI.ThermalConductance CMax_flow_nominal=
    max(CAir_flow_nominal, CCoo_flow_nominal)
    "Maximum capacity flow rate at nominal condition";

  Real corUAFreCon "Correction for UA value in free convection regime";

initial equation
  assert(eps_nominal > 0 and eps_nominal < 1,
    "eps_nominal out of bounds, eps_nominal = " + String(eps_nominal) +
    "\n  To achieve a heat transfer rate at epsilon=0.8, set |TAirIn_nominal-TCooIn_nominal| = "
     + String(abs(dat.Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CAir_flow_nominal  = " + String(CAir_flow_nominal) +
    "\n  CCoo_flow_nominal  = " + String(CCoo_flow_nominal) +
    "\n  TAirOut_nominal    = " + String(TAirOut_nominal) + " (" + String(TAirOut_nominal-273.15) + " degC)" +
    "\n with TAirIn_nominal = " + String(dat.TAirIn_nominal) + " (" + String(dat.TAirIn_nominal-273.15) + " degC)" +
    "\n      TCooIn_nominal = " + String(dat.TCooIn_nominal) + " (" + String(dat.TCooIn_nominal-273.15) + " degC).");

equation
  // For cp water, we use the inlet temperatures because the effect is small
  // for actual water temperature differences, and in case of Buildings.Media.Water,
  // cp is constant.
  cpCoo = Medium.specificHeatCapacityCp(Medium.setState_pTX(
    p=Medium.p_default,
    T=TCooIn,
    X=Medium.X_default));

  // Reduction of UA value in free convection regime
  corUAFreCon = Buildings.Utilities.Math.Functions.spliceFunction(
    pos=1,
    neg=dat.fraFreCon,
    x=y - yMin + yMin/20,
    deltax=yMin/20);
  // UA value, for correction, simplified to be dominated by convection
  UA =corUAFreCon/(1/hACoo + 1/hAAir);

  // Capacity for air and water
  CAir_flow = abs(mAir_flow)*cpAir_nominal;
  CCoo_flow = abs(mCoo_flow)*cpCoo;
  CMin_flow = Buildings.Utilities.Math.Functions.smoothMin(
    CAir_flow,
    CCoo_flow,
    delta*CMin_flow_nominal);

  // Calculate epsilon
  eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
    UA=UA,
    C1_flow=CAir_flow,
    C2_flow=CCoo_flow,
    flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow),
    CMin_flow_nominal=CMin_flow_nominal,
    CMax_flow_nominal=CMax_flow_nominal,
    delta=delta);

  // QMax_flow is maximum heat transfer into medium air: positive means heating
  QMax_flow =CMin_flow*(TCooIn - TAirIn);
  eps*QMax_flow =CAir_flow*(TAirOut - TAirIn);

  Q_flow = -eps*QMax_flow;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-66,78},{68,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,-10},{58,-130}},
          textColor={0,0,0},
          textString="DryCoolerUA"),
        Ellipse(
          extent={{-54,62},{0,50}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,62},{54,50}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Block that computes the overall thermal conductance <i>UA</i>,
the heat exchanger effectiveness <i>&epsilon;</i>,
and the heat flow rate <i>Q&#775;</i>
for a dry cooler.
</p>
<h4>Main relationships</h4>
<p>
The overall conductance is computed from the
convective heat transfer coefficients on the coolant side
<code>hACoo</code> and the air side <code>hAAir</code> as
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA = corUA &frasl; (1 &frasl; hA<sub>coo</sub> + 1 &frasl; hA<sub>air</sub>),
</p>
<p>
where <i>corUA</i> is a correction factor that reduces <i>UA</i>
in the free-convection regime when the fan is off.
</p>
<p>
The effectiveness&ndash;NTU method is used to compute the
heat flow rate transferred from water to air.
</p>
<h4>Assumptions</h4>
<ul>
<li>
The heat exchanger flow configuration is treated as cross-flow
(Fixme: should be cross-flow).
</li>
<li>
The specific heat capacity of air is evaluated at nominal conditions.
</li>
<li>
The specific heat capacity of the cooling fluid is evaluated at the
inlet temperature.
</li>
</ul>
<h4>References</h4>
<p>
For further documentation, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler\">
Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler</a>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
April 27, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCoolerUA;
