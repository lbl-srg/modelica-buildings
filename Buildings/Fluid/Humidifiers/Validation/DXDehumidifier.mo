within Buildings.Fluid.Humidifiers.Validation;
model DXDehumidifier "Validation model for DX dehumidifier"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air
    "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.13545
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Time tStepAve = 3600
    "Time-step used to average out Modelica results for comparison with EPlus results";

  parameter Buildings.Fluid.Humidifiers.Data.DXDehumidifier.EnergyPlus per
    "Zone air DX dehumidifier curve"
    annotation (Placement(transformation(extent={{-40,66},{-20,86}})));

  Buildings.Fluid.Humidifiers.DXDehumidifier dxDeh(
    redeclare package Medium = Medium,
    mWat_flow_nominal=5.805556e-5,
    final addPowerToMedium=true,
    final mAir_flow_nominal=m_flow_nominal,
    final dp_nominal=100,
    final eneFac_nominal=3.412,
    final per=per)
    "DX dehumidifier"
    annotation (Placement(transformation(extent={{-50,-28},{-30,-8}})));

  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final use_T_in=true,
    nPorts=1)
    "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-82,-28},{-62,-8}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final T=294.15,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{0,-28},{-20,-8}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Utilities.IO.BCVTB.From_degC TIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanEna
    "Convert fan enable signal to real value"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=m_flow_nominal)
    "Calculate inlet air mass flow rate from component enable signal"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Modelica.Blocks.Sources.RealExpression watRemRatMod(
    final y=-dxDeh.deHum.mWat_flow)
    "Water removal mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Modelica.Blocks.Math.Mean mWatMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Modelica.Blocks.Math.Mean mWat_engPlu(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));

  Modelica.Blocks.Sources.RealExpression watRemRat_engPlu(
    final y=datRea.y[4])
    "Water removal mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Sources.RealExpression airHeaRatMod(
    final y=dxDeh.P)
    "Air heating rate (Modelica)"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Math.Mean PMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Modelica.Blocks.Math.Mean P_engPlu(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Modelica.Blocks.Sources.RealExpression dehPowRat_engPlu(
    final y=datRea.y[5])
    "DX dehumidifier power rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Sources.RealExpression dehHeaRatMod(
    final y=dxDeh.heaFloSen.Q_flow -
    dxDeh.deHum.mWat_flow*Buildings.Utilities.Psychrometrics.Constants.h_fg)
    "DX dehumidifier heating rate (Modelica)"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Modelica.Blocks.Math.Mean QHeaMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Modelica.Blocks.Math.Mean QHea_engPlu(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));

  Modelica.Blocks.Sources.RealExpression dehHeaRat_engPlu(
    final y=datRea.y[3])
    "DX dehumidifier heating rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Humidifiers/DXDehumidifier/DXDehumidifier.dat"),
    final columns=2:15,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final shiftTime(displayUnit="d"))
    "Reader for energy plus reference results"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=3600)
    "Sampling the part load ratio"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Logical.VariablePulse plrToPul(
    final period=3600)
    "Convert part load ratio signal to on-off signal"
    annotation (Placement(transformation(extent={{-88,60},{-68,80}})));

equation
  connect(watRemRatMod.y, mWatMod.u)
    annotation (Line(points={{41,40},{58,40}}, color={0,0,127}));
  connect(watRemRat_engPlu.y, mWat_engPlu.u)
    annotation (Line(points={{121,40},{138,40}}, color={0,0,127}));
  connect(airHeaRatMod.y, PMod.u)
    annotation (Line(points={{41,0},{58,0}}, color={0,0,127}));
  connect(dehPowRat_engPlu.y, P_engPlu.u)
    annotation (Line(points={{121,0},{138,0}}, color={0,0,127}));
  connect(dehHeaRatMod.y, QHeaMod.u)
    annotation (Line(points={{41,-40},{58,-40}}, color={0,0,127}));
  connect(dehHeaRat_engPlu.y, QHea_engPlu.u)
    annotation (Line(points={{121,-40},{138,-40}}, color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, boundary.Xi_in[1]) annotation (Line(points={{-99,-50},
          {-90,-50},{-90,-22},{-84,-22}},      color={0,0,127}));
  connect(TIn_K.Kelvin, boundary.T_in) annotation (Line(points={{-99,19.8},{-90,
          19.8},{-90,-14},{-84,-14}}, color={0,0,127}));
  connect(booToReaFanEna.y, gai.u)
    annotation (Line(points={{-138,-10},{-122,-10}}, color={0,0,127}));
  connect(datRea.y[11], TIn_K.Celsius) annotation (Line(points={{-139,70},{-130,
          70},{-130,19.6},{-122,19.6}}, color={0,0,127}));
  connect(datRea.y[10], toTotAirIn.XiDry) annotation (Line(points={{-139,70},{
          -130,70},{-130,-50},{-121,-50}}, color={0,0,127}));
  connect(gai.y, boundary.m_flow_in)
    annotation (Line(points={{-98,-10},{-84,-10}}, color={0,0,127}));
  connect(dxDeh.port_a, boundary.ports[1])
    annotation (Line(points={{-50,-18},{-62,-18}}, color={0,127,255}));
  connect(sin.ports[1], dxDeh.port_b)
    annotation (Line(points={{-20,-18},{-30,-18}}, color={0,127,255}));
  connect(datRea.y[8], sam.u)
    annotation (Line(points={{-139,70},{-122,70}}, color={0,0,127}));
  connect(sam.y, plrToPul.u)
    annotation (Line(points={{-98,70},{-90,70}}, color={0,0,127}));
  connect(plrToPul.y, booToReaFanEna.u) annotation (Line(points={{-66,70},{-56,
          70},{-56,40},{-170,40},{-170,-10},{-162,-10}}, color={255,0,255}));
  connect(plrToPul.y, dxDeh.uEna) annotation (Line(points={{-66,70},{-56,70},{
          -56,-14},{-51,-14}}, color={255,0,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-100},{180,100}})),
experiment(StartTime=12960000, StopTime=15120000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Validation/DXDehumidifier.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This is a validation model for the zone air DX dehumidifier model
<a href=\"modelica://Buildings.Fluid.Humidifiers.DXDehumidifier\">
Buildings.Fluid.Humidifiers.DXDehumidifier</a>. The inlet air conditions such as
the dry bulb temperature and humidity ratio are read from an EnergyPlus data file.
The module <code>plrToPul</code> translates the runtime fraction from EnergyPlus
to an on-off signal for the DX dehumidifier.
</p>
<p>
The generated plots show that DX dehumidifier removes an amount of water
that is similar to the reference EnergyPlus results, while consuming a similar amount
of power and adding similar amount of heat to the outlet air stream. The
comparison of the outlet air conditions such as the dry bulb temperature and humidity
ratio is not considered here because EnergyPlus adds the rejected heat directly
to the zone air balance and sets the dry bulb temperature of the dehumidifier&apos;s
outlet air equal to that of the inlet air.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2023, by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end DXDehumidifier;
