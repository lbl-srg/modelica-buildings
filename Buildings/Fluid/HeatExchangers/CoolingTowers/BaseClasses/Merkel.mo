within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
block Merkel "Model for thermal performance of Merkel cooling tower"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of water"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
      m_flow_nominal/ratWatAir_nominal "Nominal mass flow rate of air"
    annotation (Dialog(group="Fan"));

  parameter Real ratWatAir_nominal(min=0, unit="1")
    "Water-to-air mass flow rate ratio at design condition"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatIn_nominal
    "Nominal water inlet temperature" annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatOut_nominal
    "Nominal water outlet temperature"
    annotation (Dialog(group="Heat transfer"));

  parameter Real fraFreCon(min=0, max=1, final unit="1")
    "Fraction of tower capacity in free convection regime"
    annotation (Dialog(group="Heat transfer"));

  replaceable parameter Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel UACor
    constrainedby Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel
    "Coefficients for UA correction"
    annotation (
      Dialog(group="Heat transfer"),
      choicesAllMatching=true,
      Placement(transformation(extent={{20,60},{40,80}})));

  parameter Real yMin(min=0.01, max=1, final unit="1")
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(max=0) = -
    m_flow_nominal*cpWat_nominal*(TWatIn_nominal - TWatOut_nominal)
    "Nominal heat transfer, (negative)";
  final parameter Modelica.Units.SI.ThermalConductance UA_nominal=NTU_nominal*
      CMin_flow_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal=
    Q_flow_nominal/((TAirInWB_nominal - TWatIn_nominal) * CMin_flow_nominal)
    "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min=0)=
      Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=min(1, max(0, eps_nominal)),
      Z=Z_nominal,
      flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow))
    "Nominal number of transfer units";

  Modelica.Blocks.Interfaces.RealInput y(unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(final unit="kg/s")
   "Water mass flow rate"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(
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

  Modelica.Units.SI.MassFraction FRWat
    "Ratio actual over design water mass flow ratio";
  Modelica.Units.SI.MassFraction FRAir
    "Ratio actual over design air mass flow ratio";

  Real eps(min=0, max=1, unit="1") "Heat exchanger effectiveness";

  Modelica.Units.SI.SpecificHeatCapacity cpWat "Heat capacity of water";

  Modelica.Units.SI.ThermalConductance CAir_flow
    "Heat capacity flow rate of air";
  Modelica.Units.SI.ThermalConductance CWat_flow
    "Heat capacity flow rate of water";
  Modelica.Units.SI.ThermalConductance CMin_flow(min=0)
    "Minimum heat capacity flow rate";

  Modelica.Units.SI.HeatFlowRate QMax_flow "Maximum heat flow rate into air";

  Modelica.Units.SI.ThermalConductance UAe(min=0)
    "Thermal conductance for equivalent fluid";
  Modelica.Units.SI.ThermalConductance UA "Thermal conductance";


  Modelica.Blocks.Interfaces.RealOutput Q_flow "Heat removed from water"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  final package Air = Buildings.Media.Air "Package of medium air";

  final parameter Air.ThermodynamicState staAir_default=Air.setState_pTX(
      T=TAirInWB_nominal,
      p=Air.p_default,
      X=Air.X_default[1:Air.nXi]) "Default state for air";
  final parameter Medium.ThermodynamicState
    staWat_default=Medium.setState_pTX(
      T=TWatIn_nominal,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state for water";

  parameter Real delta=1E-3 "Parameter used for smoothing";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpe_nominal=
      Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
      TIn=TAirInWB_nominal, TOut=TAirOutWB_nominal)
    "Specific heat capacity of the equivalent medium on medium 1 side";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_nominal=
      Air.specificHeatCapacityCp(staAir_default)
    "Specific heat capacity of air at nominal condition";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpWat_nominal=
      Medium.specificHeatCapacityCp(staWat_default)
    "Specific heat capacity of water at nominal condition";

  parameter Modelica.Units.SI.ThermalConductance CAir_flow_nominal=
      mAir_flow_nominal*cpe_nominal "Nominal capacity flow rate of air";
  parameter Modelica.Units.SI.ThermalConductance CWat_flow_nominal=
      m_flow_nominal*cpWat_nominal "Nominal capacity flow rate of water";
  parameter Modelica.Units.SI.ThermalConductance CMin_flow_nominal=min(
      CAir_flow_nominal, CWat_flow_nominal)
    "Minimal capacity flow rate at nominal condition";
  parameter Modelica.Units.SI.ThermalConductance CMax_flow_nominal=max(
      CAir_flow_nominal, CWat_flow_nominal)
    "Maximum capacity flow rate at nominal condition";
  parameter Real Z_nominal(
    min=0,
    max=1) = CMin_flow_nominal/CMax_flow_nominal
    "Ratio of capacity flow rate at nominal condition";

  parameter Modelica.Units.SI.Temperature TAirOutWB_nominal(fixed=false)
    "Nominal leaving air wetbulb temperature";

  Real UA_FAir "UA correction factor as function of air flow ratio";
  Real UA_FWat "UA correction factor as function of water flow ratio";
  Real UA_DifWB
    "UA correction factor as function of differential wetbulb temperature";
  Real corFac_FAir "Smooth factor as function of air flow ratio";
  Real corFac_FWat "Smooth factor as function of water flow ratio";
  Modelica.Units.SI.SpecificHeatCapacity cpEqu
    "Specific heat capacity of the equivalent fluid";

initial equation
  // Heat transferred from air to water at nominal condition
  Q_flow_nominal = mAir_flow_nominal*cpe_nominal*(TAirInWB_nominal - TAirOutWB_nominal);

  assert(eps_nominal > 0 and eps_nominal < 1,
    "eps_nominal out of bounds, eps_nominal = " + String(eps_nominal) +
    "\n  To achieve the required heat transfer rate at epsilon=0.8, set |TAirInWB_nominal-TWatIn_nominal| = "
     + String(abs(Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CMin_flow_nominal = " + String(CMin_flow_nominal) +
    "\n  CMax_flow_nominal = " + String(CMax_flow_nominal));

equation
   // For cp water, we use the inlet temperatures because the effect is small
   // for actual water temperature differences, and in case of Buildings.Media.Water,
   // cp is constant.
  cpWat = Medium.specificHeatCapacityCp(Medium.setState_pTX(
    p=Medium.p_default,
    T=TWatIn,
    X=Medium.X_default));

  // Determine the airflow based on fan speed signal
  mAir_flow = Buildings.Utilities.Math.Functions.spliceFunction(
    pos=y*mAir_flow_nominal,
    neg=fraFreCon*mAir_flow_nominal,
    x=y - yMin + yMin/20,
    deltax=yMin/20);
  FRAir = mAir_flow/mAir_flow_nominal;
  FRWat = m_flow/m_flow_nominal;

  // UA for equivalent fluid
  // Adjust UA
  UA_FAir =Buildings.Fluid.Utilities.extendedPolynomial(
    x=FRAir,
    c=UACor.cAirFra,
    xMin=UACor.FRAirMin,
    xMax=UACor.FRAirMax)
    "UA correction factor as function of air flow fraction";
  UA_FWat =Buildings.Fluid.Utilities.extendedPolynomial(
    x=FRWat,
    c=UACor.cWatFra,
    xMin=UACor.FRWatMin,
    xMax=UACor.FRWatMax)
    "UA correction factor as function of water flow fraction";
  UA_DifWB =Buildings.Fluid.Utilities.extendedPolynomial(
    x=TAirInWB_nominal - TAir,
    c=UACor.cDifWB,
    xMin=UACor.TDiffWBMin,
    xMax=UACor.TDiffWBMax)
    "UA correction factor as function of differential wet bulb temperature";
  corFac_FAir =Buildings.Utilities.Math.Functions.smoothHeaviside(
    x=FRAir - UACor.FRAirMin/4,
    delta=UACor.FRAirMin/4);
  corFac_FWat =Buildings.Utilities.Math.Functions.smoothHeaviside(
    x=FRWat - UACor.FRWatMin/4,
    delta=UACor.FRWatMin/4);

  UA = UA_nominal*UA_FAir*UA_FWat*UA_DifWB*corFac_FAir*corFac_FWat;

  UAe = UA*cpEqu/Buildings.Utilities.Psychrometrics.Constants.cpAir;

  // Capacity for air and water
  CAir_flow =abs(mAir_flow)*cpEqu;
  CWat_flow =abs(m_flow)*cpWat;
  CMin_flow =Buildings.Utilities.Math.Functions.smoothMin(
    CAir_flow,
    CWat_flow,
    delta*CMin_flow_nominal);

  // Calculate epsilon
  eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
    UA=UAe,
    C1_flow=CAir_flow,
    C2_flow=CWat_flow,
    flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow),
    CMin_flow_nominal=CMin_flow_nominal,
    CMax_flow_nominal=CMax_flow_nominal,
    delta=delta);
  // QMax_flow is maximum heat transfer into medium air: positive means heating
  QMax_flow = CMin_flow*(TWatIn - TAir);
  eps*QMax_flow =CAir_flow*(TAirOut - TAir);

  cpEqu =
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
      TIn=TAir,
      TOut=TAirOut);

  Q_flow = -eps * QMax_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-66,78},{68,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,-10},{58,-130}},
          textColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="Merkel"),
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
January 20, 2020, by Michael Wetter:<br/>
First implementation during refactoring of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
</li>
</ul>
</html>"));
end Merkel;
