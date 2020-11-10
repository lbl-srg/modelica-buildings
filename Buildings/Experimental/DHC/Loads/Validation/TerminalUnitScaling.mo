within Buildings.Experimental.DHC.Loads.Validation;
model TerminalUnitScaling
  "Validation of the scaling factor of the terminal unit model"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter Real facSca=10
    "Scaling factor";
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=273.15+40
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15,
    displayUnit="degC")=273.15+20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bLoaHea_nominal(
    min=273.15,
    displayUnit="degC")=T_aLoaHea_nominal+12
    "Load side ourtlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHeaUni_flow_nominal(
    min=0)=QHeaUni_flow_nominal/(T_bLoaHea_nominal-T_aLoaHea_nominal)/Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(
      Medium2.p_default,
      T_aLoaHea_nominal))
    "Load side mass flow rate at nominal conditions for 1 unit"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(
    min=0)=mLoaHeaUni_flow_nominal*facSca
    "Load side mass flow rate at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QHeaUni_flow_nominal(
    min=0)=1000
    "Design heating heat flow rate (>=0) for 1 unit"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=QHeaUni_flow_nominal*facSca
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Fluid.Sources.MassFlowSource_T supHeaWat(
    use_m_flow_in=true,
    redeclare package Medium=Medium1,
    use_T_in=false,
    T=T_aHeaWat_nominal,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,80})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium=Medium1,
    p=300000,
    nPorts=2)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={90,0})));
  BaseClasses.FanCoil2PipeHeating terUniNoSca(
    have_speVar=false,
    redeclare package Medium1=Medium1,
    redeclare package Medium2=Medium2,
    final QHea_flow_nominal=QHea_flow_nominal,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Terminal unit with no scaling"
    annotation (Placement(transformation(extent={{8,78},{32,102}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  BaseClasses.FanCoil2PipeHeating terUniSca(
    have_speVar=false,
    redeclare package Medium1=Medium1,
    redeclare package Medium2=Medium2,
    final QHea_flow_nominal=QHeaUni_flow_nominal,
    facSca=facSca,
    final mLoaHea_flow_nominal=mLoaHeaUni_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Terminal unit with scaling"
    annotation (Placement(transformation(extent={{6,-82},{30,-58}})));
  Fluid.Sources.MassFlowSource_T supHeaWat1(
    use_m_flow_in=true,
    redeclare package Medium=Medium1,
    use_T_in=false,
    T=T_aHeaWat_nominal,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=1.2*QHea_flow_nominal,
    duration=500)
    "Required heat flow rate"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(terUniNoSca.mReqHeaWat_flow,supHeaWat.m_flow_in)
    annotation (Line(points={{33,86},{40,86},{40,110},{-80,110},{-80,88},{-62,88}},color={0,0,127}));
  connect(supHeaWat.ports[1],terUniNoSca.port_aHeaWat)
    annotation (Line(points={{-40,80},{8,80}},color={0,127,255}));
  connect(terUniNoSca.port_bHeaWat,sinHeaWat.ports[1])
    annotation (Line(points={{32,80},{60,80},{60,2},{80,2}},color={0,127,255}));
  connect(terUniSca.port_bHeaWat,sinHeaWat.ports[2])
    annotation (Line(points={{30,-80},{60,-80},{60,-2},{80,-2}},color={0,127,255}));
  connect(supHeaWat1.ports[1],terUniSca.port_aHeaWat)
    annotation (Line(points={{-40,-80},{6,-80}},color={0,127,255}));
  connect(terUniSca.mReqHeaWat_flow,supHeaWat1.m_flow_in)
    annotation (Line(points={{31,-74},{40,-74},{40,-100},{-80,-100},{-80,-72},{-62,-72}},color={0,0,127}));
  connect(ram.y,terUniNoSca.QReqHea_flow)
    annotation (Line(points={{-78,0},{0,0},{0,88},{7,88}},color={0,0,127}));
  connect(ram.y,terUniSca.QReqHea_flow)
    annotation (Line(points={{-78,0},{0,0},{0,-72},{5,-72}},color={0,0,127}));
  connect(minTSet.y,terUniNoSca.TSetHea)
    annotation (Line(points={{-78,40},{-20,40},{-20,96},{7,96}},color={0,0,127}));
  connect(minTSet.y,terUniSca.TSetHea)
    annotation (Line(points={{-78,40},{-20,40},{-20,-64},{5,-64}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This example validates the scaling factor in terminal unit models inheriting from
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}})),
    __Dymola_Commands(
      file="Resources/Scripts/Dymola/Experimental/DHC/Loads/Validation/TerminalUnitScaling.mos" "Simulate and plot"));
end TerminalUnitScaling;
