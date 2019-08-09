within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialBuilding "Partial class for building model"
  parameter Modelica.SIunits.HeatFlowRate Q_flowHea_nominal[nHeaLoa]
    "Heating power at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flowCoo_nominal[nCooLoa]
    "Cooling power at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.ThermodynamicTemperature THeaLoa_nominal[nHeaLoa](
    each displayUnit="degC") = fill(Modelica.SIunits.Conversions.from_degC(20), nHeaLoa)
    "Temperature of heating load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.ThermodynamicTemperature TCooLoa_nominal[nCooLoa](
    each displayUnit="degC") = fill(Modelica.SIunits.Conversions.from_degC(24), nCooLoa)
    "Temperature of cooling load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flowHeaLoa_nominal[nHeaLoa] = fill(0, nHeaLoa)
    "Mass flow rate on heating load side at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flowCooLoa_nominal[nCooLoa] = fill(0, nCooLoa)
    "Mass flow rate on cooling load side at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Integer nHeaLoa = 1
    "Number of heating loads"
    annotation(Evaluate=true);
  parameter Integer nCooLoa = 1
    "Number of cooling loads"
    annotation(Evaluate=true);
  parameter Buildings.Applications.DHC.Loads.Types.ModelType heaLoaTyp[nHeaLoa]=
    fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nHeaLoa)
    "Type of heating load model"
    annotation(Evaluate=true);
  parameter Buildings.Applications.DHC.Loads.Types.ModelType cooLoaTyp[nCooLoa]=
    fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nCooLoa)
    "Type of cooling load model"
    annotation(Evaluate=true);
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime floRegHeaLoa[nHeaLoa]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, nHeaLoa)
    "Heat exchanger flow configuration"
    annotation(Evaluate=true);
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime floRegCooLoa[nCooLoa]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, nCooLoa)
    "Heat exchanger flow regime"
    annotation(Evaluate=true);
  parameter Boolean hasFraLat[nCooLoa] = fill(false, nCooLoa)
    "false if the cooling load is purely sensible"
    annotation(Evaluate=true);
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
    transformation(extent={{-16,284},{18,316}}),
    iconTransformation(extent={{-16,84},{18,116}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorCoo[nCooLoa]
    "Heat port for heat transfer with the cooling source"       annotation (
      Placement(transformation(extent={{-310,-110},{-290,-90}}),
        iconTransformation(extent={{-110,-80},{-90,-60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorHea[nHeaLoa]
    "Heat port for heat transfer with the heating source"       annotation (
      Placement(transformation(extent={{-310,90},{-290,110}}),
        iconTransformation(extent={{-110,60},{-90,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowCooReq[nCooLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Cooling heat flow rate required to meet setpoint"
    annotation (
      Placement(transformation(extent={{300,-202},{320,-182}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowHeaReq[nHeaLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Heating heat flow rate required to meet setpoint"
    annotation (
      Placement(transformation(extent={{300,190},{320,210}}),iconTransformation(
          extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowHeaAct[nHeaLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Actual heating heat flow rate"
    annotation (Placement(
    transformation(extent={{300,284},{320,304}}), iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowCooAct[nCooLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Actual cooling heat flow rate"
    annotation (Placement(
    transformation(extent={{300,-304},{320,-284}}), iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE heaLoaO[nHeaLoaO](
    final Q_flowHea_nominal=Q_flowHea_nominal[heaLoaO_idx],
    final Q_flow_nominal=Q_flowHea_nominal[heaLoaO_idx],
    final TIndHea_nominal=THeaLoa_nominal[heaLoaO_idx],
    each TOutHea_nominal=268.15) if nHeaLoaO > 0
    "ODE model computing the temperature of heating load"
    annotation (Placement(transformation(extent={{-180,90},{-200,110}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature THeaLoaO[nHeaLoaO] if nHeaLoaO > 0
    "Temperature of heating load computed by ODE model"
    annotation (Placement(transformation(extent={{-220,90},{-240,110}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TCooLoaO[nHeaLoaO] if nCooLoaO > 0
    "Temperature of cooling load computed by ODE model"
    annotation (Placement(transformation(extent={{-220,-110},{-240,-90}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE cooLoaO[nCooLoaO](
    Q_flowHea_nominal=Q_flowHea_nominal[cooLoaO_idx],
    final Q_flow_nominal=Q_flowCoo_nominal[cooLoaO_idx],
    TIndHea_nominal=THeaLoa_nominal[cooLoaO_idx],
    each TOutHea_nominal=268.15) if nCooLoaO > 0 "ODE model computing the temperature of cooling load"
    annotation (Placement(transformation(extent={{-180,-110},{-200,-90}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TCooLoaT[nCooLoaT] if   nCooLoaT > 0
    "Prescribed temperature of cooling load" annotation (Placement(transformation(extent={{-220,-60},{-240,-40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature THeaLoaT[nHeaLoaT] if   nHeaLoaT > 0
    "Prescribed temperature of heating load" annotation (Placement(transformation(extent={{-220,40},{-240,60}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloHeaLoaT[nHeaLoaT]
    annotation (Placement(transformation(extent={{-280,60},{-260,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloHeaLoaO[nHeaLoaO]
    annotation (Placement(transformation(extent={{-280,110},{-260,90}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloCooLoaO[nCooLoaO]
    annotation (Placement(transformation(extent={{-280,-110},{-260,-90}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloCooLoaT[nCooLoaT]
    annotation (Placement(transformation(extent={{-280,-60},{-260,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloCooLoaH[nCooLoaH]
    annotation (Placement(transformation(extent={{-280,-160},{-260,-140}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloHeaLoaH[nHeaLoaH]
    annotation (Placement(transformation(extent={{-280,160},{-260,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flowHeaLoa[nHeaLoa](
    each quantity="MassFlowRate") if nHeaLoa > 0
    "Medium mass flow rate on the load side"
    annotation (Placement(transformation(extent={{300,90},{320,110}}),
        iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flowCooLoa[nCooLoa](
    each quantity="MassFlowRate") if nCooLoa > 0
    "Medium mass flow rate on the load side"
    annotation (Placement(
        transformation(extent={{300,-122},{320,-102}}), iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput fraLatCooReq[nCooLoa](
    each unit="1") if nCooLoa > 0
    "Fraction of latent to total cooling heat flow rate"
    annotation (Placement(transformation(extent={{300,-40},{320,-20}}),
        iconTransformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant defaults(k=0)
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));
protected
  parameter Integer nHeaLoaH = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort
                                                                       for el in heaLoaTyp})
    "Number of heating loads represented by a thermal model with heat port"
    annotation(Evaluate=true);
  parameter Integer heaLoaH_idx[nHeaLoaH] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort
                                                                       for el in heaLoaTyp})
    "Indices of the input heat ports to be connected with models with heat port"
    annotation(Evaluate=true);
  parameter Integer nHeaLoaT = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT
                                                                          for el in heaLoaTyp})
    "Number of heating loads represented by a prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer heaLoaT_idx[nHeaLoaT] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT
                                                                          for el in heaLoaTyp})
    "Indices of the input heat ports to be connected with models with prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer nHeaLoaO = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.ODE
                                                                  for el in heaLoaTyp})
    "Number of heating loads represented by an ODE model"
    annotation(Evaluate=true);
  parameter Integer heaLoaO_idx[nHeaLoaO] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.ODE
                                                                  for el in heaLoaTyp})
    "Indices of the input heat ports to be connected with models with ODE"
    annotation(Evaluate=true);
  parameter Integer nCooLoaH = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort
                                                                       for el in cooLoaTyp})
    "Number of cooling loads represented by a thermal model with heat port"
    annotation(Evaluate=true);
  parameter Integer cooLoaH_idx[nCooLoaH] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort
                                                                       for el in cooLoaTyp})
    "Indices of the input heat ports to be connected with thermal models with heat port"
    annotation(Evaluate=true);
  parameter Integer nCooLoaT = Modelica.Math.BooleanVectors.countTrue(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT
                                                                          for el in cooLoaTyp})
    "Number of cooling loads represented by a prescribed temperature"
    annotation(Evaluate=true);
  parameter Integer cooLoaT_idx[nCooLoaT] = Modelica.Math.BooleanVectors.index(
    {el==Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT
                                                                          for el in cooLoaTyp})
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
equation
  if nHeaLoa > 0 then
    for i in 1:nHeaLoa loop
      if abs(m_flowHeaLoa_nominal[i]) < Modelica.Constants.eps then
        connect(defaults.y, m_flowHeaLoa[i])
          annotation (Line(points={{281,0},{292,0},{292,100},{310,100}}, color={0,0,127}));
      end if;
    end for;
  end if;
  if nCooLoa > 0 then
    for i in 1:nCooLoa loop
      if abs(m_flowCooLoa_nominal[i]) < Modelica.Constants.eps then
        connect(defaults.y, m_flowCooLoa[i])
          annotation (Line(points={{281,0},{292,0},{292,-112},{310,-112}}, color={0,0,127}));
      end if;
      if not hasFraLat[i] then
        connect(defaults.y, fraLatCooReq[i])
          annotation (Line(points={{281,0},{292,0},{292,-30},{310,-30}}, color={0,0,127}));
      end if;
    end for;
  end if;
  if nHeaLoaO > 0 then
    connect(heaLoaO.TInd, THeaLoaO.T)
      annotation (Line(points={{-201,100},{-218,100}}, color={0,0,127}));
    connect(heaFloHeaLoaO.Q_flow, heaLoaO.Q_flowAct)
      annotation (Line(points={{-270,110},{-270,120},{-160,120},{-160,92},{-178,92}}, color={0,0,127}));
    connect(heaFloHeaLoaO.port_b, THeaLoaO.port)
      annotation (Line(points={{-260,100},{-240,100}}, color={191,0,0}));
    // Connection to I/O variables
    for i in 1:nHeaLoaO loop
      connect(heaPorHea[heaLoaO_idx[i]], heaFloHeaLoaO[i].port_a)
        annotation (Line(points={{-300,100},{-280,100}}, color={191,0,0}));
      connect(heaFloHeaLoaO[i].Q_flow, Q_flowHeaAct[heaLoaO_idx[i]])
        annotation (Line(points={{-270,110},{-270,120},{-250,120},{-250,294},{310,294}}, color={0,0,127}));
    end for;
  end if;
  if nHeaLoaT > 0 then
    connect(heaFloHeaLoaT.port_b, THeaLoaT.port)
      annotation (Line(points={{-260,50},{-240,50}}, color={191,0,0}));
    // Connection to I/O variables
    for i in 1:nHeaLoaT loop
      connect(heaFloHeaLoaT[i].port_a, heaPorHea[heaLoaT_idx[i]])
        annotation (Line(points={{-280,50},{-288,50},{-288,100},{-300,100}}, color={191,0,0}));
      connect(heaFloHeaLoaT[i].Q_flow, Q_flowHeaAct[heaLoaT_idx[i]])
        annotation (Line(points={{-270,60},{-270,70},{-250,70},{-250,294},{310,294}}, color={0,0,127}));
    end for;
  end if;
  if nHeaLoaH > 0 then
    // Connection to I/O variables
    for i in 1:nHeaLoaH loop
      connect(heaFloHeaLoaH[i].port_a, heaPorHea[heaLoaH_idx[i]])
        annotation (Line(points={{-280,150},{-288,150},{-288,100},{-300,100}}, color={191,0,0}));
      connect(heaFloHeaLoaH[i].Q_flow, Q_flowHeaAct[heaLoaH_idx[i]])
        annotation (Line(points={{-270,160},{-270,294},{310,294}}, color={0,0,127}));
    end for;
  end if;
  if nCooLoaO > 0 then
    connect(TCooLoaO.port, heaFloCooLoaO.port_b)
      annotation (Line(points={{-240,-100},{-260,-100}}, color={191,0,0}));
    connect(cooLoaO.TInd, TCooLoaO.T)
      annotation (Line(points={{-201,-100},{-218,-100}}, color={0,0,127}));
    connect(heaFloCooLoaO.Q_flow, cooLoaO.Q_flowAct)
      annotation (Line(points={{-270,-110},{-270,-120},{-160,-120},{-160,-108},{-178,-108}}, color={0,0,127}));
    // Connection to I/O variables
    for i in 1:nCooLoaO loop
      connect(heaFloCooLoaO[i].port_a, heaPorCoo[cooLoaO_idx[i]])
        annotation (Line(points={{-280,-100},{-300,-100}}, color={191,0,0}));
      connect(heaFloCooLoaO[i].Q_flow, Q_flowCooAct[cooLoaO_idx[i]])
        annotation (Line(points={{-270,-110},{-270,-120},{-250,-120},{-250,-294},{310,-294}}, color={0,0,127}));
    end for;
  end if;
  if nCooLoaT > 0 then
    connect(TCooLoaT.port, heaFloCooLoaT.port_b)
      annotation (Line(points={{-240,-50},{-260,-50}}, color={191,0,0}));
    // Connection to I/O variables
    for i in 1:nCooLoaT loop
      connect(heaFloCooLoaT[i].port_a, heaPorCoo[cooLoaT_idx[i]])
        annotation (Line(points={{-280,-50},{-288,-50},{-288,-100},{-300,-100}}, color={191,0,0}));
      connect(heaFloCooLoaT[i].Q_flow, Q_flowCooAct[cooLoaT_idx[i]])
        annotation (Line(points={{-270,-60},{-270,-70},{-250,-70},{-250,-294},{310,-294}}, color={0,0,127}));
    end for;
  end if;
  if nCooLoaH > 0 then
    // Connection to I/O variables
    for i in 1:nCooLoaH loop
      connect(heaFloCooLoaH[i].port_a, heaPorCoo[cooLoaH_idx[i]])
        annotation (Line(points={{-280,-150},{-288,-150},{-288,-100},{-300,-100}}, color={191,0,0}));
      connect(heaFloCooLoaH[i].Q_flow, Q_flowCooAct[cooLoaH_idx[i]])
        annotation (Line(points={{-270,-160},{-270,-294},{310,-294}}, color={0,0,127}));
    end for;
  end if;

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
end PartialBuilding;
