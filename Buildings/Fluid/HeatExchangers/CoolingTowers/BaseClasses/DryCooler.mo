within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
block DryCooler "Model for thermal performance of dry cooling tower"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic
    dat "Performance data record"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of water"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
      m_flow_nominal/dat.ratCooAir_nominal "Nominal mass flow rate of air"
    annotation (Dialog(group="Fan"));

  parameter Real yMin(min=0.01, max=1, final unit="1")
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0) = dat.Q_flow_nominal
    "Nominal heat transfer, (negative)";

  final parameter Modelica.Units.SI.ThermalConductance UA_nominal=NTU_nominal*CMin_flow_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal=
    dat.Q_flow_nominal/((dat.TAirIn_nominal - dat.TCooIn_nominal) * CMin_flow_nominal)
    "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min=0)=
      Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=min(0.99999, max(1E-6, eps_nominal)),
      Z=Z_nominal,
      flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow))
    "Nominal number of transfer units. Fixme: should be cross-flow.";

  Modelica.Blocks.Interfaces.RealInput y(unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(final unit="kg/s")
    "Cooling fluid mass flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TCooIn(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Inlet water temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput TAir(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Units.SI.Temperature TAirOut(displayUnit="degC")
    "Outlet air temperature";

  Modelica.Units.SI.MassFlowRate mAir_flow "Air mass flow rate";

  Real eps(min=0, max=1, unit="1") "Heat exchanger effectiveness";

  Modelica.Units.SI.SpecificHeatCapacity cpCoo "Heat capacity of cooling loop fluid";

  Modelica.Units.SI.ThermalConductance CAir_flow
    "Heat capacity flow rate of air";
  Modelica.Units.SI.ThermalConductance CCoo_flow
    "Heat capacity flow rate of water";
  Modelica.Units.SI.ThermalConductance CMin_flow(min=0)
    "Minimum heat capacity flow rate";

  Modelica.Units.SI.HeatFlowRate QMax_flow "Maximum heat flow rate into air";

  Modelica.Units.SI.ThermalConductance UA "Thermal conductance";

  Modelica.Blocks.Interfaces.RealOutput Q_flow "Heat removed from water"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  final package Air = Buildings.Media.Air "Package of medium air";

  final parameter Air.ThermodynamicState staAir_default=Air.setState_pTX(
      T=dat.TAirIn_nominal,
      p=Air.p_default,
      X=Air.X_default[1:Air.nXi]) "Default state for air";
  final parameter Medium.ThermodynamicState
    staCoo_default=Medium.setState_pTX(
      T=dat.TCooIn_nominal,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state for water";

  parameter Real delta=1E-3 "Parameter used for smoothing";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_nominal=
      Air.specificHeatCapacityCp(staAir_default)
    "Specific heat capacity of air at nominal condition";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCoo_nominal=
      Medium.specificHeatCapacityCp(staCoo_default)
    "Specific heat capacity of water at nominal condition";
  parameter Modelica.Units.SI.ThermalConductance CAir_flow_nominal=
      mAir_flow_nominal*cpAir_nominal "Nominal capacity flow rate of air";
  parameter Modelica.Units.SI.ThermalConductance CCoo_flow_nominal=
      m_flow_nominal*cpCoo_nominal "Nominal capacity flow rate of water";
  parameter Modelica.Units.SI.ThermalConductance CMin_flow_nominal=min(
      CAir_flow_nominal, CCoo_flow_nominal)
    "Minimal capacity flow rate at nominal condition";
  parameter Modelica.Units.SI.ThermalConductance CMax_flow_nominal=max(
      CAir_flow_nominal, CCoo_flow_nominal)
    "Maximum capacity flow rate at nominal condition";
  parameter Real Z_nominal(
    min=0,
    max=1) = CMin_flow_nominal/CMax_flow_nominal
    "Ratio of capacity flow rate at nominal condition";

  parameter Modelica.Units.SI.Temperature TAirOut_nominal =
    dat.TAirIn_nominal - abs(dat.Q_flow_nominal) / CAir_flow_nominal
    "Nominal leaving air drybulb temperature";

  Real corUAFreCon "Correction for UA value in free convection regime";

  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final UA_nominal=UA_nominal,
    final m_flow_nominal_w=m_flow_nominal,
    final m_flow_nominal_a=mAir_flow_nominal,
    final r_nominal=dat.UACor.r_nominal,
    final n_w=dat.UACor.n_w,
    final n_a=dat.UACor.n_a,
    final T0_w=dat.TCooIn_nominal,
    final T0_a=dat.TAirIn_nominal)
    "Convective heat transfer correction for flow rate and temperatures"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.RealExpression mAirIn_flow(
    y(final unit="kg/s")=mAir_flow)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-76,-64},{-56,-44}})));
initial equation
  assert(eps_nominal > 0 and eps_nominal < 1,
    "eps_nominal out of bounds, eps_nominal = " + String(eps_nominal) +
    "\n  To achieve a heat transfer rate at epsilon=0.8, set |TAirIn_nominal-TCooIn_nominal| = "
     + String(abs(Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CAir_flow_nominal  = " + String(CAir_flow_nominal) +
    "\n  CCoo_flow_nominal  = " + String(CCoo_flow_nominal) +
    "\n  TAirOut_nominal    = " + String(TAirOut_nominal)    + " (" + String(TAirOut_nominal-273.15) + " degC)" +
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

  // Determine the airflow based on fan speed signal
  mAir_flow = y*mAir_flow_nominal;

  // UA value, for correction, simplified to be dominated by convection
  UA = corUAFreCon / (1/hA.hA_1+1/hA.hA_2);
  // Reduction of UA value in free convection regime
  corUAFreCon = Buildings.Utilities.Math.Functions.spliceFunction(
    pos=1,
    neg=dat.fraFreCon,
    x=y - yMin + yMin/20,
    deltax=yMin/20);

  // Capacity for air and water
  CAir_flow =abs(mAir_flow)*cpAir_nominal;
  CCoo_flow =abs(m_flow)*cpCoo;
  CMin_flow =Buildings.Utilities.Math.Functions.smoothMin(
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
  QMax_flow = CMin_flow*(TCooIn - TAir);
  eps*QMax_flow =CAir_flow*(TAirOut - TAir);

  Q_flow = -eps * QMax_flow;

  connect(hA.m1_flow, m_flow) annotation (Line(points={{-41,-23},{-90,-23},{-90,
          -80},{-120,-80}},                     color={0,0,127}));
  connect(hA.T_1, TCooIn) annotation (Line(points={{-41,-27},{-94,-27},{-94,-40},
          {-120,-40}}, color={0,0,127}));
  connect(hA.T_2, TAir) annotation (Line(points={{-41,-33},{-96,-33},{-96,40},{-120,
          40}}, color={0,0,127}));
  connect(hA.m2_flow, mAirIn_flow.y)
    annotation (Line(points={{-41,-37},{-48,-37},{-48,-54},{-55,-54}},
                                                             color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-66,78},{68,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,-10},{58,-130}},
          textColor={0,0,0},
          textString="DryCooler"),
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
Model for the thermal peformance of the Merkel cooling tower.
</p>
<p>
For the documentation, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
Moved <code>ratCooAir_nominal</code> to the data record
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.DryCooler</a>.
Added data record <code>dat</code> and use its parameters instead of individual parameters.
</li>
<li>
April 17, 2025, by Michael Wetter:<br/>
Corrected computation of nominal UA value, which also needs to include the correction for <code>cpEqu_nominal</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4189\">#4189</a>.
</li>
<li>
January 20, 2020, by Michael Wetter:<br/>
First implementation during refactoring of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
</li>
</ul>
</html>"));
end DryCooler;
