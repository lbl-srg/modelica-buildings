within Buildings.Utilities.Plotters.Examples;
model ControlsVerification_CoolingCoilValve
  "Validation model for the cooling coil control subsequence with recorded data trends"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    columns={3},
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve/OA_Temp.mos"))
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="SA_Clg_Stpt",
    columns={3},
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve/SA_Clg_Stpt.mos"))
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Modelica.Blocks.Sources.CombiTimeTable coolingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="Clg_Coil_Valve",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve/Clg_Coil_Valve.mos"))
    "Output of the cooling valve control subsequence"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable fanFeedback(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="VFD_Fan_Feedback",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve/VFD_Fan_Feedback.mos"))
    "Fan feedback"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Modelica.Blocks.Sources.CombiTimeTable fanStatus(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="VFD_Fan_Enable",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve/VFD_Fan_Enable.mos"))
    "Fan status"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="Supply_Air_Temp",
    columns={3},
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve/Supply_Air_Temp.mos"))
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Utilities.Plotters.Examples.BaseClasses.CoolingCoilValve cooValSta(
    reverseActing=false,
    TSupHighLim(displayUnit="degC"),
    TSupHigLim(displayUnit="degC"),
    TOutDelta(displayUnit="degC"),
    TOutCooCut(displayUnit="degC") = 50*(5/9) - 32*(5/9) + 273.15)
    "Cooling valve position control sequence"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=0.5)
    "Converter to boolean"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter percConv(k=0.01)
    "Converter from percentage"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter percConv1(k=0.01)
    "Converter from percentage"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Buildings.Controls.OBC.UnitConversions.From_degF from_degF
    "Unit Converter"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Controls.OBC.UnitConversions.From_degF from_degF1
    "Unit Converter"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.UnitConversions.From_degF from_degF2
    "Unit Converter"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.UnitConversions.To_degC to_degC
    "Unit Converter"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.UnitConversions.To_degC to_degC1
    "Unit Converter"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.UnitConversions.To_degC to_degC2
    "Unit Converter"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

protected
  Buildings.Utilities.IO.Files.CSVWriter csvWriter(
    samplePeriod=5,
    nin=2,
    headerNames={"Trended","Modeled"})
    "Writes trended and modeled cooling coil valve position to CSV"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=300,
    fileName="coolingCoilValve_validationPlots.html")
    "Cooling valve control sequence validation"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Utilities.Plotters.Scatter correlation(
    n=1,
    legend={"Modeled cooling valve signal"},
    xlabel="Trended cooling valve signal",
    title="Modeled result/recorded trend correlation")
    "Reference vs. output results"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    n=2,
    legend={"Cooling valve control signal, modeled","Cooling valve control signal, trended"},
    title="Cooling valve control signal: reference trend vs. modeled result")
    "Cooling valve control signal: reference trend vs. modeled result"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

  Buildings.Utilities.Plotters.TimeSeries timSerInp(
    n=3,
    legend={"Supply air temperature, [degC]","Supply air temperature setpoint, [degC]",
        "Outdoor air temperature, [degC]"},
    title="Trended input signals")
    "Trended input signals"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

equation
  connect(cooValSta.yCooVal, timSerRes.y[1])
    annotation (Line(points={{41,0},{70,0},{70,84},{98,84},{98,91}},
    color={0,0,127}));
  connect(cooValSta.yCooVal, correlation.y[1])
    annotation (Line(points={{41,0},{70,0},{70,30},{98,30}}, color={0,0,127}));
  connect(percConv.y, timSerRes.y[2])
    annotation (Line(points={{-78,90},{98,90},{98,89}},
    color={0,0,127}));
  connect(percConv.y, correlation.x)
    annotation (Line(points={{-78,90},{50,90},{50,22},{98,22}},color={0,0,127}));
  connect(greThr.y, cooValSta.uFanSta) annotation (Line(points={{-78,-90},{0,
          -90},{0,-8},{19,-8}}, color={255,0,255}));
  connect(percConv1.y, cooValSta.uFanFee)
    annotation (Line(points={{-78,-60},{-6,-60},{-6,-4},{19,-4}},color={0,0,127}));
  connect(coolingValveSignal.y[1], percConv.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(fanFeedback.y[1], percConv1.u)
    annotation (Line(points={{-119,-60},{-102,-60}}, color={0,0,127}));
  connect(fanStatus.y[1], greThr.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={0,0,127}));
  connect(percConv.y,csvWriter. u[1])
    annotation (Line(points={{-78,90},{50,90},{50,-29},{100,-29}}, color={0,0,127}));
  connect(cooValSta.yCooVal,csvWriter. u[2]) annotation (Line(points={{41,0},{
          70,0},{70,-31},{100,-31}}, color={0,0,127}));
  connect(TSupply_F.y[1], from_degF.u)
    annotation (Line(points={{-119,50},{-102,50}}, color={0,0,127}));
  connect(from_degF.y, to_degC.u) annotation (Line(points={{-78,50},{-70,50},{
          -70,70},{-62,70}},
                         color={0,0,127}));
  connect(TSupSetpoint_F.y[1], from_degF1.u)
    annotation (Line(points={{-119,20},{-102,20}}, color={0,0,127}));
  connect(from_degF1.y, to_degC1.u) annotation (Line(points={{-78,20},{-70,20},
          {-70,30},{-62,30}}, color={0,0,127}));
  connect(TOut_F.y[1], from_degF2.u)
    annotation (Line(points={{-119,-20},{-102,-20}}, color={0,0,127}));
  connect(from_degF2.y, to_degC2.u) annotation (Line(points={{-78,-20},{-72,-20},
          {-72,-10},{-62,-10}}, color={0,0,127}));
  connect(from_degF2.y, cooValSta.TOut) annotation (Line(points={{-78,-20},{-72,
          -20},{-72,-30},{-10,-30},{-10,0},{19,0}},color={0,0,127}));
  connect(from_degF1.y, cooValSta.TSupSet) annotation (Line(points={{-78,20},{
          -70,20},{-70,10},{-10,10},{-10,4},{19,4}},
                                                color={0,0,127}));
  connect(from_degF.y, cooValSta.TSup) annotation (Line(points={{-78,50},{0,50},
          {0,8},{19,8}},   color={0,0,127}));
  connect(to_degC.y, timSerInp.y[1]) annotation (Line(points={{-38,70},{-30,70},
          {-30,61.3333},{98,61.3333}},color={0,0,127}));
  connect(to_degC1.y, timSerInp.y[2]) annotation (Line(points={{-38,30},{-30,30},
          {-30,60},{98,60}},color={0,0,127}));
  connect(to_degC2.y, timSerInp.y[3]) annotation (Line(points={{-38,-10},{-20,
          -10},{-20,58.6667},{98,58.6667}},
                                      color={0,0,127}));
  annotation(experiment(Tolerance=1e-06, StopTime = 315710),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/ControlsVerification_CoolingCoilValve.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal subsequence implemented
in Building 33 on the main LBNL campus. Data used for the validation are measured
input and output trends with 5s time steps, starting at
2018-06-07 00:00:00 PDT. The trends were exported from the ALC EIKON webserver.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}})));
end ControlsVerification_CoolingCoilValve;
