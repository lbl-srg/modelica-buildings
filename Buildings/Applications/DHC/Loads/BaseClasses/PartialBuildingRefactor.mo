within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialBuildingRefactor "Partial class for building model"
  // Find a way to specify medium for each connected load.
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
    annotation(choices(
      choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.SIunits.HeatFlowRate Q_flowHea_nominal[nLoa]
    "Heating power at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flowCoo_nominal[nLoa]
    "Cooling power at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.ThermodynamicTemperature THeaLoa_nominal[nLoa](
    each displayUnit="degC") = fill(Modelica.SIunits.Conversions.from_degC(20), nLoa)
    "Temperature of heating load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.ThermodynamicTemperature TCooLoa_nominal[nLoa](
    each displayUnit="degC") = fill(Modelica.SIunits.Conversions.from_degC(24), nLoa)
    "Temperature of cooling load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flowHeaLoa_nominal[nLoa] = fill(0, nLoa)
    "Mass flow rate on heating load side at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flowCooLoa_nominal[nLoa] = fill(0, nLoa)
    "Mass flow rate on cooling load side at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Integer nLoa = 1
    "Number of loads"
    annotation(Evaluate=true);
  parameter Buildings.Applications.DHC.Loads.Types.ModelType heaLoaTyp[nLoa]=
    fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nLoa)
    "Type of heating load model"
    annotation(Evaluate=true);
  parameter Buildings.Applications.DHC.Loads.Types.ModelType cooLoaTyp[nLoa]=
    fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nLoa)
    "Type of cooling load model"
    annotation(Evaluate=true);
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime floRegHeaLoa[nLoa]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, nLoa)
    "Heat exchanger flow regime"
    annotation(Evaluate=true);
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime floRegCooLoa[nLoa]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, nLoa)
    "Heat exchanger flow regime"
    annotation(Evaluate=true);
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
    transformation(extent={{-16,284},{18,316}}),
    iconTransformation(extent={{-16,84},{18,116}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo[nLoa](each final unit="1")
    "Cooling control loop output"
    annotation (
      Placement(transformation(extent={{300,-202},{320,-182}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea[nLoa](each final unit="1")
    "Heating control loop output"
    annotation (
      Placement(transformation(extent={{300,190},{320,210}}),iconTransformation(
          extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowHeaAct[nLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Actual heating heat flow rate"
    annotation (Placement(
    transformation(extent={{300,284},{320,304}}), iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowCooAct[nLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Actual cooling heat flow rate"
    annotation (Placement(
    transformation(extent={{300,-304},{320,-284}}), iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium1,
    p(start=Medium1.p_default),
    m_flow(min=0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(
    extent={{-310,-10},{-290,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium1,
    p(start=Medium1.p_default),
    m_flow(max=0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{310,-10},{290,10}}),
    iconTransformation(extent={{110,-10},{90,10}})));
protected
  parameter Integer nHeaLoaH = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort for el in heaLoaTyp})
    "Number of heating loads represented by a thermal model with heat port"
    annotation(Evaluate=true);
  parameter Integer heaLoaH_idx[nHeaLoaH] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort     for el in heaLoaTyp})
    "Indices of the input heat ports to be connected with models with heat port"
    annotation(Evaluate=true);
  parameter Integer nHeaLoaT = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT     for el in heaLoaTyp})
    "Number of heating loads represented by a prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer heaLoaT_idx[nHeaLoaT] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT     for el in heaLoaTyp})
    "Indices of the input heat ports to be connected with models with prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer nHeaLoaO = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.ODE     for el in heaLoaTyp})
    "Number of heating loads represented by an ODE model"
    annotation(Evaluate=true);
  parameter Integer heaLoaO_idx[nHeaLoaO] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.ODE     for el in heaLoaTyp})
    "Indices of the input heat ports to be connected with models with ODE"
    annotation(Evaluate=true);
  parameter Integer nCooLoaH = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort     for el in cooLoaTyp})
    "Number of cooling loads represented by a thermal model with heat port"
    annotation(Evaluate=true);
  parameter Integer cooLoaH_idx[nCooLoaH] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort     for el in cooLoaTyp})
    "Indices of the input heat ports to be connected with thermal models with heat port"
    annotation(Evaluate=true);
  parameter Integer nCooLoaT = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT     for el in cooLoaTyp})
    "Number of cooling loads represented by a prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer cooLoaT_idx[nCooLoaT] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT     for el in cooLoaTyp})
    "Indices of the input heat ports to be connected with models with prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer nCooLoaO = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.ODE
     for el in cooLoaTyp})
    "Number of cooling loads represented by an ODE model"
    annotation(Evaluate=true);
  parameter Integer cooLoaO_idx[nCooLoaO] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.ODE
     for el in cooLoaTyp})
    "Indices of the input heat ports to be connected with models with ODE"
    annotation(Evaluate=true);
  annotation (
  defaultComponentName="heaFloEps",
  Documentation(info="<html>
  <p>
  Partial model for connecting loads at uniform temperature with a hot water and a chilled water loop
  by means of two arrays of heat ports: one for heating, the other for cooling.
  It is typically used in conjunction with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>.
  </p>
  <p>
  Models that extend from this model must:
  </p>
  <ul>
  <li>
  specify a method to compute the temperature of the load. The following predefined types are implemented:
    <ul>
    <li>
    Thermal model with heat port: the derived model provides the system of equations to compute the load
    temperature which is exposed through a heat port. This heat port must be connected to the heat ports of the
    partial model in order to transfer the sensible heat flow rate from the water loop to the load.
    See <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.CouplingRC\">
    Buildings.DistrictEnergySystem.Loads.Examples.CouplingRC</a> for a typical example.
    </li>
    <li>
    Temperature based on first order ODE: this method is implemented in
    <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
    Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
    which gets conditionally instantiated and connected as many times as this predefined type is selected.
    See <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries\">
    Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries</a> for a typical example.
    </li>
    <li>
    Prescribed temperature: this method uses
    <a href=\"modelica://Buildings.HeatTransfer.Sources.PrescribedTemperature\">
    Buildings.HeatTransfer.Sources.PrescribedTemperature</a>
    which gets conditionally instantiated and connected as many times as this predefined type is selected.
    See <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries\">
    Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries</a> for a typical example.
    </li>
    </ul>
  </li>
  <li>
  provide the heating and cooling heat flow rate required to maintain the load temperature setpoint. The
  corresponding variables must be connected to the output connectors <code>Q_flowHeaReq</code> and
  <code>Q_flowCooReq</code>.
  </li>
  </ul>
  <p>
  The other output connectors <code>Q_flowHeaAct</code> and <code>Q_flowCooAct</code> correspond to the actual
  heat flow rates exchanged with the water loops.
  They are provided as a simple means of accessing the heat flow rate of each heat port from a higher level of
  composition.
  </p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100}, {100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},{300,300}})));
end PartialBuildingRefactor;
