within Buildings.Utilities.Plotters.Examples.BaseClasses.Validation;
model CoolingCoilValve
  "Validation model for the cooling coil valve control sequence"
  extends Modelica.Icons.Example;

  parameter Real TOutCooCut(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 283.15
    "Lower outdoor air temperature limit for enabling cooling";

  parameter Real TSup(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 293.15
    "Supply air temperature";

  parameter Real TSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 289.15
    "Supply air temperature setpoint";

  parameter Real TSetMinLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 278.71
    "Minimum supply air temperature for defining the upper limit of the valve position";

  parameter Real TSetMaxLowLim(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 283.15
    "Maximum supply air temperature for defining the upper limit of the valve position";

  parameter Real LowTSupSet(
    final unit="F",
    final quantity = "ThermodynamicTemperature") = 280.37
    "Supply air temeprature setpoint to check the limiter functionality";

  parameter Real fanFee(
    final unit="1") = 0.60
    "Fan feedback";

  Buildings.Utilities.Plotters.Examples.BaseClasses.CoolingCoilValve cooVal(
    final reverseActing=false,
    final alc_int_k=1/100)
    "Cooling valve control sequence"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Utilities.Plotters.Examples.BaseClasses.CoolingCoilValve cooVal1(
    final reverseActing=false,
    final alc_int_k=1/100)
    "Cooling valve control sequence"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Utilities.Plotters.Examples.BaseClasses.CoolingCoilValve cooVal2(
    final reverseActing=false,
    final alc_int_k=1/100)
    "Cooling valve control sequence"
    annotation (Placement(transformation(extent={{140,78},{160,98}})));

  Buildings.Utilities.Plotters.Examples.BaseClasses.CoolingCoilValve cooVal3(
    final reverseActing=false,
    final alc_int_k=1/100)
    "Cooling valve control sequence"
    annotation (Placement(transformation(extent={{140,-42},{160,-22}})));


  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff(
    final k=TOutCooCut + 5)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup(
    final k=TSup)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet(
    final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uSupFan(
    final period=900)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uFanFee(
    final k=fanFee)
    "Supply fan feedback"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

// Tests disable if it is warm outside
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutBelowCutoff(
    final k=TOutCooCut - 5)
    "Outdoor air temperature is above the cutoff"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSup1(
    final k=TSup)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-160,-38},{-140,-18}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet1(
    final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan1(
    final k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uFanFee1(
    final k=fanFee)
    "Supply fan feedback"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

// Tests controler normal operation when supply air temperature is above limiter values
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff2(
    final k=TOutCooCut + 5)
    "Outdoor air temperature is above the cutoff"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet2(
    final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan2(
    final k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uFanFee2(
    final k=fanFee)
    "Supply fan feedback"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

// Tests controler operation when supply air temperature is within limiter values
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup2(
    final duration=1800,
    final height=4,
    final offset=TSupSet - 2,
    final startTime=0) "\"Supply air temperature\""
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTOutAboveCutoff1(
    final k=TOutCooCut + 5)
    "Outdoor air temperature is below the cutoff"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uTSupSet3(
    final k=LowTSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uSupFan3(
    final k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup3(
    final duration=1800,
    final startTime=0,
    final height=TSetMaxLowLim - TSetMinLowLim,
    final offset=TSetMinLowLim)
    "Supply air temperature source"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uFanFee3(
    final k=fanFee)
    "Supply fan feedback"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

equation
  connect(uTSup.y, cooVal.TSup)
    annotation (Line(points={{-139,90},{-90,90},{-90,98},{-41,98}},   color={0,0,127}));
  connect(uTSupSet.y, cooVal.TSupSet)
    annotation (Line(points={{-139,50},{-130,50},{-130,80},{-84,80},{-84,80},{-84,
          80},{-84,94},{-41,94}},                   color={0,0,127}));
  connect(uTOutAboveCutoff.y, cooVal.TOut)
    annotation (Line(points={{-99,50},{-82,50},{-82,92},{-82,92},{-82,92},{-82,93},
          {-41,93},{-41,90}},                       color={0,0,127}));
  connect(uFanFee.y, cooVal.uFanFee)
    annotation (Line(points={{-59,50},{-50,50},{-50,86},{-41,86}}, color={0,0,127}));
  connect(cooVal.uFanSta, uSupFan.y)
    annotation (Line(points={{-41,82},{-46,82},{-46,20},{-59,20}}, color={255,0,255}));
  connect(uTSup2.y, cooVal2.TSup)
    annotation (Line(points={{41,90},{74,90},{74,96},{139,96}}, color={0,0,127}));
  connect(uTSupSet2.y, cooVal2.TSupSet)
    annotation (Line(points={{41,50},{50,50},{50,82},{82,82},{82,92},{139,92}}, color={0,0,127}));
  connect(uTOutAboveCutoff2.y, cooVal2.TOut)
    annotation (Line(points={{81,50},{90,50},{90,88},{139,88}}, color={0,0,127}));
  connect(uFanFee2.y, cooVal2.uFanFee)
    annotation (Line(points={{121,50},{130,50},{130,84},{139,84}}, color={0,0,127}));
  connect(uSupFan2.y, cooVal2.uFanSta)
    annotation (Line(points={{121,20},{134,20},{134,80},{139,80}}, color={255,0,255}));
  connect(uTSup1.y, cooVal1.TSup)
    annotation (Line(points={{-139,-28},{-124,-28},{-124,-22},{-41,-22}}, color={0,0,127}));
  connect(uTSupSet1.y, cooVal1.TSupSet)
    annotation (Line(points={{-139,-70},{-132,-70},{-132,-32},{-116,-32},{-116,-26},
          {-41,-26}},                      color={0,0,127}));
  connect(uTOutBelowCutoff.y, cooVal1.TOut)
    annotation (Line(points={{-99,-70},{-94,-70},{-94,-30},{-41,-30}}, color={0,0,127}));
  connect(uFanFee1.y, cooVal1.uFanFee)
    annotation (Line(points={{-59,-70},{-54,-70},{-54,-34},{-41,-34}}, color={0,0,127}));
  connect(uSupFan1.y, cooVal1.uFanSta)
    annotation (Line(points={{-59,-100},{-50,-100},{-50,-38},{-41,-38}}, color={255,0,255}));
  connect(uTSup3.y, cooVal3.TSup)
    annotation (Line(points={{41,-30},{56,-30},{56,-24},{139,-24}}, color={0,0,127}));
  connect(uTSupSet3.y, cooVal3.TSupSet)
    annotation (Line(points={{41,-70},{46,-70},{46,-34},{64,-34},{64,-28},{139,-28}},
                               color={0,0,127}));
  connect(uTOutAboveCutoff1.y, cooVal3.TOut)
    annotation (Line(points={{81,-70},{90,-70},{90,-32},{139,-32}}, color={0,0,127}));
  connect(uFanFee3.y, cooVal3.uFanFee)
    annotation (Line(points={{121,-70},{130,-70},{130,-36},{139,-36}}, color={0,0,127}));
  connect(uSupFan3.y, cooVal3.uFanSta)
    annotation (Line(points={{121,-100},{128,-100},{128,-100},{134,-100},{134,-40},
          {139,-40}},                     color={255,0,255}));
annotation (experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/BaseClasses/Validation/CoolingCoilValve.mos"
    "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}),
            graphics={
        Rectangle(
          extent={{-176,116},{-14,4}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-158,18},{-102,6}},
          lineColor={0,0,127},
          textString="Supply fan signal"),
        Rectangle(
          extent={{-176,-4},{-14,-116}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-160,-102},{-96,-114}},
          lineColor={0,0,127},
          textString="TOut is above cuttoff - disable control"),
        Rectangle(
          extent={{14,116},{176,4}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{22,22},{116,2}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Normal operation above
the upper limit TSup range."),
        Rectangle(
          extent={{14,-4},{176,-116}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{22,-98},{116,-118}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Operation within the
          upper limit TSup range.")}),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal control sequece as implemented
in B33 on the main LBNL campus.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 19, 2019, by Michael Wetter:<br/>
Revised example.
</li>
<li>
April 10, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoilValve;
