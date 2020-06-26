within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block Up
  "Generates a stage up signal"

  parameter Integer nSta = 5
    "Number of stages in the boiler plant";

  parameter Real fraNonConBoi = 0.9
    "Fraction of stage design capacity at which the efficiency condition
    is satisfied for non-condensing boilers"
    annotation(Dialog(group="Efficiency condition"));

  parameter Real fraConBoi = 1.5
    "Fraction of stage minimum capacity at which the efficiency condition is
    satisfied for condensing boilers"
    annotation(Dialog(group="Efficiency condition"));

  parameter Real sigDif = 0.1
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Advanced",
      group="Efficiency condition"));

  parameter Real delEffCon(
    final unit="s",
    final displayUnit="s") = 600
    "Enable delay for heating capacity and heating requirement"
    annotation(Dialog(group="Efficiency condition"));

  parameter Real TDif(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 10
    "Required temperature difference between setpoint and measured temperature
    for failsafe condition"
    annotation(Dialog(group="Failsafe condition"));

  parameter Real TDifHys(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 1
    "Temperature deadband for hysteresis loop in failsafe condition"
    annotation (Dialog(tab="Advanced",
      group="Failsafe condition"));

  parameter Real delFaiCon(
    final unit="s",
    final displayUnit="s") = 900
    "Enable delay for temperature"
    annotation(Dialog(group="Failsafe condition"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-140,-190},{-100,-150}}),
      iconTransformation(extent={{-140,-170},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAvaCur
    "Current stage availability status"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta]
    "Boiler-type vector specifying boiler-type in each stage"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaUp
    "Index of next available higher stage"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapUpMin(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Minimum heating capacity of next available stage"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDes(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Design heating capacity of the current stage"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Calculated heating capacity requirement"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final unit="m3/s",
    final displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot water flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VUpMinSet_flow(
    final unit="m3/s",
    final displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum flow setpoint for next available higher stage"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaUp
    "Stage up signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));


protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition effCon(
    final nSta=nSta,
    final fraNonConBoi=fraNonConBoi,
    final fraConBoi=fraConBoi,
    final delCapReq=delEffCon,
    final sigDif=sigDif)
    "Efficiency condition for staging up"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition faiSafCon(
    final delEna=delFaiCon,
    final TDif=TDif,
    final TDifHys=TDifHys)
    "Failsafe condition for staging up and down"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=3)
    "Logical Or"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(effCon.uTyp, uTyp)
    annotation (Line(points={{-62,34},{-72,34},{-72,-20},{-120,-20}},
      color={255,127,0}));
  connect(effCon.uAvaUp, uAvaUp)
    annotation (Line(points={{-62,31},{-64,31},{-64,-50},{-120,-50}},
      color={255,127,0}));
  connect(faiSafCon.TSupSet, THotWatSupSet)
    annotation (Line(points={{-62,-85},{-80,-85},{-80,-80},{-120,-80}},
      color={0,0,127}));
  connect(faiSafCon.TSup, THotWatSup)
    annotation (Line(points={{-62,-90},{-80,-90},{-80,-110},{-120,-110}},
      color={0,0,127}));
  connect(mulOr.y, yStaUp)
    annotation (Line(points={{62,0},{120,0}},
      color={255,0,255}));
  connect(effCon.yEffCon, mulOr.u[1])
    annotation (Line(points={{-38,40},{10,40},{10,4.66667},{38,4.66667}},
      color={255,0,255}));
  connect(not1.u, uAvaCur)
    annotation (Line(points={{-62,-140},{-120,-140}},
      color={255,0,255}));
  connect(faiSafCon.yFaiCon, mulOr.u[2]) annotation (Line(points={{-38,-90},{0,-90},
          {0,0},{38,0}}, color={255,0,255}));
  connect(not1.y, mulOr.u[3]) annotation (Line(points={{-38,-140},{10,-140},{10,
          -4.66667},{38,-4.66667}}, color={255,0,255}));
  connect(effCon.uCapReq, uCapReq) annotation (Line(points={{-62,49},{-64,49},{-64,
          130},{-120,130}}, color={0,0,127}));
  connect(effCon.uCapDes, uCapDes) annotation (Line(points={{-62,46},{-72,46},{-72,
          100},{-120,100}}, color={0,0,127}));
  connect(effCon.uCapUpMin, uCapUpMin) annotation (Line(points={{-62,43},{-80,43},
          {-80,70},{-120,70}}, color={0,0,127}));
  connect(effCon.VHotWat_flow, VHotWat_flow)
    annotation (Line(points={{-62,40},{-120,40}}, color={0,0,127}));
  connect(effCon.VUpMinSet_flow, VUpMinSet_flow) annotation (Line(points={{-62,37},
          {-80,37},{-80,10},{-120,10}}, color={0,0,127}));
  connect(uStaChaProEnd, faiSafCon.uStaChaProEnd) annotation (Line(points={{-120,
          -170},{-70,-170},{-70,-95},{-62,-95}},     color={255,0,255}));
  connect(uStaChaProEnd, effCon.uStaChaProEnd) annotation (Line(points={{-120,-170},
          {-70,-170},{-70,-70},{-59,-70},{-59,28}}, color={255,0,255}));

  annotation (defaultComponentName = "staUp",
    Icon(coordinateSystem(extent={{-100,-160},{100,160}}),
         graphics={
           Rectangle(
             extent={{-100,-160},{100,160}},
             lineColor={0,0,127},
             fillColor={255,255,255},
             fillPattern=FillPattern.Solid),
           Text(
             extent={{-120,206},{100,168}},
             lineColor={0,0,255},
             textString="%name"),
           Rectangle(extent={{-80,-10},{-20,-22}}, lineColor={0,0,127}),
           Rectangle(extent={{-80,-28},{-20,-40}}, lineColor={0,0,127}),
           Rectangle(extent={{-76,-22},{-72,-28}}, lineColor={0,0,127}),
           Rectangle(extent={{-28,-22},{-24,-28}}, lineColor={0,0,127}),
           Rectangle(extent={{20,-10},{80,-22}}, lineColor={0,0,127}),
           Rectangle(extent={{20,-28},{80,-40}}, lineColor={0,0,127}),
           Rectangle(extent={{24,-22},{28,-28}}, lineColor={0,0,127}),
           Rectangle(extent={{72,-22},{76,-28}}, lineColor={0,0,127}),
           Rectangle(extent={{20,30},{80,18}}, lineColor={0,0,127}),
           Rectangle(extent={{20,12},{80,0}}, lineColor={0,0,127}),
           Rectangle(extent={{24,18},{28,12}}, lineColor={0,0,127}),
           Rectangle(extent={{72,18},{76,12}}, lineColor={0,0,127}),
           Line(points={{130,-48}}, color={0,0,127})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-180},{100,140}})),
    Documentation(info="<html>
      <p>
      Outputs a boolean stage up signal <code>y</code> based on the 
      various plant operation conditions that get provided as input signals. 
      Implemented according to 1711 March 2020 Draft, section 5.3.3.10.
      and applies to all boiler plants defined in RP-1711. Timer reset has been
      implemented according to 5.3.3.10.2.
      </p>
      <p>
      The stage up signal <code>yStaUp</code> becomes <code>true</code> when:
      </p>
      <ul>
      <li>
      Current stage becomes unavailable, or
      </li>
      <li>
      Efficiency condition is true, or
      </li>
      <li>
      Failsafe condition is true.
      </li>
      </ul>
      <p align=\"center\">
      <img alt=\"Validation plot for EfficiencyCondition1\"
      src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Up1.png\"/>
      <br/>
      Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Up\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Up</a> with the block being activated by the efficiency condition.
      </p>
      <p align=\"center\">
      <img alt=\"Validation plot for EfficiencyCondition1\"
      src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Up2.png\"/>
      <br/>
      Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Up\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Up</a> with the block being activated by the failsafe condition.
      </p>
      <p align=\"center\">
      <img alt=\"Validation plot for EfficiencyCondition1\"
      src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Up3.png\"/>
      <br/>
      Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Up\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Up</a> with the block being activated by the unavailabaility
      of current stage.
      </p>
      </html>",
      revisions="<html>
      <ul>
      <li>
      May 25, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end Up;
