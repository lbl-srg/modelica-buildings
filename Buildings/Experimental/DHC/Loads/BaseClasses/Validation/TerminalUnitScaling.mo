within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model TerminalUnitScaling
  "Validation of the scaling factor of the terminal unit model"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter Real facMul=2
    "Multiplier factor";
  parameter Modelica.Units.SI.Temperature T_aHeaWat_nominal(
    min=273.15,
    displayUnit="degC") = 273.15 + 40
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC") = T_aHeaWat_nominal - 5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_aLoaHea_nominal(
    min=273.15,
    displayUnit="degC") = 273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_bLoaHea_nominal(
    min=273.15,
    displayUnit="degC") = T_aLoaHea_nominal + 12
    "Load side ourtlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mLoaHeaUni_flow_nominal(min=0) =
    QHeaUni_flow_nominal/(T_bLoaHea_nominal - T_aLoaHea_nominal)/
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(Medium2.p_default,
    T_aLoaHea_nominal))
    "Load side mass flow rate at nominal conditions for 1 unit"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mLoaHea_flow_nominal(min=0) =
    mLoaHeaUni_flow_nominal*facMul
    "Load side mass flow rate at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaUni_flow_nominal(min=0) = 1000
    "Design heating heat flow rate (>=0) for 1 unit"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=
      QHeaUni_flow_nominal*facMul "Design heating heat flow rate (>=0)"
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
    nPorts=3)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={90,0})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeating ter(
    have_speVar=false,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final QHea_flow_nominal=QHea_flow_nominal,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Terminal unit with no multiplier"
    annotation (Placement(transformation(extent={{8,78},{32,102}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSet(k=293.15, y(
        final unit="K", displayUnit="degC")) "Temperature set point"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
 Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeating terUniMul(
    have_speVar=false,
    redeclare package Medium1=Medium1,
    redeclare package Medium2=Medium2,
    final QHea_flow_nominal=QHeaUni_flow_nominal,
    final facMul=facMul,
    final mLoaHea_flow_nominal=mLoaHeaUni_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Terminal unit with unit multiplier"
    annotation (Placement(transformation(extent={{6,-22},{30,2}})));
  Fluid.Sources.MassFlowSource_T supHeaWat1(
    use_m_flow_in=true,
    redeclare package Medium=Medium1,
    use_T_in=false,
    T=T_aHeaWat_nominal,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=1.2*QHea_flow_nominal,
    duration=500)
    "Required heat flow rate"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
 Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeating terUniMulZonMul(
    facMulZon=facMul,
    have_speVar=false,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final QHea_flow_nominal=QHeaUni_flow_nominal,
    final facMul=facMul,
    final mLoaHea_flow_nominal=mLoaHeaUni_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Terminal unit with unit multiplier and zone multiplier"
    annotation (Placement(transformation(extent={{8,-82},{32,-58}})));
  Fluid.Sources.MassFlowSource_T supHeaWat2(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=false,
    T=T_aHeaWat_nominal,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-80})));
equation
  connect(ter.mReqHeaWat_flow, supHeaWat.m_flow_in) annotation (Line(points={{33,
          86},{40,86},{40,110},{-80,110},{-80,88},{-62,88}}, color={0,0,127}));
  connect(supHeaWat.ports[1], ter.port_aHeaWat)
    annotation (Line(points={{-40,80},{8,80}}, color={0,127,255}));
  connect(ter.port_bHeaWat, sinHeaWat.ports[1]) annotation (Line(points={{32,80},
          {60,80},{60,2.66667},{80,2.66667}}, color={0,127,255}));
  connect(terUniMul.port_bHeaWat,sinHeaWat.ports[2])
    annotation (Line(points={{30,-20},{60,-20},{60,-2.22045e-16},{80,-2.22045e-16}},
                                                                color={0,127,255}));
  connect(supHeaWat1.ports[1],terUniMul.port_aHeaWat)
    annotation (Line(points={{-40,-20},{6,-20}},color={0,127,255}));
  connect(terUniMul.mReqHeaWat_flow,supHeaWat1.m_flow_in)
    annotation (Line(points={{31,-14},{40,-14},{40,-40},{-80,-40},{-80,-12},{-62,
          -12}},                                                                         color={0,0,127}));
  connect(ram.y, ter.QReqHea_flow)
    annotation (Line(points={{-78,20},{0,20},{0,88},{7,88}}, color={0,0,127}));
  connect(ram.y,terUniMul.QReqHea_flow)
    annotation (Line(points={{-78,20},{0,20},{0,-12},{5,-12}},
                                                            color={0,0,127}));
  connect(TSet.y, ter.TSetHea) annotation (Line(points={{-78,60},{-20,60},{-20,96},
          {7,96}}, color={0,0,127}));
  connect(TSet.y, terUniMul.TSetHea) annotation (Line(points={{-78,60},{-20,60},
          {-20,-4},{5,-4}}, color={0,0,127}));
  connect(terUniMulZonMul.port_bHeaWat, sinHeaWat.ports[3]) annotation (Line(
        points={{32,-80},{60,-80},{60,-2.66667},{80,-2.66667}}, color={0,127,255}));
  connect(supHeaWat2.ports[1], terUniMulZonMul.port_aHeaWat)
    annotation (Line(points={{-40,-80},{8,-80}}, color={0,127,255}));
  connect(TSet.y, terUniMulZonMul.TSetHea) annotation (Line(points={{-78,60},{-20,
          60},{-20,-64},{7,-64}}, color={0,0,127}));
  connect(ram.y, terUniMulZonMul.QReqHea_flow) annotation (Line(points={{-78,20},
          {0,20},{0,-72},{7,-72}}, color={0,0,127}));
  connect(terUniMulZonMul.mReqHeaWat_flow, supHeaWat2.m_flow_in) annotation (
      Line(points={{33,-74},{40,-74},{40,-100},{-80,-100},{-80,-72},{-62,-72}},
        color={0,0,127}));
  annotation (
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This example validates the use of the unit multiplier and zone multiplier factors
for models of terminal units inheriting from
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
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Validation/TerminalUnitScaling.mos" "Simulate and plot"));
end TerminalUnitScaling;
